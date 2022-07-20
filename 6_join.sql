--1. The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
--Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player FROM goal
  WHERE teamid = 'GER';


--2. From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
--Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
--Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2 FROM game
  WHERE id = 1012;


--3. The code below shows the player (from the goal) and stadium name (from the game table) for every goal scored.
--Modify it to show the player, teamid, stadium and mdate for every German goal.

SELECT player, teamid, stadium, mdate 
FROM goal JOIN game ON goal.matchid = game.id
  WHERE teamid = 'GER';


--4. Use the same JOIN as in the previous question.
--Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'

SELECT team1, team2, player 
FROM game JOIN goal ON game.id = goal.matchid
  WHERE player LIKE 'Mario%';


--5. The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the phrase goal JOIN eteam on teamid=id
--Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT player, teamid, coach, gtime 
FROM goal JOIN eteam ON goal.teamid = eteam.id
  WHERE gtime <= 10;


--6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT game.mdate, eteam.teamname 
FROM game JOIN eteam ON game.team1 = eteam.id
  WHERE eteam.coach = 'Fernando Santos';


--7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT player 
FROM goal JOIN game ON goal.matchid = game.id
  WHERE game.stadium = 'National Stadium, Warsaw';


--8. The example query shows all goals scored in the Germany-Greece quarterfinal.
--Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT player 
FROM goal JOIN game ON goal.matchid = game.id
  WHERE goal.teamid <> 'GER'
  AND (game.team1 = 'GER' OR game.team2 = 'GER');


--9. Show teamname and the total number of goals scored.

SELECT eteam.teamname, COUNT(*) 
FROM eteam JOIN goal ON eteam.id = goal.teamid
  GROUP BY eteam.teamname;


--10. Show the stadium and the number of goals scored in each stadium.

SELECT game.stadium, COUNT(*) 
FROM game JOIN goal ON game.id = goal.matchid
  GROUP BY game.stadium;


--11. For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT game.id, game.mdate, COUNT(*) 
FROM game JOIN goal ON game.id = goal.matchid
  WHERE game.team1 = 'POL' OR game.team2 = 'POL'
  GROUP BY game.id, game.mdate;


--12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT game.id, game.mdate, COUNT(*) 
FROM game JOIN goal ON game.id = goal.matchid
  WHERE goal.teamid = 'GER'
  GROUP BY game.id, game.mdate;


--13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
--Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.

SELECT game.mdate, 
       game.team1,
       SUM(CASE goal.teamid
           WHEN game.team1 THEN 1
           ELSE 0
           END) AS score1,
       game.team2,
       SUM(CASE goal.teamid
           WHEN game.team2 THEN 1
           ELSE 0
           END) AS score2 
FROM game LEFT JOIN goal ON game.id = goal.matchid
  GROUP BY game.mdate, game.team1, game.team2
  ORDER BY game.mdate, game.id, game.team1, game.team2;



--EXTRA: Old JOIN Tutorial

--1. Show the athelete (who) and the country name for medal winners in 2000.

SELECT who, country.name 
FROM ttms JOIN country ON (ttms.country=country.id)
  WHERE games = 2000


--2. Show the who and the color of the medal for the medal winners from 'Sweden'.

SELECT ttms.who, ttms.color 
FROM ttms JOIN country ON ttms.country = country.id
  WHERE country.name = 'Sweden';


--3. Show the years in which 'China' won a 'gold' medal.

SELECT ttms.games 
FROM ttms JOIN country ON ttms.country = country.id
  WHERE country.name = 'China'
  AND ttms.color = 'gold';


--4. Show who won medals in the 'Barcelona' games.

SELECT ttws.who 
FROM ttws JOIN games ON ttws.games = games.yr
  WHERE games.city = 'Barcelona';


--5. Show which city 'Jing Chen' won medals. Show the city and the medal color.

SELECT games.city, ttws.color 
FROM ttws JOIN games ON ttws.games = games.yr
  WHERE ttws.who = 'Jing Chen';


--6. Show who won the gold medal and the city.

SELECT ttws.who, games.city 
FROM ttws JOIN games ON ttws.games = games.yr
  WHERE ttws.color = 'gold';


--7. Show the games and color of the medal won by the team that includes 'Yan Sen'.

SELECT ttmd.games, ttmd.color 
FROM ttmd JOIN team ON ttmd.team = team.id
  WHERE team.name = 'Yan Sen';


--8. Show the 'gold' medal winners in 2004.

SELECT team.name 
FROM ttmd JOIN team ON ttmd.team = team.id
  WHERE ttmd.games = 2004
  AND ttmd.color = 'gold';


--9. Show the name of each medal winner country 'FRA'.

SELECT team.name 
FROM ttmd JOIN team ON ttmd.team = team.id
  WHERE ttmd.country = 'FRA';



--EXTRA: Music Tutorial

--1. Find the title and artist who recorded the song 'Alison'.

SELECT title, artist 
FROM album JOIN track ON (album.asin=track.album)
  WHERE song = 'Alison'


--2. Which artist recorded the song 'Exodus'?

SELECT album.artist 
FROM album JOIN track ON album.asin = track.album
  WHERE track.song = 'Exodus';


--3. Show the song for each track on the album 'Blur'

SELECT track.song 
FROM album JOIN track ON album.asin = track.album
  WHERE album.title = 'Blur';


--4. For each album show the title and the total number of track.

SELECT title, COUNT(*) 
FROM album JOIN track ON (asin=album)
  GROUP BY title


--5. For each album show the title and the total number of tracks containing the word 'Heart' (albums with no such tracks need not be shown).

SELECT album.title, COUNT(*) 
FROM album JOIN track ON album.asin = track.album
  WHERE track.song LIKE '%Heart%'
  GROUP BY album.title;


--6. A "title track" is where the song is the same as the title. Find the title tracks.

SELECT track.song 
FROM album JOIN track ON album.asin = track.album
  WHERE track.song = album.title;


--7. An "eponymous" album is one where the title is the same as the artist (for example the album 'Blur' by the band 'Blur'). Show the eponymous albums.

SELECT title FROM album
  WHERE title = artist;


--8. Find the songs that appear on more than 2 albums. Include a count of the number of times each shows up.

SELECT track.song, COUNT(DISTINCT album.asin) 
FROM album JOIN track ON album.asin = track.album
  GROUP BY track.song
  HAVING COUNT(DISTINCT album.asin) > 2;


--9. A "good value" album is one where the price per track is less than 50 pence. Find the good value album - show the title, the price and the number of tracks.

SELECT album.title, album.price, COUNT(*) 
FROM album JOIN track ON album.asin = track.album
  GROUP BY album.title, album.price
  HAVING album.price / COUNT(*) < 0.5;


--10. Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101 tracks.
--List albums so that the album with the most tracks is first. Show the title and the number of tracks
--Where two or more albums have the same number of tracks you should order alphabetically

SELECT album.title, COUNT(*) 
FROM album JOIN track ON album.asin = track.album
  GROUP BY album.asin, album.title
  ORDER BY COUNT(*) DESC, album.title;
