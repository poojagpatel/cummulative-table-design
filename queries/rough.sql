
insert into active_users_cummulated (
	snapshot_date,
	user_id,
	activity_array,
	is_daily_active,
	is_monthly_active
)
with yesterday as (
	select * from active_users_cummulated
	where snapshot_date = '2024-01-03'
),

today as (
	select * from active_users_daily
	where snapshot_date = '2024-01-04'
),


combined as (
	select 
		t.snapshot_date,
		coalesce(y.user_id, t.user_id) as user_id,
		coalesce(
			case when CARDINALITY(y.activity_array) < 5 
				then ARRAY[COALESCE(t.is_active_today, 0)] || y.activity_array
			else
	            ARRAY[COALESCE(t.is_active_today, 0)] || y.activity_array[1:4]
	    	end,
			ARRAY[t.is_active_today]
		) as activity_array
	
	from yesterday y
		full outer join today t
		on y.user_id = t.user_id
)
-- y.activity_array[array_upper(y.activity_array,1)-28:array_upper(y.activity_array,1)


SELECT
	snapshot_date,
	user_id,
	activity_array,
	activity_array[1] AS is_daily_active,
	CASE WHEN (SELECT SUM(s) FROM UNNEST(activity_array) s) > 0 THEN 1 ELSE 0 END AS is_monthly_active
from combined;





select snapshot_date, user_id, activity_array, is_daily_active, is_monthly_active 
from active_users_cummulated;

delete from active_users_cummulated where snapshot_date is null;
delete from active_users_daily where user_id is null;

select * from events;
select * from active_users_daily;
truncate events;
truncate active_users_daily;

INSERT INTO events (user_id, event_type, event_timestamp, event_date)
VALUES
    (1, 'like', '2024-01-04 08:00:00', '2024-01-04');


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
	CAST('2024-01-04' AS DATE) as snapshot_date
FROM events
	where event_date='2024-01-04'
GROUP BY user_id;






-- create table active_users_cummulated (
--     user_id integer,
--     is_daily_active integer,
--     is_weekly_active integer,
--     is_monthly_active integer,
--     activity_array integer ARRAY,
--     like_array integer ARRAY,
--     share_array integer ARRAY,
--     comment_array integer ARRAY,
--     num_likes_7d integer,
--     num_comments_7d integer,
--     num_shares_7d integer,
--     num_likes_30d integer,
--     num_comments_30d integer,
--     num_shares_30d integer,
--     snapshot_date date
-- );