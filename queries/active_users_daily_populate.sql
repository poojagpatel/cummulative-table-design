INSERT INTO active_users_daily
	(
		user_id,
		is_active_today,
		num_likes,
		num_comments,
		num_shares,
		snapshot_date
	)
SELECT 
	user_id, 
	case when count(user_id) > 0 then 1 end as is_active_today,
	count(case when event_type='like' then 1 end) as num_likes,
	count(case when event_type='comment' then 1 end) as num_comments,
	count(case when event_type='share' then 1 end) as num_shares,
	CAST('2024-01-10' AS DATE) as snapshot_date
FROM events
GROUP BY user_id;


