<?php

class PluginPremoderation_ModuleTopic extends PluginPremoderation_Inherit_ModuleTopic{		

	//**************************************************************************************************	
	// Сообщения о топике, попавшему на модерацию, не должны отправляться пользователям
	public function SendNotifyTopicNew($oBlog, $oTopic, $oUserCurrent){
		if($oTopic->onModeration()) return false;
		else return parent::SendNotifyTopicNew($oBlog, $oTopic, $oUserCurrent);
	}

}
?>