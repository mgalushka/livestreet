<?php

class PluginPremoderation_ModuleStream extends PluginPremoderation_Inherit_ModuleStream{		

	//**************************************************************************************************	
	// Если топик попал на модерацию, то и в ленте он появляться не должен
	public function Write($iUserId, $sEventType, $iTargetId, $iPublish=1){
		if( $sEventType == 'add_topic' ){
			$oTopic	= $this->Topic_GetTopicById($iTargetId);
			if($oTopic->onModeration()) return false;
		}
		
		return parent::Write($iUserId, $sEventType, $iTargetId, $iPublish);
	}

}
?>