-- Condensed version:
-- WITH player_totals AS (SELECT A.uid, A.name, SUM(P.g) AS games, SUM(P.so) AS strikeouts, SUM(P.so) * 1.0 / NULLIF(SUM(P.g), 0) AS raw_so_average, ROUND(SUM(P.so) * 1.0 / NULLIF(SUM(P.g), 0), 3) AS so_average FROM players A JOIN pitching P ON A.uid = P.uid GROUP BY A.uid, A.name HAVING SUM(P.g) >= 50), team_totals AS (SELECT P.uid, P.team, SUM(P.g) AS team_games, ROW_NUMBER() OVER (PARTITION BY P.uid ORDER BY SUM(P.g) DESC) AS rn FROM pitching P GROUP BY P.uid, P.team), primary_teams AS ( SELECT uid, team FROM team_totals WHERE rn = 1) SELECT ROW_NUMBER() OVER (ORDER BY pt.raw_so_average DESC) AS Rank, pt.name AS Name, pt.games AS Games, pt.strikeouts AS SO, pt.so_average AS "SO/Game", ptm.team AS Team FROM player_totals pt JOIN primary_teams ptm ON pt.uid = ptm.uid ORDER BY pt.raw_so_average DESC LIMIT 30;

WITH player_totals AS (
    SELECT 
        A.uid,
        A.name,
        SUM(P.g) AS games,
        SUM(P.so) AS strikeouts,
        SUM(P.so) * 1.0 / NULLIF(SUM(P.g), 0) AS raw_so_average,
        ROUND(SUM(P.so) * 1.0 / NULLIF(SUM(P.g), 0), 3) AS so_average
    FROM players A
    JOIN pitching P ON A.uid = P.uid
    GROUP BY A.uid, A.name
    HAVING SUM(P.g) >= 50
),
team_totals AS (
    SELECT 
        P.uid,
        P.team,
        SUM(P.g) AS team_games,
        ROW_NUMBER() OVER (
            PARTITION BY P.uid 
            ORDER BY SUM(P.g) DESC
        ) AS rn
    FROM pitching P
    GROUP BY P.uid, P.team
),
primary_teams AS (
    SELECT 
        uid, 
        team
    FROM team_totals
    WHERE rn = 1
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY pt.raw_so_average DESC) AS Rank,
    pt.name AS Name,
    pt.games AS Games,
    pt.strikeouts AS SO,
    pt.so_average AS "SO/Game",
    ptm.team AS Team
FROM player_totals pt
JOIN primary_teams ptm ON pt.uid = ptm.uid
ORDER BY pt.raw_so_average DESC
LIMIT 30;

