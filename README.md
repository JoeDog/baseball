Baseball simulator. Run simulated games based on real-world statistics.

1.) To add these scripts to the PATH in your current environment, run this in the baseball directory:
. ./.profile

2.) This distribution includes an sqlite3 database of MLB data. data/baseball.db There's no
need to do a full harvest. 

3.) You can run the distributed queries on that database like this:
sqlite3 data/baseball.db < sql/pitchers-by-ks-per-game.sql
sqlite3 data/baseball.db < sql/batters-by-hr-per-game.sql
sqlite3 data/baseball.db < sql/teams-ranked-by-era.sql

4.) To simulate the 1909 World Series:

bin/simulator -g -s7 -t teams/pirates1909.txt -t teams/tigers1909.txt 


