--1. The example uses a WHERE clause to show the cases in 'Italy' in March 2020.
--Modify the query to show data from Spain

SELECT name, DAY(whn), confirmed, deaths, recovered 
FROM covid
  WHERE name = 'Spain' 
  AND MONTH(whn) = 3
  AND YEAR(whn) = 2020;


--2. The LAG function is used to show data from the preceding row or the table. When lining up rows the data is partitioned by country name and ordered by the data whn. That means that only data from Italy is considered.
--Modify the query to show confirmed for the day before.

SELECT name, DAY(whn), confirmed,
       LAG(confirmed, 1) OVER (ORDER BY whn)
FROM covid
  WHERE name = 'Italy'
  AND MONTH(whn) = 3 AND YEAR(whn) = 2020;


--3. The number of confirmed case is cumulative - but we can use LAG to recover the number of new cases reported for each day.
--Show the number of new cases for each day, for Italy, for March.

SELECT name, DAY(whn), 
       confirmed - LAG(confirmed, 1) OVER(ORDER BY whn)
       AS new
FROM covid
  WHERE name = 'Italy'
  AND MONTH(whn) = 3 AND YEAR(whn) = 2020;


--4. The data gathered are necessarily estimates and are inaccurate. However by taking a longer time span we can mitigate some of the effects.
--You can filter the data to view only Monday's figures WHERE WEEKDAY(whn) = 0.
--Show the number of new cases in Italy for each week in 2020 - show Monday only.

SELECT name,
       DATE_FORMAT(whn, '%Y-%m-%d'),
       confirmed - LAG(confirmed, 1) OVER(ORDER BY whn)
       AS new
FROM covid
  WHERE name = 'Italy'
  AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020;


--5. You can JOIN a table using DATE arithmetic. This will give different results if data is missing.
--Show the number of new cases in Italy for each week - show Monday only.
--In the sample query we JOIN this week tw with last week lw using the DATE_ADD function.

SELECT tw.name, DATE_FORMAT(tw.whn, '%Y-%m-%d'), 
       tw.confirmed - lw.confirmed 
FROM covid AS tw LEFT JOIN covid AS lw
  ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
  AND tw.name = lw.name 
  WHERE tw.name = 'Italy' AND WEEKDAY(tw.whn) = 0;


--6. The query shown shows the number of confirmed cases together with the world ranking for cases.
--United States has the highest number, Spain is number 2...
--Notice that while Spain has the second highest confirmed cases, Italy has the second highest number of deaths due to the virus.
--Include the ranking for the number of deaths in the table.

SELECT name, 
       confirmed, 
       RANK() OVER(ORDER BY confirmed DESC) AS rc,
       deaths, 
       RANK() OVER(ORDER BY deaths DESC) AS rd
FROM covid
  WHERE DAY(whn) = 20 
  AND MONTH(whn) = 4
  AND YEAR(whn) = 2020 
  ORDER BY rc;


--7. The query shown includes a JOIN t the world table so we can access the total population of each country and calculate infection rates (in cases per 100,000).
--Show the infect rate ranking for each country. Only include countries with a population of at least 10 million.

SELECT world.name, 
       ROUND(covid.confirmed / world.population * 
             100000, 0),
       RANK() OVER(ORDER BY 
                   covid.confirmed/world.population)
FROM world JOIN covid ON world.name = covid.name
  WHERE covid.whn = '2020-04-20'
  AND world.population >= 10000000
  ORDER BY world.population DESC;


--8. For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.

--Solution 1:
SELECT name, DATE_FORMAT(whn, '%Y-%m-%d'), new FROM
  (SELECT now.name, now.whn, 
          now.confirmed - past.confirmed AS new,
          RANK() OVER(PARTITION BY name 
                      ORDER BY new DESC) AS peak
   FROM covid AS now JOIN covid AS past
    ON DATE_ADD(past.whn, INTERVAL 1 DAY) = now.whn
    AND past.name = now.name) AS n
  WHERE peak = 1 AND new >= 1000 
  ORDER BY whn;

--Solution 2:
SELECT name, DATE_FORMAT(whn, '%Y-%m-%d'), new FROM
  (SELECT name, whn, new, 
          RANK() OVER(PARTITION BY name 
                      ORDER BY new DESC) AS peak FROM
    (SELECT name, whn, 
            confirmed - 
              LAG(confirmed, 1) OVER(PARTITION BY name
                                     ORDER BY whn) 
              AS new
     FROM covid) AS n) AS p
WHERE peak = 1 AND new >= 1000 
ORDER BY whn;

--Solution 3:
SELECT n.name, DATE_FORMAT(n.whn, '%Y-%m-%d'), p.peak FROM
  (SELECT now.name, now.whn, 
          now.confirmed - past.confirmed AS new
   FROM covid AS now JOIN covid AS past
    ON DATE_ADD(past.whn, INTERVAL 1 DAY) = now.whn
    AND past.name = now.name) AS n
JOIN
  (SELECT name, MAX(new) AS peak FROM
    (SELECT now.name, now.whn, 
            now.confirmed - past.confirmed AS new
     FROM covid AS now JOIN covid AS past
      ON DATE_ADD(past.whn, INTERVAL 1 DAY) = now.whn
      AND past.name = now.name) AS pn
    GROUP BY name) AS p
ON n.name = p.name 
  WHERE p.peak >= 1000 AND n.new = p.peak 
  ORDER BY n.whn;

--Solution 4:
SELECT n.name, DATE_FORMAT(n.whn, '%Y-%m-%d'), p.peak FROM
  (SELECT name, whn, 
          confirmed - 
            LAG(confirmed, 1) 
              OVER(PARTITION BY name 
                   ORDER BY whn) AS new 
  FROM covid) AS n
JOIN
  (SELECT name, MAX(new) AS peak FROM
    (SELECT name, whn, 
            confirmed - 
              LAG(confirmed, 1) 
                OVER(PARTITION BY name 
                     ORDER BY whn) AS new
     FROM covid) AS pn
    GROUP BY name) AS p
ON n.name = p.name
  WHERE p.peak >= 1000 AND p.peak = n.new
  ORDER BY n.whn;
