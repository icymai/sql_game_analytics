-------------------------------------
----------- TRANSFROM DATA ----------
create table `self-learning-266408.game_analytics.fact_toy_unlock` as
select USR_ID as user_id,
  date(CLIENT_TIME) as date,
  session_id,
  TOY_NAME as name,
  UNLOCK_CAUSE as unlock_cause,
  TOY_UNLOCKED_METHOD as unlock_method,
  case when ISNEWTOY = 1 then 'Yes' else 'No' end as isnewtoy,
  count(distinct CLIENT_TIME) as action_count,
  sum(toy_amount) as total_amount
from `self-learning-266408.game_analytics.toy_unlock`
group by 1,2,3,4,5,6,7;

----------------
create table `self-learning-266408.game_analytics.fact_ftue` as
select USR_ID as user_id,
  date(CLIENT_TIME) as date,
  session_id,
  FTUE_STAGE as stage,
  FTUE_STEPS as steps,
  ACTION_ORDER as action_order,
  count(distinct CLIENT_TIME) as action_count,
  sum(TIME_SPENT) as total_time_spent
from `self-learning-266408.game_analytics.ftue`
group by 1,2,3,4,5,6;

---------------
create table `self-learning-266408.game_analytics.fact_launch_resume` as
select USR_ID as user_id,
  date(CLIENT_TIME) as date,
  session_id,
  count(distinct CLIENT_TIME) as action_count,
  sum(TIME_SPENT) as total_time_spent,
  sum(TIME_BETWEEN_SESSIONS) as total_time_btw_ss
from `self-learning-266408.game_analytics.launch_resume`
group by 1,2,3;

-----------
create table `self-learning-266408.game_analytics.dim_user` as
select USR_ID as user_id,
  date(INSTALL_TIME) as install_date,
  PLATFORM as platform,
  INSTALL_COUNTRY as country
from `self-learning-266408.game_analytics.installs`;
-------------------------------------
----------- RETENTION RATE ----------
with data as (
  select
    distinct 
    user_id,
    install_date,
    date, 
    date_diff(date, install_date, day) as day_diff
  from `self-learning-266408.game_analytics.dim_user`
  left join `self-learning-266408.game_analytics.fact_launch_resume` using (user_id)
),
cnt_tb as (
select install_date,
  day_diff,
  count(distinct user_id) as user_cnt,
from data
group by 1,2
order by 1,2
)
select
  install_date,
  max(case when day_diff = 0 then user_cnt end) as cohort_user,
  max(case when day_diff = 1 then user_cnt end)/max(case when day_diff = 0 then user_cnt end) as r1,
  max(case when day_diff = 3 then user_cnt end)/max(case when day_diff = 0 then user_cnt end) as r3,
  max(case when day_diff = 7 then user_cnt end)/max(case when day_diff = 0 then user_cnt end) as r7
from cnt_tb
group by 1;
------------------------------------
----------- USER ANALYSIS ----------
with data as (
  select
    distinct 
    user_id,
    install_date,
    date, 
    date_diff(date, install_date, day) as day_diff
  from `self-learning-266408.game_analytics.dim_user`
  left join `self-learning-266408.game_analytics.fact_launch_resume` using (user_id)
),
cnt_tb as (
select 
  user_id,
  max(day_diff) as user_type
from data 
group by 1
)
select
  user_id,
  case when user_type = 0 then "1. Day 0 user"
    when user_type = 1 then "2. Day 1 user"  
    when user_type <= 3 then "3. Day 2-3 user" 
    when user_type <= 7 then "4. Day 4-7 user" else  "5. Week 2 user" end as group_user,
  count(distinct t1.date) as active_date,
  round(count(distinct session_id)/count(distinct t1.date), 1) as avg_session_date,
  round(sum(action_count)/count(distinct t1.date), 1) as avg_action_date,
  round(sum(total_time_spent)/count(distinct t1.date), 1) as avg_time_spent_date,
  round(sum(total_time_btw_ss)/count(distinct t1.date), 1) as avg_time_btw_ss_date
from cnt_tb
left join `self-learning-266408.game_analytics.fact_launch_resume` t1 using (user_id)
group by 1,2;
------------------------------------
----------- TOY ANALYSIS ----------
with data as (
  select
    distinct 
    user_id,
    install_date,
    date, 
    date_diff(date, install_date, day) as day_diff
  from `self-learning-266408.game_analytics.dim_user`
  left join `self-learning-266408.game_analytics.fact_launch_resume` using (user_id)
),
cnt_tb as (
select 
  user_id,
  max(day_diff) as user_type,
  count(day_diff) as active_days
from data 
group by 1
)
select
  user_id,
  case when user_type = 0 then "1. Day 0 user"
    when user_type = 1 then "2. Day 1 user"  
    when user_type <= 3 then "3. Day 2-3 user" 
    when user_type <= 7 then "4. Day 4-7 user" else  "5. Week 2 user" end as group_user,
  active_days,
  name,
  t1.user_id as receive_toy, 
  sum(total_amount) as toy_receives,
  round(sum(total_amount)/count(distinct t1.date), 1) as amount_per_date,
  round(sum(action_count)/count(distinct t1.date), 1) as action_per_date,
from cnt_tb
left join `self-learning-266408.game_analytics.fact_toy_unlock` t1 using (user_id)
group by 1,2,3,4,5