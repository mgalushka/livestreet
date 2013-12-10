<?php

class PluginPremoderation_ActionPremoderation extends ActionPlugin{
	
	protected $oUserCurrent;

	//***************************************************************************************
	public function Init(){
		if ($this->User_IsAuthorization()){
			$this->oUserCurrent = $this->User_GetUserCurrent();
		}else return Router::Action('error');
		
		$this->SetDefaultEvent('main');
		$this->Viewer_AppendStyle(Plugin::GetTemplatePath('premoderation')."css/main.css");
	}
	
	//***************************************************************************************	
	protected function RegisterEvent(){
		$this->AddEvent('main',			'EventMain');
		$this->AddEvent('approve',		'EventApprove');
		$this->AddEvent('disapprove',	'EventDisapprove');
	}
	
	//***************************************************************************************
	protected function Redirect($sEvent = null, $sParam = null, $sMessage = null, $sError = null){
		$sPath	= Router::GetPath(Config::Get('plugin.premoderation.url'));
		if(!empty($sEvent)) $sPath = $sPath.$sEvent.'/';
		if(!empty($sParam)) $sPath = $sPath.$sParam.'/';
		
		if(!empty($sMessage))	$this->Message_AddNotice($sMessage,'',true);
		if(!empty($sError))		$this->Message_AddErrorSingle($sError,'',true);
		
		return Router::Location($sPath);		
	}
	
	//***************************************************************************************
	protected function CheckAdmin(){
		if($this->oUserCurrent){
			if(!$this->oUserCurrent->isAdministrator()) return Router::Location(Router::GetPath('error'));
		}else return Router::Location(Router::GetPath('error'));
	}
	
	//***************************************************************************************
	protected function CanCurrentUserModerateTopic($oTopic){
		$this->CheckUserLogin();
		if( !$this->PluginPremoderation_Premoderation_CanCurrentUserPremoderateTopic($oTopic) )$this->Error();
	}
	
	//***************************************************************************************
	protected function CheckUserLogin(){
		if(!$this->oUserCurrent) return Router::Location(Router::GetPath('error'));
	}
	
	//***************************************************************************************
	protected function Error(){
		return Router::Location(Router::GetPath('error'));
	}
	
	//***************************************************************************************
	protected function EventMain(){	
		$this->CheckUserLogin();
		$iByUserId = $this->oUserCurrent->getId();
		
		$iPage		= (int) str_replace('page', '', $this->GetParam(0));
		$iPerPage	= Config::Get('module.topic.per_page');
		if(!$iPage) $iPage	= 1;
	
		$aTopics	= $this->PluginPremoderation_Premoderation_GetPremoderatedTopics($iPage, $iPerPage, $iByUserId);
		$iCount		= $this->PluginPremoderation_Premoderation_GetPremoderatedTopicsCount($iByUserId);

		$aPaging	= $this->Viewer_MakePaging($iCount, $iPage, $iPerPage, 4, Router::GetPath('premoderation').'main');
		
		$this->Viewer_Assign('aTopics',$aTopics);
		$this->Viewer_Assign('aPaging',$aPaging);
	}
	
	//***************************************************************************************
	protected function EventApprove(){
		
		$iTopicId	= $this->GetParam(0);
		$oTopic		= $this->Topic_GetTopicById($iTopicId);
		
		if($oTopic){
			$this->CanCurrentUserModerateTopic($oTopic);
			
			$oAuthor	= $this->User_GetUserById($oTopic->getUserId());
			$oBlog		= $oTopic->getBlog();
		
			$this->PluginPremoderation_Premoderation_RemovePremoderationMark($iTopicId);
			
			// Если между админом и пользователем велся в топике разговор,
			// то подчищаем его
			if( Config::Get('plugin.premoderation.RemoveCommentsAfterModeration') ){
				$this->Comment_DeleteCommentByTargetId($iTopicId, 'topic');
				$oTopic->setCommentCount(0);
			}
			
			// Почистили кеш
			$this->Cache_Clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array('topic_update',"topic_update_user_{$oTopic->getUserId()}","topic_update_blog_{$oTopic->getBlogId()}"));
			$this->Cache_Delete("topic_{$oTopic->getId()}");
			
			// Отправили автору топика благую весть о прохождении модерации
			if(Config::Get('plugin.premoderation.SendNoticeToTopicAuthor')){
				$this->PluginPremoderation_Premoderation_NoticeTopicApproved($oTopic);				
			}
			
			// Изменяем дату добавления топика на дату прохождения модерации
			$oTopic->setDateAdd(date("Y-m-d H:i:s"));
			$this->Topic_UpdateTopic($oTopic);
			
			// Добавим событие в ленту и отправим уведомления подписчикам блогов
			if ($oTopic->getPublish()==1 and $oBlog->getType()!='personal') {
				$this->Topic_SendNotifyTopicNew($oBlog, $oTopic, $oAuthor);
			}
			$this->Stream_write($oTopic->getUserId(), 'add_topic', $oTopic->getId(),$oTopic->getPublish() && $oBlog->getType()!='close');
			
		}
		$this->Redirect();
	}
	
	//***************************************************************************************
	protected function EventDisapprove(){

		$iForm		= getRequest('form');
		$iTopicId	= $this->GetParam(0);
		
		if(!empty($iForm)){
			$oTopic		= $this->Topic_GetTopicById($iTopicId);
			$sReason	= getRequest('reason');
			if($oTopic){
				$this->CanCurrentUserModerateTopic($oTopic);
				
				$this->PluginPremoderation_Premoderation_RemovePremoderationMark($iTopicId);
				$this->Topic_DeleteTopic($oTopic);
				if(Config::Get('plugin.premoderation.SendNoticeToTopicAuthor')){
					$this->PluginPremoderation_Premoderation_NoticeTopicDisapproved($oTopic, $sReason);				
				}
			}
			$this->Redirect();
		}else{
			$this->Viewer_Assign('iTopicId', $iTopicId);
		}
	}

	//***************************************************************************************
	protected function EventDebug(){
	}
	
	//***************************************************************************************
	public function EventShutdown(){
	}
}
?>