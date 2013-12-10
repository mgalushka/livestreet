<?php

class PluginPremoderation_ModuleComment_MapperComment extends PluginPremoderation_Inherit_ModuleComment_MapperComment{	
		
	//**************************************************************************************************
	// Комментарии из модерируемых топиков не должны попадать в прямой эфир
	public function GetCommentsOnline($sTargetType,$aExcludeTargets,$iLimit) {
		$sql = "SELECT 					
					comment_id	
				FROM 
					".Config::Get('db.table.comment_online')." 
				WHERE 												
					target_type = ?
				AND target_id NOT IN (SELECT topic_id FROM ".Config::Get('plugin.premoderation.table.premoderation').")
				{ AND target_parent_id NOT IN(?a) }
				ORDER by comment_online_id desc limit 0, ?d ; ";

		$aComments=array();
		if ($aRows=$this->oDb->select(
			$sql,$sTargetType,
			(count($aExcludeTargets)?$aExcludeTargets:DBSIMPLE_SKIP),
			$iLimit
		)
		) {
			foreach ($aRows as $aRow) {
				$aComments[]=$aRow['comment_id'];
			}
		}
		return $aComments;
	}
}
?>