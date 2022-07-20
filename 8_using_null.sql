--1. List the teachers who have NULL for their department.

SELECT name FROM teacher
  WHERE dept IS NULL;


--2. Note the INNER JOIN misses the teachers with no department and the departments with no teacher.

SELECT teacher.name, dept.name
FROM teacher INNER JOIN dept ON (teacher.dept=dept.id);


--3. Use a different JOIN so that all teachers are listed.

SELECT teacher.name, dept.name 
FROM teacher LEFT JOIN dept ON teacher.dept = dept.id;


--4. Use a different JOIN so that all departments are listed.

SELECT teacher.name, dept.name 
FROM teacher RIGHT JOIN dept ON teacher.dept = dept.id;


--5. Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given. Show teacher name and mobile number or '07986 444 2266'

SELECT name, COALESCE(mobile, '07986 444 2266') FROM teacher;


--6. Use the COALESCE function and a LEFT JOIN to print the teacher name and department name. Use the string 'None' where there is no department.

SELECT teacher.name, COALESCE(dept.name, 'None') 
FROM teacher LEFT JOIN dept ON teacher.dept = dept.id;


--7. Use COUNT to show the number of teachers and the number of mobile phones.

SELECT COUNT(teacher.name), COUNT(teacher.mobile) FROM teacher;


--8. Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.

SELECT dept.name, COUNT(teacher.name) 
FROM teacher RIGHT JOIN dept ON teacher.dept = dept.id
  GROUP BY dept.name;


--9. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT name, 
       CASE WHEN dept <= 2 THEN 'Sci' ELSE 'Art' END 
FROM teacher;


--10. Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2, show 'Art' if the teacher's dept is 3 and 'None' otherwise.

SELECT name,
       CASE
       WHEN dept <= 2 THEN 'Sci'
       WHEN dept = 3 THEN 'Art'
       ELSE 'None'
       END
FROM teacher;



--EXTRA: Scottish Parliament

--1. One MSP was kicked out of the Labour party and has no party. Find him.

SELECT name FROM msp
  WHERE party IS NULL;


--2. Obtain a list of all parties and leaders.

SELECT name, leader FROM party;


--3. Give the party and the leader for the parties which have leaders.

SELECT name, leader FROM party
  WHERE leader IS NOT NULL;


--4. Obtain a list of all parties which have at least one MSP.

SELECT DISTINCT party.name 
FROM party JOIN msp ON party.code = msp.party;


--5. Obtain a list of all MSPs by name, give the name of the MSP and the name of the party where available. Be sure that Canavan MSP, Dennis is in the list. Use ORDER BY msp.name to sort your output by MSP.

SELECT msp.name, party.name 
FROM msp LEFT JOIN party ON msp.party = party.code
  ORDER BY msp.name;


--6. Obtain a list of parties which have MSPs, include the number of MSPs.

SELECT party.name, COUNT(*) 
FROM party JOIN msp ON party.code = msp.party
  GROUP BY party.name;


--7. A list of parties with the number of MSPs; include parties with no MSPs.

SELECT party.name, COUNT(msp.name) 
FROM party LEFT JOIN msp ON party.code = msp.party
  GROUP BY party.name;
