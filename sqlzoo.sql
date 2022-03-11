-- Tutorial 6 - JOIN

-- 1. The first example shows the goal scored by a player with the last name 'Bender'. The *
-- says to list all the columns in the table - a shorter way of saying matchid, teamid, player,
-- gtime.

-- Modify it to show the matchid and player name for all goals scored by Germany. To identify
-- German players, check for: teamid = 'GER'.

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER';

-- 2. From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we
-- want to know what teams were playing in that match.

-- Notice that the column matchid in the goal table corresponds to the id column in the game table.
-- We can look up information about game 1012 by finding that row in the game table.

-- Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2
  FROM game
  WHERE id = 1012;

-- 3. You can combine the two steps into a single query with a JOIN.

-- SELECT *
--   FROM game JOIN goal ON (id=matchid)

-- The FROM clause says to merge data from the goal table with that from the game table. The ON
-- says how to figure out which rows in game go with which rows in goal - the matchid from goal
-- must match id from game. (If we wanted to be more clear/specific we could say

-- ON (game.id=goal.matchid)

-- The code below shows the player (from the goal) and stadium name (from the game table) for
-- every goal scored.

-- Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT go.player, go.teamid, ga.stadium, ga.mdate
  FROM game ga
  JOIN goal go
  ON ga.id = go.matchid
  WHERE go.teamid = 'GER';

-- 4. Use the same JOIN as in the previous question.

-- Show the team1, team2 and player for every goal scored by a player called Mario
-- player LIKE 'Mario%'

SELECT ga.team1, ga.team2, go.player
  FROM game ga
  JOIN goal go
  ON ga.id = go.matchid
  WHERE player LIKE 'Mario%';

-- 5. The table eteam gives details of every national team including the coach. You can JOIN
-- goal to eteam using the phrase goal JOIN eteam on teamid=id.

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime <= 10.

SELECT go.player, go.teamid, et.coach, go.gtime
  FROM goal go
  JOIN eteam et
  ON go.teamid = et.id
  WHERE gtime <= 10;

-- 6. To JOIN game with eteam you could use either
-- game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id).

-- Notice that because id is a column name in both game and eteam you must specify
-- eteam.id instead of just id.

-- List the dates of the matches and the name of the team in which 'Fernando Santos'
-- was the team1 coach.

SELECT ga.mdate, et.teamname
  FROM game ga
  JOIN eteam et
  ON ga.team1 = et.id
  WHERE et.coach = 'Fernando Santos';

--7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'.

SELECT go.player
  FROM goal go
  JOIN game ga
  ON go.matchid = ga.id
  WHERE ga.stadium = 'National Stadium, Warsaw';

-- 8. The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT go.player
  FROM game ga
  JOIN goal go
  ON go.matchid = ga.id 
  WHERE (ga.team1 = 'GER' OR ga.team2 = 'GER') AND go.teamid <> 'GER';

-- 9. Show teamname and the total number of goals scored.
-- You should COUNT(*) in the SELECT line and GROUP BY teamname

SELECT et.teamname, COUNT(*)
  FROM eteam et
  JOIN goal go
  ON et.id = go.teamid
  GROUP BY et.teamname;

-- 10. Show the stadium and the number of goals scored in each stadium.

SELECT ga.stadium, COUNT(*)
  FROM game ga
  JOIN goal go
  ON ga.id = go.matchid
  GROUP BY ga.stadium;

--11. For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT go.matchid, ga.mdate, COUNT(*)
  FROM game ga
  JOIN goal go
  ON go.matchid = ga.id 
  WHERE ga.team1 = 'POL' OR ga.team2 = 'POL'
  GROUP BY go.matchid, ga.mdate;

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals
-- scored by 'GER'.

SELECT go.matchid, ga.mdate, COUNT(*)
  FROM game ga
  JOIN goal go
  ON go.matchid = ga.id 
  WHERE go.teamid = 'GER'
  GROUP BY go.matchid, ga.mdate;

-- 13. Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in
-- score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by
-- team1. Sort your result by mdate, matchid, team1 and team2.

SELECT ga.mdate, ga.team1,
  SUM(CASE WHEN go.teamid = ga.team1 THEN 1 ELSE 0 END) score1, ga.team2,
  SUM(CASE WHEN go.teamid = ga.team2 THEN 1 ELSE 0 END) score2
  FROM game ga
  JOIN goal go
  ON go.matchid = ga.id
  GROUP BY ga.mdate, ga.team1, ga.team2
  ORDER BY ga.mdate, go.matchid, ga.team1, ga.team2;


-- Tutorial 7 - More JOIN operations

-- 1. List the films where the yr is 1962 [Show id, title].

SELECT id, title
 FROM movie
 WHERE yr = 1962;

-- 2. Give year of 'Citizen Kane'.

SELECT yr
  FROM movie
  WHERE title = 'Citizen Kane';

--3. List all of the Star Trek movies, include the id, title and yr (all of
-- these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
  FROM movie
  WHERE title LIKE '%Star Trek%'
  ORDER BY yr;

-- 4. What id number does the actor 'Glenn Close' have?

SELECT id
  FROM actor
  WHERE name = 'Glenn Close';

-- 5. What is the id of the film 'Casablanca'.

SELECT id 
  FROM movie
  WHERE title = 'Casablanca';

-- 6. Obtain the cast list for 'Casablanca'.

-- The cast list is the names of the actors who were in the movie.

-- Use movieid=11768, (or whatever value you got from the previous question)

SELECT a.name
  FROM actor a
  JOIN casting c
  ON c.actorid = a.id
  WHERE c.movieid = 11768;

-- 7. Obtain the cast list for the film 'Alien'.

SELECT a.name
  FROM actor a
  JOIN casting c
  ON c.actorid = a.id
  JOIN movie m
  ON m.id = c.movieid
  WHERE m.title = 'Alien';

-- 8. List the films in which 'Harrison Ford' has appeared.

SELECT m.title
  FROM movies m
  JOIN casting c
  ON m.id = c.movieid
  JOIN actor a
  ON a.id = c.actorid
  WHERE a.name = 'Harrison Ford';

-- 9. List the films where 'Harrison Ford' has appeared - but not in the starring
-- role. [Note: the ord field of casting gives the position of the actor.
-- If ord=1 then this actor is in the starring role]

SELECT m.title
  FROM movie m
  JOIN casting c
  ON m.id = c.movieid
  JOIN actor a
  ON a.id = c.actorid
  WHERE a.name = 'Harrison Ford' and c.ord <> 1;

-- 10. List the films together with the leading star for all 1962 films.

SELECT m.title, a.name
  FROM movie m
  JOIN casting c
  ON m.id = c.movieid
  JOIN actor a
  ON a.id = c.actorid
  WHERE m.yr = 1962 AND c.ord = 1;

-- 11. Which were the busiest years for 'Rock Hudson', show the year and the
-- number of movies he made each year for any year in which he made more than
-- 2 movies.

SELECT m.yr, COUNT(title)
  FROM movie m
  JOIN casting c
  ON m.id = c.movieid
  JOIN actor a
  ON c.actorid = a.id
  WHERE a.name = 'Rock Hudson'
  GROUP BY m.yr
  HAVING COUNT(title) > 2;

-- 12. List the film title and the leading actor for all of the films
-- 'Julie Andrews' played in.

SELECT m.title, a.name
  FROM movie m
  JOIN casting c
  ON (m.id = c.movieid AND c.ord = 1)
  JOIN actor a
  ON c.actorid = a.id
  WHERE m.id IN (
    SELECT c.movieid FROM casting c
      WHERE c.actorid = (
        SELECT a.id FROM actor a
          WHERE a.name = 'Julie Andrews'));

-- 13. Obtain a list, in alphabetical order, of actors who've had at least
-- 15 starring roles.

SELECT a.name
  FROM actor a
  JOIN casting c 
  ON (a.id = c.actorid AND c.ord = 1)
  GROUP BY a.name
  HAVING COUNT(c.movieid) >= 15
  ORDER BY a.name;

-- 14. List the films released in the year 1978 ordered by the number of actors
-- in the cast, then by title.

SELECT m.title, COUNT(c.actorid)
  FROM movie m
  JOIN casting c
  ON (m.id = c.movieid AND m.yr = 1978)
  GROUP BY m.title
  ORDER BY COUNT(c.actorid) DESC, m.title;

-- 15. List all the people who have worked with 'Art Garfunkel'.

SELECT a.name
  FROM actor a
  JOIN casting c
  ON (a.id = c.actorid AND a.name <> 'Art Garfunkel')
  WHERE c.movieid IN (
    SELECT c.movieid FROM casting c
      WHERE c.actorid = (
        SELECT a.id FROM actor a
          WHERE a.name = 'Art Garfunkel'));
