CREATE TABLE `prefix_topic_moderation` (
	
	`topic_id`			INT UNSIGNED NOT NULL,
	`topic_author`		INT UNSIGNED NOT NULL,
	`blog_id`			INT	UNSIGNED ,
	
	PRIMARY KEY  				(`topic_id`),
	KEY			`topic_author`	(`topic_author`),
	KEY			`blog_id`		(`blog_id`)
)
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


