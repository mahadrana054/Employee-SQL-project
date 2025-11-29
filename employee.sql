CREATE TABLE employee(
Employee_Name VAR
EmpID
MarriedID
MaritalStatusID
GenderID
EmpStatusID
DeptID
PerfScoreID
FromDiversityJobFairID
Salary
Termd
PositionID
Position
State
Zip
DOB
Sex
MaritalDesc
CitizenDesc
HispanicLatino
RaceDesc
DateofHire
DateofTermination
TermReason
EmploymentStatus
Department
ManagerName
ManagerID	
RecruitmentSource
PerformanceScore
EngagementSurvey
EmpSatisfaction
SpecialProjectsCount
LastPerformanceReview_Date
DaysLateLast30
Absences
);

SELECT * FROM employee;

--SOLUTION 1 NO of married and non married emplyees

SELECT marriedid, COUNT(*) AS total_married
FROM employee
GROUP BY marriedid;

--SOLUTION 2 Salary Classification

SELECT employee_name, salary,
CASE
WHEN salary < 50000 THEN 'LOW'
WHEN salary  BETWEEN 50000 AND 130000 THEN 'MEDIUM'
WHEN salary > 130000 THEN 'HIGH'
END AS salary_class
FROM employee;

--SOLUTION 3 Positions Grouping

SELECT positions, COUNT(*) AS total_employee_positions
FROM employee
GROUP BY 


--SOLUTION 4 Most absenties

SELECT employee_name, absences 
FROM employee
GROUP BY employee_name, absences
ORDER BY absences DESC

--SOLUTION 5 Perfomane Determination

SELECT employee_name, performancescore, recruitmentsource
FROM employee
WHERE performancescore = 'Needs Improvement'
GROUP BY employee_name, recruitmentsource, performancescore;

--SOLUTION 6 Employees bad recruitment and good recruitment source

SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Needs Improvement'
GROUP BY recruitmentsource;

SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Fully Meets'
GROUP BY recruitmentsource;

SELECT * FROM employee;

--SOLUTION 7 Highest Satisfaction of employees in each department
	
SELECT department, depart_satisfied, empsatisfaction
FROM(
SELECT department, empsatisfaction, COUNT(empsatisfaction) AS depart_satisfied
FROM employee
GROUP BY department, empsatisfaction
) AS sub
ORDER BY depart_satisfied DESC;
--Above approach is wrong

SELECT department, ROUND(AVG(empsatisfaction), 1) AS depart_satisfied 
FROM employee
GROUP BY department
ORDER BY depart_satisfied DESC;
--This is the best way!

--SOLUTION 8 To find continous diff

SELECT 
employee_name, positions, salary,
(salary - LEAD(salary) OVER(ORDER BY salary DESC)) as salary_diff
FROM employee;

--SOLUTION 9 salary of employees above than average in each group 

WITH avg_salary AS (
SELECT department, AVG(salary) as avg_salary
FROM employee
GROUP BY department 
)
SELECT e.employee_name, e.department, e.positions, e.salary, a.avg_salary
FROM employee e
JOIN avg_salary a ON e.department = a.department
WHERE e.salary > a.avg_salary
LIMIT 10;

--SOLUTION 10 Date Cleaning

UPDATE employee
SET dob = NULL
WHERE dob > '2007-01-01'; 
	

--SOLUTION 11 Filtering recruitment and performance based on age

SELECT employee_name, recruitmentsource, performancescore 
FROM employee
WHERE age(dob) > interval '40 years'
AND performancescore = 'Needs Improvement';



--SOLUTION 12

SELECT employee_name, absences
FROM employee
WHERE absences > (SELECT AVG(absences + 3) FROM employee) -- 3 is added because we assume three 3 leaves are allowed.
ORDER BY absences DESC;


--SOLUTION 13 Absenties above average in each department

WITH avg_absences AS(
SELECT department, AVG(absences) as avg_absences
FROM employee
GROUP BY department
)
SELECT e.empid, e.employee_name, e.managername, e.absences, a.avg_absences, e.department
FROM employee e
JOIN avg_absences a ON e.department = a.department
WHERE e.absences > a.avg_absences;

--SOLUTION 14 Women marital status 

SELECT sex, maritaldesc, employee_name
FROM employee
WHERE sex = 'F' AND (maritaldesc = 'Single' OR maritaldesc = 'Married')
GROUP BY sex, maritaldesc, employee_name;

--SOLUTION 15 Increment of salary for widowed and divorced women

SELECT sex, maritaldesc, employee_name, salary, salary*1.05  AS updated_salary
FROM employee
WHERE sex = 'F' AND (maritaldesc = 'Widowed' OR maritaldesc = 'Divorced')
GROUP BY sex, maritaldesc, employee_name, salary, updated_salary
ORDER BY salary DESC;


