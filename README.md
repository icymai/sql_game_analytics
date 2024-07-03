# SQL Game Analytics
Using a combination of Google BigQuery and Looker Studio, I delved into a dataset of 4 csv files from a fictional online game. Each file contains data from a tracking event of users.

### Tools Used: Google BigQuery, Looker Studio

### Data specs
4 csv files containing data from a tracking event:<br>
• installs.csv (The first time the player installed the game)<br>
• launch_resume.csv (This tracking event triggered every time the player launch or resume the game)<br>
• ftue.csv (This tracking event triggered when the player is in the FTUE steps)<br>
• toy_unlock.csv (This tracking event triggered when the player unlocks a toy)<br>

### Business Requirement:
1. Overall insights:
For example, calculate the average daily sessions, session length and total play time per user during their day and first
week since install.
Analyze the progression speed through the introductory levels.
2. Retention analysis:
Determine the day 1, day 7, and day 30 retention rates.
Identify at which stage in the game new users are dropping off.
Shine light on the difference between players who came back on day 7 vs those who did not.
3. Open ended exploratory analysis:
Any directions or findings that could be useful to the game team, and could be formed as hypothesis for a future A/B testing.

### BigQuery: [SQL Analysis (Code)](https://github.com/SharifAthar/Netflix-Shows-and-Movies-SQL/blob/main/Netflix_SQL_Analysis.sql)
<img width="1440" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/fd116077-ead0-4591-8b01-a8ddbff0cb12">

1. Transfrom raw data to fact/dimensional tables to reduce unnessary fields and do analysis easier.<br>
2. Create views in order to save queries and modify codes without re-creating a table many times <br>

### Analysis: [Game Analytics - Looker Studio](https://lookerstudio.google.com/reporting/b3b95a64-6bd2-4b7e-8384-fe696ba8df09) 

<img width="964" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/d20e9434-8e08-4151-a9f0-7cd8f20d3c95">
<img width="960" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/7c917913-53a7-440e-b4c9-8530b9636679">
<img width="961" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/99a2bbd0-ae67-4424-aaff-44bb04c8b32d">
<img width="959" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/2f1ec97c-f1aa-4a20-9630-f536bcbf1867">
<img width="957" alt="image" src="https://github.com/icymai/sql_game_analytics/assets/45783587/3ab34997-370f-4281-8bd6-aa543ad56208">




