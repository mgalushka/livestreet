<?php

class PluginPremoderation_ModulePremoderation extends Module{		

	protected $oMapper;
	protected $oUserCurrent;
		
	//**************************************************************************************************
	public function Init(){		
		$this->oMapper 		= Engine::GetMapper(__CLASS__);
		$this->oUserCurrent	= $this->User_GetUserCurrent();
	}
	
	//**************************************************************************************************
	public function AddTopic($oTopic){
		$this->oMapper->AddTopic($oTopic);
	}
	
	//**************************************************************************************************
	public function GetPremoderatedTopics($iPage, $iPerPage, $iUserId){
		$aTopicsId	= $this->oMapper->GetPremoderatedTopics($iPage, $iPerPage, $iUserId);
		
		$aResult = array();
		if($aTopicsId){
			foreach($aTopicsId as $iTopicId){
				$oTopic	= $this->Topic_GetTopicById($iTopicId['topic_id']);
				if($oTopic) $aResult[] = $oTopic;
			}			
		}
		return $aResult;
	}
	
	//**************************************************************************************************
	public function GetPremoderatedTopicsCount($iUserId = 0){
		$aResult = $this->GetPremoderatedTopics(1, 99999, $iUserId);
		return count($aResult);
	}
	
	//**************************************************************************************************
	public function NoticeNewTopicOnModeration($oTopic){
		$oTopic			= $this->Topic_GetTopicById($oTopic->getId());
		$oBlog			= $oTopic->getBlog();
		$sTopicUrl		= $oTopic->getUrl();
		$sTopicTitle	= $oTopic->getTitle();
	
		$sNoticeTitle 	= $this->Lang_Get('plugin.premoderation.premoderation_notice_title');
		$sNoticeBody 	= $this->Lang_Get('plugin.premoderation.premoderation_notice_body') . "<a href='".$sTopicUrl."'>".$sTopicTitle."</a>";
		$oSender 		= $this->User_GetUserById($oTopic->getUserId());
	
		$aReceivers		= array_values($this->GetUsersCanModerateBlog($oBlog));
		$this->Talk_SendTalk($sNoticeTitle, $sNoticeBody, $oSender, $aReceivers, true, true);
	}
	
	//**************************************************************************************************
	public function NoticeTopicApproved($oTopic){
		$iAuthorId		= $oTopic->getUserId();
		$oAuthor		= $this->User_GetUserById($iAuthorId);
		
		$this->Mail_SetAdress($oAuthor->getMail(),$oAuthor->getLogin());
		$this->Mail_SetSubject($oTopic->getTitle());
		$this->Mail_SetBody($this->Lang_Get('plugin.premoderation.premoderation_notice_topicapproved'));
		$this->Mail_setHTML();
		$this->Mail_Send();		
	}
	
	//**************************************************************************************************
	public function NoticeTopicDisapproved($oTopic, $sReason){
		$iAuthorId		= $oTopic->getUserId();
		$oAuthor		= $this->User_GetUserById($iAuthorId);
		
		$this->Mail_SetAdress($oAuthor->getMail(),$oAuthor->getLogin());
		$this->Mail_SetSubject($oTopic->getTitle());
		$this->Mail_SetBody($this->Lang_Get('plugin.premoderation.premoderation_notice_topicadispproved').' '.$sReason);
		$this->Mail_setHTML();
		$this->Mail_Send();	
	}
	
	//**************************************************************************************************
	public function GetPremoderatedTopicStatsByTopicId($iTopicId){
		return $this->oMapper->GetPremoderatedTopicStatsByTopicId($iTopicId);
	}
	
	//**************************************************************************************************
	public function RemovePremoderationMark($iTopicId){
		$aResult	= $this->oMapper->RemovePremoderationMark($iTopicId);
		return $aResult;
	}
	
	//**************************************************************************************************
	public function IsTopicTextContainLinks($oTopic){
		return !(strpos($oTopic->getText(), "http://") === false);
	}
	
	//**************************************************************************************************
	// Возвращает массив пользователей, которые могут модерировать блог
	// Это все администраторы сайта, администраторы блога, модераторы блога
	// Ключи - iUserId, значения - oUser
	public function GetUsersCanModerateBlog($oBlog){
		$aUsers		= array();
		
		// Администраторы
		$aAdminIdList = $this->oMapper->GetAdminIdList();
		foreach($aAdminIdList as $aAdminIdListRow){
			$iUserId	= $aAdminIdListRow['user_id'];		
			$oUser		= $this->User_GetUserById($iUserId);
			$aUsers[$iUserId] = $oUser;		
		}
	
			$iBlogId	= $oBlog->getId();
			
			// Модераторы блогов
			$aBlogModerators	= $this->Blog_GetBlogUsersByBlogId($iBlogId, ModuleBlog::BLOG_USER_ROLE_MODERATOR);
			$aBlogModerators	= $aBlogModerators['collection'];
			foreach($aBlogModerators as $oBlogUser){
				$aUsers[$oBlogUser->getUserId()] = $oBlogUser->getUser();	
			}
			
			// Администраторы блогов
			$aBlogAdministrators	= $this->Blog_GetBlogUsersByBlogId($iBlogId, ModuleBlog::BLOG_USER_ROLE_ADMINISTRATOR);
			$aBlogAdministrators	= $aBlogAdministrators['collection'];
			foreach($aBlogAdministrators as $oBlogUser){
				$aUsers[$oBlogUser->getUserId()] = $oBlogUser->getUser();
			}
		
		return $aUsers;
	}
	
	//**************************************************************************************************
	public function ShouldTopicBeModerated($aParams){
		$oTopic		= $aParams['oTopic'];
		$oBlog		= $aParams['oBlog'];
		$iBlogId	= $oBlog->getId();
		$oUser		= $this->User_GetUserById($oTopic->getUserId());
		$iUserId	= $oUser->getId();
		
		$bTopicShouldBePremoderated = false;
		
		// На модерацию попадают только опубликованные топики
		if($oTopic->getPublish() == 0) return false;
				
		// Топики администраторов и модераторов блога топики не должны попадать на модерацию
		$aNonModeratedUsers	= $this->GetUsersCanModerateBlog($oBlog);
		if( array_key_exists($iUserId, $aNonModeratedUsers) ) return false;
				
				
		// Включена премодерация всех топиков в зависимости от кармы пользователя
		if( Config::Get('plugin.premoderation.AllTopicsPremoderationEnabled') ){
			if($oUser->getRating() < Config::Get('plugin.premoderation.AllTopicsPremoderationKarmaLimit')){
				$bTopicShouldBePremoderated = true;
			}
		}
		
		// Включена премодерация топиков, содержащих ссылки
		if( Config::Get('plugin.premoderation.TopicsWithLinksPremoderationEnabled') ){
			if($oUser->getRating() < Config::Get('plugin.premoderation.TopicsWithLinksPremoderationKarmaLimit')){
				if($this->PluginPremoderation_Premoderation_IsTopicTextContainLinks($oTopic)) 
					$bTopicShouldBePremoderated = true;
			}
		}
		
		// Топик публикуется в блог, где включена премодерация
		$sBlogType				= $oBlog->getType();
		$aModeratedBlogs		= Config::Get('plugin.premoderation.BigBrothersBlogs');
		$bTopicInModeratedBlog	= in_array($sBlogType, $aModeratedBlogs);
		
		return ($bTopicShouldBePremoderated and $bTopicInModeratedBlog);
	}
	
	//**************************************************************************************************
	public function ShouldTopicBeVisible($aParams){
		$oTopic		= $aParams['oTopic'];
		$oBlog		= $oTopic->getBlog();
		$bVisible	= true;
		
		$aStats		= $this->PluginPremoderation_Premoderation_GetPremoderatedTopicStatsByTopicId($oTopic->getId());
	
		if($aStats){
			$bVisible 			= false;
			$aAdvancedUsers		= $this->GetUsersCanModerateBlog($oBlog);
			$aAdvancedUsers[$oTopic->getUserId()] = '';
				
			if($this->User_IsAuthorization()){
				$oUserCurrent = $this->User_GetUserCurrent();
				if( array_key_exists($oUserCurrent->getId(), $aAdvancedUsers) ) $bVisible = true;
			} 		
		}
		
		return $bVisible;
	}
	
	//**************************************************************************************************
	public function CanCurrentUserPremoderateTopic($oTopic){
		
		if($this->oUserCurrent){
			$oBlog		= $oTopic->getBlog();
			$aUsers		= $this->GetUsersCanModerateBlog($oBlog);
			if( in_array($this->oUserCurrent->getId(), array_keys($aUsers)) ) return true;
		}
		
		return false;
	}
	
	//**************************************************************************************************
	//**************************************************************************************************
	
	//**************************************************************************************************
	public function SubmitCommentToModeration($aParams){
		
		$oComment	= $aParams['oCommentNew'];
		$oTopic		= $aParams['oTopic'];
		
		if(	$this->ShouldCommentBeModerated($oComment) ){
			
		}
	
	}
	
	//**************************************************************************************************
	public function ShouldCommentBeModerated($oComment){
	
	}
	
}
?>