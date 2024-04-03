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
	CASE WHEN COUNT(user_id) > 0 THEN 1 END AS is_active_today,
	COUNT(CASE WHEN event_type='like' THEN 1 END) AS num_likes,
	COUNT(CASE WHEN event_type='comment' THEN 1 END) AS num_comments,
	COUNT(CASE WHEN event_type='share' THEN 1 END) AS num_shares,
	CAST('2024-04-14' AS DATE) AS snapshot_date
FROM events
	WHERE event_date='2024-04-14'
GROUP BY user_id;
