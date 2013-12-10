<?php

if (!class_exists('Plugin')){
	die('Hammmmmmmmmmertimmme!');
}

class PluginPremoderation extends Plugin{

	//*********************************************************************************
	public function Init(){
	}

	//*********************************************************************************
	public function Activate(){
		if(!$this->isTableExists('prefix_topic_moderation'))
			$this->ExportSQL(dirname(__FILE__).'/prefix_topic_moderation.sql');
			
		if(!$this->isTableExists('prefix_comment_moderation'))
			$this->ExportSQL(dirname(__FILE__).'/prefix_comment_moderation.sql');
			
		// Патч старой версии плагина
		if(!$this->isFieldExists('prefix_topic_moderation', 'blog_id'))
			$this->ExportSQL(dirname(__FILE__).'/patch.sql');
				
		
		return true;
	}

	//*********************************************************************************
	public function  Deactivate() {
		return true;
	}
	
	//**************************************************************************************************
	protected $aInherits = array(
		'mapper' => array(
			'ModuleTopic_MapperTopic' 		=> '_ModuleTopic_MapperTopic',
			'ModuleComment_MapperComment'	=> '_ModuleComment_MapperComment',
		),
		
		'entity' => array(
			'ModuleTopic_EntityTopic' 	=> '_ModuleTopic_EntityTopic'
		),
		
		'module' => array(
			'ModuleTopic' 	=> '_ModuleTopic',
			'ModuleStream'	=> '_ModuleStream',
		),
	);


}
?>