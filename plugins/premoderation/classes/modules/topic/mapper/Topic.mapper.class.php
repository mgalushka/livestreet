<?php

class PluginPremoderation_ModuleTopic_MapperTopic extends PluginPremoderation_Inherit_ModuleTopic_MapperTopic {	
		
	//**************************************************************************************************
	// В фильтр по топикам добавляем постоянное условие отсутствие топика в таблице модерируемых топиков
	protected function buildFilter($aFilter) {
		$sWhere = parent::buildFilter($aFilter);
		$sWhere.= " AND t.topic_id NOT IN (SELECT topic_id FROM ".Config::Get('plugin.premoderation.table.premoderation').")";
		return $sWhere;
	}
	
	//**************************************************************************************************
	// На странице тега не должно быть видно топиков, которые находятся на модерации
	public function GetTopicsByTag($sTag,$aExcludeBlog,&$iCount,$iCurrPage,$iPerPage) {
		$sql = "				
							SELECT 		
								topic_id										
							FROM 
								".Config::Get('db.table.topic_tag')."								
							WHERE 
								topic_tag_text = ? 	
								{ AND blog_id NOT IN (?a) }
							AND topic_id NOT IN (SELECT topic_id FROM ".Config::Get('plugin.premoderation.table.premoderation').")	
                            ORDER BY topic_id DESC	
                            LIMIT ?d, ?d ";

		$aTopics=array();
		if ($aRows=$this->oDb->selectPage(
			$iCount,$sql,$sTag,
			(is_array($aExcludeBlog)&&count($aExcludeBlog)) ? $aExcludeBlog : DBSIMPLE_SKIP,
			($iCurrPage-1)*$iPerPage, $iPerPage
		)
		) {
			foreach ($aRows as $aTopic) {
				$aTopics[]=$aTopic['topic_id'];
			}
		}
		return $aTopics;
	}

}
?>