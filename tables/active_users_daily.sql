CREATE TABLE IF NOT EXISTS active_users_daily (
    user_id integer,
    is_active_today integer,
    num_likes integer,
    num_comments integer,
    num_shares integer,
    snapshot_date date
);