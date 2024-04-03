INSERT INTO active_users_cummulated (
	snapshot_date
	,user_id 
	,is_daily_active
	,is_weekly_active
	,is_monthly_active
	,activity_array
	,like_array
	,share_array
	,comment_array
	,num_likes_7d
	,num_comments_7d
	,num_shares_7d
	,num_likes_30d
	,num_comments_30d
	,num_shares_30d
)


WITH yesterday AS (
	SELECT * FROM active_users_cummulated
	WHERE snapshot_date = '2024-04-13'
),

today AS (
	SELECT * FROM active_users_daily
	WHERE snapshot_date = '2024-04-14'
),



combined AS (

	SELECT 
		COALESCE(t.snapshot_date, '2024-04-14') AS snapshot_date
		,COALESCE(y.user_id, t.user_id) AS user_id
		
		,COALESCE(
			CASE
				WHEN cardinality(y.activity_array) < 30
					THEN ARRAY[COALESCE(t.is_active_today, 0)] || y.activity_array
				ELSE
					ARRAY[COALESCE(t.is_active_today, 0)] || y.activity_array[1:29]
			END,
			ARRAY[t.is_active_today]
		) AS activity_array
		
		,COALESCE(
			CASE
				WHEN cardinality(y.like_array) < 30
					THEN ARRAY[COALESCE(t.num_likes, 0)] || y.like_array
				ELSE
					ARRAY[COALESCE(t.num_likes, 0)] || y.like_array[1:29]
			END,
			ARRAY[t.num_likes]
		) as like_array
		
		,COALESCE(
			CASE
				WHEN cardinality(y.share_array) < 30
					THEN ARRAY[COALESCE(t.num_shares, 0)] || y.share_array
				ELSE
					ARRAY[COALESCE(t.num_shares, 0)] || y.share_array[1:29]
			END,
			ARRAY[t.num_shares]
		) AS share_array
		
		,COALESCE(
			CASE
				WHEN cardinality(y.comment_array) < 30
					THEN ARRAY[COALESCE(t.num_comments, 0)] || y.comment_array
				ELSE
					ARRAY[COALESCE(t.num_comments, 0)] || y.comment_array[1:29]
			END,
			ARRAY[t.num_comments]
		) AS comment_array
		
	FROM yesterday y
		FULL OUTER JOIN today t
		ON y.user_id = t.user_id

)


SELECT
	snapshot_date
	,user_id
	,activity_array[1] AS is_daily_active
	,case when (select sum(s) from unnest(activity_array[1:7]) s) > 0 then 1 else 0 end as is_weekly_active
	,case when (select sum(s) from unnest(activity_array) s) > 0 then 1 else 0 end as is_monthly_active
	,activity_array
	,like_array
	,share_array
	,comment_array
	,(select sum(s) from unnest(like_array[1:7]) s) as num_likes_7d
	,(select sum(s) from unnest(comment_array[1:7]) s) as num_comments_7d
	,(select sum(s) from unnest(share_array[1:7]) s) as num_shares_7d
	,(select sum(s) from unnest(like_array) s) as num_likes_30d
	,(select sum(s) from unnest(comment_array) s) as num_comments_30d
	,(select sum(s) from unnest(share_array) s) as num_shares_30d
from combined;
