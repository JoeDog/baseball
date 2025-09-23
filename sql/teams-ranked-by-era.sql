WITH per_row AS (
  SELECT
    team,
    er,
    -- Convert IP like 187.2 -> outs = 187*3 + 2
    (CAST(ip AS INTEGER) * 3) +
      CASE substr(ip, -1)
        WHEN '1' THEN 1   -- .1 inning = 1 out
        WHEN '2' THEN 2   -- .2 inning = 2 outs
        ELSE 0            -- .0 (or no decimal) = 0 outs
      END AS outs
  FROM pitching
),
per_team AS (
  SELECT
    team,
    SUM(er)                   AS er_total,
    SUM(outs)                 AS outs_total,
    ROUND(27.0 * SUM(er) / SUM(outs), 3) AS era_all_time,
    ROUND(SUM(outs) / 3.0, 1) AS ip_all_time -- show team IP in innings for reference
  FROM per_row
  GROUP BY team
  -- Optional minimum workload filter: e.g., at least 1,000 team IP
  HAVING SUM(outs) >= 1000 * 3
)
SELECT
  RANK() OVER (ORDER BY era_all_time ASC) AS rk,
  team,
  era_all_time,
  ip_all_time
FROM per_team
ORDER BY rk, team;

