<div class="container">
	<div class="pitch-image">
		<img src="{cfg name='path.static.skin'}/images/where.png" alt="Where" />
	</div>
	{$aLang.pitch_top_header}	
	
	<h3><a href="{router page='registration'}" class="js-registration-form-show">{$aLang.register_to_post_solution}</a></h3>
</div>

{*
<ul class="nav nav-menu">
	<li {if $sMenuItemSelect=='index'}class="active"{/if}>
		<a href="{cfg name='path.root.web'}/">{$aLang.blog_menu_all}</a>
	</li>

	<li {if $sMenuItemSelect=='blog'}class="active"{/if}>
		<a href="{router page='blog'}">{$aLang.blog_menu_collective}</a>
	</li>

	<li {if $sMenuItemSelect=='log'}class="active"{/if}>
		<a href="{router page='personal_blog'}">{$aLang.blog_menu_personal}</a>
	</li>
	
	{if $oUserCurrent}
		<li {if $sMenuItemSelect=='feed'}class="active"{/if}>
			<a href="{router page='feed'}">{$aLang.userfeed_title}</a>
		</li>
	{/if}

	{hook run='menu_blog'}
</ul>

*}