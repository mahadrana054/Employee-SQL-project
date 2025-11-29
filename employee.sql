--SOLUTION 1 NO of married and non married emplyees
SELECT 
    marriedid, 
    COUNT(*) AS total_married
FROM employee
GROUP BY marriedid;

--SOLUTION 2 Salary Classification

SELECT 
    employee_name, 
    salary,
    CASE
        WHEN salary < 50000 THEN 'LOW'
        WHEN salary BETWEEN 50000 AND 130000 THEN 'MEDIUM'
        WHEN salary > 130000 THEN 'HIGH'
    END AS salary_class
FROM employee;

--SOLUTION 3 Positions Grouping

SELECT 
    positions, 
    COUNT(*) AS total_employee_positions
FROM employee
GROUP BY positions;

--SOLUTION 4 Most absenties

SELECT 
    employee_name, 
    absences
FROM employee
ORDER BY absences DESC;

--SOLUTION 5 Perfomane Determination

SELECT 
    employee_name, 
    performancescore, 
    recruitmentsource
FROM employee
WHERE performancescore = 'Needs Improvement';

--SOLUTION 6 Employees bad recruitment and good recruitment source
-- Bad recruitment source (Needs Improvement)
SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Needs Improvement'
GROUP BY recruitmentsource;

-- Good recruitment source (Fully Meets)
SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Fully Meets'
GROUP BY recruitmentsource;

--SOLUTION 7 Highest Satisfaction of employees in each department
	
SELECT department, depart_satisfied, empsatisfaction
FROM(
SELECT department, empsatisfaction, COUNT(empsatisfaction) AS depart_satisfied
FROM employee
GROUP BY department, empsatisfaction
) AS sub
ORDER BY depart_satisfied DESC;
--Above approach is wrong
SELECT 
    department, 
    ROUND(AVG(empsatisfaction), 1) AS depart_satisfied 
FROM employee
GROUP BY department
ORDER BY depart_satisfied DESC;

--This is the best way!

--SOLUTION 8 To find continous diff

SELECT 
    employee_name, 
    positions, 
    salary,
    (salary - LEAD(salary) OVER (ORDER BY salary DESC)) AS salary_diff
FROM employee;

--SOLUTION 9 salary of employees above than average in each group 

WITH avg_salary AS (
    SELECT 
        department, 
        AVG(salary) AS avg_salary
    FROM employee
    GROUP BY department 
)
SELECT 
    e.employee_name, 
    e.department, 
    e.positions, 
    e.salary, 
    a.avg_salary
FROM employee e
JOIN avg_salary a 
    ON e.department = a.department
WHERE e.salary > a.avg_salary
LIMIT 10;

--SOLUTION 10 Date Cleaning

UPDATE employee
SET dob = NULL
WHERE dob > '2007-01-01';
 
--SOLUTION 11 Filtering recruitment and performance based on age

SELECT 
    employee_name, 
    recruitmentsource, 
    performancescore 
FROM employee
WHERE age(dob) > INTERVAL '40 years'
  AND performancescore = 'Needs Improvement';

--SOLUTION 12 Absentees Above Adjusted Average (AVG + 3 Leaves)

SELECT 
    employee_name, 
    absences
FROM employee
WHERE absences > (
        SELECT AVG(absences + 3) 
        FROM employee
    )
ORDER BY absences DESC;

--SOLUTION 13 Absenties above average in each department
WITH avg_absences AS (
    SELECT 
        department, 
        AVG(absences) AS avg_absences
    FROM employee
    GROUP BY department
)
SELECT 
    e.empid, 
    e.employee_name, 
    e.managername, 
    e.absences, 
    a.avg_absences, 
    e.department
FROM employee e
JOIN avg_absences a 
    ON e.department = a.department
WHERE e.absences > a.avg_absences;

--SOLUTION 14 Women marital status 

SELECT 
    sex, 
    maritaldesc, 
    employee_name
FROM employee
WHERE sex = 'F' 
  AND maritaldesc IN ('Single', 'Married')
GROUP BY sex, maritaldesc, employee_name;

--SOLUTION 15 Increment of salary for widowed and divorced women

SELECT 
    sex, 
    maritaldesc, 
    employee_name, 
    salary, 
    salary * 1.05 AS updated_salary
FROM employee
WHERE sex = 'F' 
  AND maritaldesc IN ('Widowed', 'Divorced')
GROUP BY 
    sex, 
    maritaldesc, 
    employee_name, 
    salary, 
    updated_salary
ORDER BY salary DESC;

