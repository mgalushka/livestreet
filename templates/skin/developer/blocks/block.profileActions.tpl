{**
 * Меню пользователя ("Добавить в друзья", "Написать письмо" и т.д.)
 *
 * @styles css/blocks.css
 *}

{extends file='blocks/block.aside.base.tpl'}

{block name='options'}
	{assign var='noHeader' value=true}
	{assign var='noNav' value=true}
	{assign var='noContent' value=true}
	{assign var='noFooter' value=true}
{/block}

{block name='type'}profile-actions{/block}

{block name='content_after'}
	<script type="text/javascript">
		jQuery(function($){
			ls.lang.load({lang_load name="profile_user_unfollow,profile_user_follow"});
		});
	</script>

	<ul class="profile-actions" id="profile_actions">
		{include file='actions/ActionProfile/friend_item.tpl' oUserFriend=$oUserProfile->getUserFriend()}
		
		<li><a href="{router page='talk'}add/?talk_users={$oUserProfile->getLogin()}">{$aLang.user_write_prvmsg}</a></li>						
		<li>
			<a href="#" onclick="ls.user.followToggle(this, {$oUserProfile->getId()}); return false;" class="{if $oUserProfile->isFollow()}followed{/if}">
				{if $oUserProfile->isFollow()}{$aLang.profile_user_unfollow}{else}{$aLang.profile_user_follow}{/if}
			</a>
		</li>						
	</ul>
{/block}