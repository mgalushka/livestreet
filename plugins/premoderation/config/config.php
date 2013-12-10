<?php

// Включить премодерацию всех топиков
$config['AllTopicsPremoderationEnabled']	= true;
// Количество кармы, до которой топики пользователя попадают на модерацию
$config['AllTopicsPremoderationKarmaLimit'] = 10;



// Включить премодерацию топиков, которые содержат ссылки
$config['TopicsWithLinksPremoderationEnabled']		= true;
// Количество кармы пользователя, до которой топики с ссылками попадают на модерацию
$config['TopicsWithLinksPremoderationKarmaLimit'] 	= 100;



// Отправлять ли админу и модераторам сообщение в личную почту с извещением о новом топике на модерацию
$config['SendNoticeToAdmin']	= true;
// Отправлять ли автору уведомления об изменении статуса топика (принят/отклонен)
$config['SendNoticeToTopicAuthor'] = true;


// Виды блогов, в которых действует премодерация
$config['BigBrothersBlogs']	= array('open', 'personal');

// Удалять ли комментарии в топике после прохождения модерации
$config['RemoveCommentsAfterModeration'] = false;


//*************************************************************************************************
// Служебные настройки. Без особой на то причины редактировать не нужно
$config['url']						= 'premoderation';
$config['table']['premoderation']	= '___db.table.prefix___topic_moderation';

Config::Set('block.rule_premoderation_blog', array(
	'action'  => array( 'premoderation' ),
	'blocks'  => array( 'right' => array('stream','tags') )
));

Config::Set('router.page.'.$config['url'], 'PluginPremoderation_ActionPremoderation');
return $config;

?>