{include file='header.tpl' menu='blog'}
<h3>{$aLang.plugin.premoderation.premoderation_reason}</h3>
<form action="{router page='premoderation'}disapprove/{$iTopicId}" method="POST">
	<input type="hidden" name="form" value="1">
	<input type="text" name="reason"><input type="submit">
</form>
{include file='footer.tpl'}