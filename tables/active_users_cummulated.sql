-- public.active_users_cummulated definition

-- Drop table

-- DROP TABLE public.active_users_cummulated;

CREATE TABLE public.active_users_cummulated (
	user_id int4 NULL,
	is_daily_active int4 NULL,
	is_weekly_active int4 NULL,
	is_monthly_active int4 NULL,
	activity_array _int4 NULL,
	like_array _int4 NULL,
	share_array _int4 NULL,
	comment_array _int4 NULL,
	num_likes_7d int4 NULL,
	num_comments_7d int4 NULL,
	num_shares_7d int4 NULL,
	num_likes_30d int4 NULL,
	num_comments_30d int4 NULL,
	num_shares_30d int4 NULL,
	snapshot_date date NULL
);