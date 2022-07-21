--1. How many stops are in the database.

SELECT COUNT(*) FROM stops;


--2. Find the id value for the stop 'Craiglockhart'

SELECT id FROM stops
  WHERE name = 'Craiglockhart';


--3. Give the id and the name for the stops on the '4' 'LRT' service.

SELECT id, name 
FROM stops JOIN route ON stops.id = route.stop
  WHERE route.num = '4' AND route.company = 'LRT';


--4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2.
--Add a HAVING clause to restrict the output to these two routes.

SELECT company, num, COUNT(*) FROM route
  WHERE stop = 149 OR stop = 53
  GROUP BY company, num
  HAVING COUNT(*) = 2;


--5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes.
--Change the query so that it shows the services from Craiglockhart to London Road.

SELECT a.company, a.num, a.stop, b.stop 
FROM route AS a JOIN route AS b
  ON a.company = b.company AND a.num = b.num
  WHERE a.stop = 53 AND b.stop = 149;


--6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number.
--Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

SELECT ar.company, ar.num, ast.name, bst.name
FROM route AS ar JOIN route AS br
  ON ar.company = br.company AND ar.num = br.num
  JOIN stops AS ast ON ar.stop = ast.id
  JOIN stops AS bst ON br.stop = bst.id
WHERE ast.name = 'Craiglockhart'
  AND bst.name = 'London Road';


--7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT DISTINCT ar.company, ar.num 
FROM route AS ar JOIN route AS br
  ON ar.company = br.company AND ar.num = br.num
  JOIN stops AS ast ON ast.id = ar.stop
  JOIN stops AS bst ON bst.id = br.stop 
WHERE ast.name = 'Haymarket' AND bst.name = 'Leith';


--8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT ar.company, ar.num 
FROM route AS ar JOIN route AS br
  ON ar.company = br.company AND ar.num = br.num
  JOIN stops AS ast ON ast.id = ar.stop
  JOIN stops AS bst ON bst.id = br.stop 
WHERE ast.name = 'Craiglockhart'
  AND bst.name = 'Tollcross';


--9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

SELECT bst.name, ar.company, ar.num
FROM route AS ar JOIN route AS br
  ON ar.company = br.company AND ar.num = br.num
  JOIN stops AS ast ON ast.id = ar.stop
  JOIN stops AS bst ON bst.id = br.stop 
WHERE ast.name = 'Craiglockhart'
  AND ar.company = 'LRT';


--10. Find the routes involving two buses that can go from Craiglockhart to Lochend.
--Show the bus no. and company for the first bus, the name of the stop for the transfer, and the bus no. and company for the second bus.

--Solution 1:
SELECT ar.num, ar.company, tst.name, dr.num, dr.company FROM route AS ar JOIN route AS br
    ON ar.company = br.company AND ar.num = br.num
  JOIN route AS cr ON br.stop = cr.stop
  JOIN route AS dr
    ON cr.company = dr.company AND cr.num = dr.num
  JOIN stops AS ast ON ast.id = ar.stop
  JOIN stops AS tst ON tst.id = br.stop
  JOIN stops AS dst ON dst.id = dr.stop 
WHERE ast.name = 'Craiglockhart'
  AND dst.name = 'Lochend' 
ORDER BY ar.num, ar.company, tst.name, dr.num, dr.company;

--Solution 2:
SELECT c.num, c.company, c.name, d.num, d.company FROM 
  (SELECT ar.num, ar.company, bst.name 
   FROM route AS ar JOIN route AS br
    ON ar.num = br.num AND ar.company = br.company
    JOIN stops AS ast ON ast.id = ar.stop
    JOIN stops AS bst ON bst.id = br.stop 
   WHERE ast.name = 'Craiglockhart') AS c
JOIN
  (SELECT ar.num, ar.company, bst.name 
   FROM route AS ar JOIN route AS br
    ON ar.num = br.num AND ar.company = br.company
    JOIN stops AS ast ON ast.id = ar.stop
    JOIN stops AS bst ON bst.id = br.stop 
   WHERE ast.name = 'Lochend') AS d
ON c.name = d.name 
ORDER BY c.num, c.company, c.name, d.num, d.company;
