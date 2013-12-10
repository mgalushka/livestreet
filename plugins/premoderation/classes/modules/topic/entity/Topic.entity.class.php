<?php

class PluginPremoderation_ModuleTopic_EntityTopic extends PluginPremoderation_Inherit_ModuleTopic_EntityTopic{    
	
	//**************************************************************************************************	
	public function onModeration(){
		$aResult	= $this->PluginPremoderation_Premoderation_GetPremoderatedTopicStatsByTopicId($this->getId());
		return !empty($aResult);
	}

}
?>