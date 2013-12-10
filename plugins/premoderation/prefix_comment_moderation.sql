CREATE TABLE `prefix_comment_moderation` (
	
	`comment_id`			INT UNSIGNED NOT NULL,
	`comment_author`		INT UNSIGNED NOT NULL,
	`blog_id`				INT	UNSIGNED ,
	
	PRIMARY KEY  					(`comment_id`),
	KEY			`comment_author`	(`comment_author`),
	KEY			`blog_id`			(`blog_id`)
)
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


