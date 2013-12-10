<?php

class PluginPremoderation_HookPremoderation extends Hook {

	//********************************************************************************************************
	public function RegisterHook(){
	
		if(Config::Get('db.table.geo_region')){
			// LS 1.0
			$this->AddHook('template_main_menu_item',	'MainMenu');
		}else $this->AddHook('template_main_menu',		'MainMenu'); //LS 0.5
		
		
		$this->AddHook('template_topic_show_info',	'TopicShowInfo');
		
		$this->AddHook('topic_add_after',	'SubmitTopicToModeration');
		$this->AddHook('topic_edit_after',	'SubmitTopicToModeration');
		
		$this->AddHook('topic_show',		'TopicShow');
		$this->AddHook('topic_delete_after', 'TopicDeleteAfter');
		
		//$this->AddHook('comment_add_after', 'SubmitCommentToModeration');
	}

	//********************************************************************************************************
	// Добавляем пункт в главное меню при наличии топиков для модерации для 
	// текущего пользователя
	public function MainMenu(){
		if($this->User_IsAuthorization()){
			$oUserCurrent = $this->User_GetUserCurrent();
			if($oUserCurrent){
				$iByUserId		= $oUserCurrent->getId();
				$iTopicsCount	= $this->PluginPremoderation_Premoderation_GetPremoderatedTopicsCount($iByUserId);
				if($iTopicsCount){
							$this->Viewer_Assign('iTopicsCount', $iTopicsCount);
					return 	$this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__).'main_menu.tpl');
				}
				
			}
		}		
	}
	
	//********************************************************************************************************
	// Выводим контролы для управления статусом модерации (принять / отклонить)
	public function TopicShowInfo($aParams){
		$oTopic				= $aParams['topic'];
		$iTopicId			= $oTopic->getId();
		$aRequestStats		= $this->PluginPremoderation_Premoderation_GetPremoderatedTopicStatsByTopicId($iTopicId);
		if($aRequestStats){
			if($this->PluginPremoderation_Premoderation_CanCurrentUserPremoderateTopic($oTopic)){
				$this->Viewer_Assign('iTopicId',$iTopicId);
				return $this->Viewer_Fetch(Plugin::GetTemplatePath(__CLASS__).'topic_info.tpl');
			}
		}
	}
	
	//********************************************************************************************************
	// Топики на модерации видны только администраторам, модераторам и автору
	public function TopicShow($aParams){
		$bShouldTopicBeVisible	= $this->PluginPremoderation_Premoderation_ShouldTopicBeVisible($aParams);
		if( !$bShouldTopicBeVisible ) return Router::Location(Router::GetPath('error'));
	}
	
	
	//********************************************************************************************************
	// После добавления топика проверяем, нужно ли ставить его в очередь на модерацию
	public function SubmitTopicToModeration($aParams){
		$oTopic						= $aParams['oTopic'];
		$bTopicShouldBePremoderated	= $this->PluginPremoderation_Premoderation_ShouldTopicBeModerated($aParams);
		
		// Если топику поставили флаг премодерируемости, то отправляем в список
		// премодерируемых, показываем нотис пользователю и создаем диалог пользователя и
		// администраторов
		if($bTopicShouldBePremoderated){
			$this->PluginPremoderation_Premoderation_AddTopic($oTopic);
			
			$sNotice = $this->Lang_Get('plugin.premoderation.premoderation_wait_until_premoderate');
			$this->Message_AddNotice($sNotice, '', true);
			
			if(Config::Get('plugin.premoderation.SendNoticeToAdmin')){
				$this->PluginPremoderation_Premoderation_NoticeNewTopicOnModeration($oTopic);
			}
		}
	
	}
	
	//********************************************************************************************************
	// При ручном удалении топика удаляем его из таблицы премодерации
	public function TopicDeleteAfter($aParams){
		$oTopic		= $aParams['oTopic'];
		$iTopicId	= $oTopic->getId();
		
		return $this->PluginPremoderation_Premoderation_RemovePremoderationMark($iTopicId);		
	}
	
	//********************************************************************************************************
	public function SubmitCommentToModeration($aParams){
		$this->PluginPremoderation_Premoderation_SubmitCommentToModeration($aParams);
	}
}

?>