<?php

class PluginPremoderation_ModulePremoderation_MapperPremoderation extends Mapper{

	//**************************************************************************************************
	public function AddTopic($oTopic){
		$iTopicId	= $oTopic->getId();
		$iAuthorId	= $oTopic->getUserId();
		$iBlogId	= $oTopic->getBlogId();
	
		$sQuery		= "INSERT INTO ".Config::Get('plugin.premoderation.table.premoderation')." 
						(topic_id, topic_author, blog_id) 
						VALUES (?d, ?d, ?d)
						ON DUPLICATE KEY UPDATE
							topic_author 	= ?d,
							blog_id			= ?d
						";
		
		return $this->oDb->Query($sQuery, $iTopicId, $iAuthorId, $iBlogId, 
											$iAuthorId, $iBlogId);
	}
	
	
	//**************************************************************************************************
	public function GetPremoderatedTopics($iPage, $iPerPage, $iUserId){
		$sPremoderation	= Config::Get('plugin.premoderation.table.premoderation');
		$sBlogUser		= Config::Get('db.table.blog_user');
		$sAdminUser		= Config::Get('db.table.user_administrator');
		
		$sAdminQ	= "SELECT * FROM $sAdminUser WHERE user_id = ?d";
		$aResult	= $this->oDb->Select($sAdminQ, $iUserId);
		
		if(count($aResult) > 0){
			$sQuery		= "SELECT * FROM $sPremoderation ORDER BY topic_id DESC
							LIMIT ?d, ?d";
			return $this->oDb->Select($sQuery, $iPerPage*($iPage-1), $iPerPage);
			
		}else{
			$sQuery		= "SELECT * FROM $sPremoderation
							WHERE topic_author = ?d
							OR blog_id IN 
								(SELECT blog_id FROM $sBlogUser WHERE $sBlogUser.user_id = ?d AND $sBlogUser.user_role > 1)
							ORDER BY topic_id DESC
							LIMIT ?d, ?d";
			return 		$this->oDb->Select($sQuery, $iUserId, $iUserId, $iPerPage*($iPage-1), $iPerPage);
		}		
	}
	
	//**************************************************************************************************
	public function GetPremoderatedTopicStatsByTopicId($iTopicId){
		return $this->oDb->SelectRow("SELECT * FROM ".Config::Get('plugin.premoderation.table.premoderation')."
										WHERE topic_id = ?d", $iTopicId);
	}
	
	//**************************************************************************************************
	public function RemovePremoderationMark($iTopicId){
		return $this->oDb->Query("DELETE FROM  ".Config::Get('plugin.premoderation.table.premoderation')." 
									WHERE topic_id = ?d", $iTopicId);
	}
	
	//**************************************************************************************************
	public function GetAdminIdList(){
		$sQuery		= "SELECT * FROM ".Config::Get('db.table.user_administrator');
		$aResult	= $this->oDb->Select($sQuery);
		
		if($aResult) return $aResult;
		else return array();
	}
	
}

?>