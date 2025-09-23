-- Condensed version
-- WITH player_totals AS (SELECT A.uid, A.name, SUM(B.g) AS games, SUM(B.hr) AS home_runs, SUM(B.hr) * 1.0 / NULLIF(SUM(B.g), 0) AS raw_hr_average, ROUND(SUM(B.hr) * 1.0 / NULLIF(SUM(B.g), 0), 3) AS hr_average FROM players A JOIN batting B ON A.uid = B.uid GROUP BY A.uid, A.name HAVING SUM(B.g) >= 500), team_totals AS ( SELECT B.uid, B.team, SUM(B.g) AS team_games, ROW_NUMBER() OVER (PARTITION BY B.uid ORDER BY SUM(B.g) DESC) AS rn FROM batting B GROUP BY B.uid, B.team), primary_teams AS ( SELECT uid, team FROM team_totals WHERE rn = 1) SELECT ROW_NUMBER() OVER (ORDER BY pt.raw_hr_average DESC) AS Rank, pt.name AS Name, pt.games AS Games, pt.home_runs AS HR, pt.hr_average AS "HR Average", ptm.team AS Team FROM player_totals pt JOIN primary_teams ptm ON pt.uid = ptm.uid ORDER BY pt.raw_hr_average DESC LIMIT 30;

WITH player_totals AS (
    SELECT 
        A.uid,
        A.name,
        SUM(B.g) AS games,
        SUM(B.hr) AS home_runs,
        SUM(B.hr) * 1.0 / NULLIF(SUM(B.g), 0) AS raw_hr_average,
        ROUND(SUM(B.hr) * 1.0 / NULLIF(SUM(B.g), 0), 3) AS hr_average
    FROM players A
    JOIN batting B ON A.uid = B.uid
    GROUP BY A.uid, A.name
    HAVING SUM(B.g) >= 500
),
team_totals AS (
    SELECT 
        B.uid,
        B.team,
        SUM(B.g) AS team_games,
        ROW_NUMBER() OVER (
            PARTITION BY B.uid 
            ORDER BY SUM(B.g) DESC
        ) AS rn
    FROM batting B
    GROUP BY B.uid, B.team
),
primary_teams AS (
    SELECT 
        uid,
        team
    FROM team_totals
    WHERE rn = 1
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY pt.raw_hr_average DESC) AS Rank,
    pt.name AS Name,
    pt.games AS Games,
    pt.home_runs AS HR,
    pt.hr_average AS "HR Average",
    ptm.team AS Team
FROM player_totals pt
JOIN primary_teams ptm ON pt.uid = ptm.uid
ORDER BY pt.raw_hr_average DESC
LIMIT 30;

