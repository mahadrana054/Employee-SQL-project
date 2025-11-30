# 📊 Employee HR Dataset — SQL Analysis
A comprehensive SQL project analyzing employee performance, demographics, salaries, attendance, and HR metrics using PostgreSQL.

## 📁 Dataset Overview
This project uses an employee dataset containing demographic, employment, performance, and payroll information.
Below is the schema reconstructed from your sample row.

## 1.Marital Status Distribution of Employees
```sql
-- Solution 1: Count married vs non-married employees
SELECT 
    marriedid, 
    COUNT(*) AS total_married
FROM employee
GROUP BY marriedid;
```
## 2.Employee Salary Classification (Low / Medium / High)
```sql
-- Solution 2: Salary classification into low/medium/high
SELECT 
    employee_name, 
    salary,
    CASE
        WHEN salary < 50000 THEN 'LOW'
        WHEN salary BETWEEN 50000 AND 130000 THEN 'MEDIUM'
        WHEN salary > 130000 THEN 'HIGH'
    END AS salary_class
FROM employee;
```
## 3.Employee Count by Job Position
```sql
-- Solution 3: Count employees in each position
SELECT 
    positions, 
    COUNT(*) AS total_employee_positions
FROM employee
GROUP BY positions;
```
## 4.Employees With Highest Absences
```sql
-- Solution 4: Show employees with highest absences
SELECT 
    employee_name, 
    absences
FROM employee
ORDER BY absences DESC;
```
## 5.Low-Performance Employees and Their Recruitment Sources
```sql
-- Solution 5: Employees with low performance ("Needs Improvement")
SELECT 
    employee_name, 
    performancescore, 
    recruitmentsource
FROM employee
WHERE performancescore = 'Needs Improvement';
```
## 6.Best and Worst Recruitment Sources Based on Performance
```sql
-- Solution 6A: Count bad recruitment sources (Needs Improvement)
SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Needs Improvement'
GROUP BY recruitmentsource;

-- Solution 6B: Count good recruitment sources (Fully Meets)
SELECT 
    recruitmentsource,
    COUNT(*) AS num_employees
FROM employee
WHERE performancescore = 'Fully Meets'
GROUP BY recruitmentsource;
```
## 7.Average Satisfaction Score by Department
```sql
-- Solution 7: Average satisfaction by department (correct method)
SELECT 
    department, 
    ROUND(AVG(empsatisfaction), 1) AS depart_satisfied 
FROM employee
GROUP BY department
ORDER BY depart_satisfied DESC;
```
## 8.Salary Difference Between Consecutive Employees
```sql
-- Solution 8: Salary difference from next employee (sorted high → low)
SELECT 
    employee_name, 
    positions, 
    salary,
    (salary - LEAD(salary) OVER (ORDER BY salary DESC)) AS salary_diff
FROM employee;

```
## 9.Employees Earning Above Department Average Salary
```sql
-- Solution 9: Employees earning above department average
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
```

## 10.Cleaning Invalid Date of Birth Entries
```sql
-- Solution 10: Clean incorrect date of birth entries
UPDATE employee
SET dob = NULL
WHERE dob > '2007-01-01';

```
## 11.Low-Performance Employees Above Age 40
```sql
-- Solution 11: Employees age > 40 with low performance
SELECT 
    employee_name, 
    recruitmentsource, 
    performancescore 
FROM employee
WHERE age(dob) > INTERVAL '40 years'
  AND performancescore = 'Needs Improvement';
```
## 12.Employees With Absences Above Adjusted Average
```sql
-- Solution 12: Absentees above adjusted average (AVG + 3)
SELECT 
    employee_name, 
    absences
FROM employee
WHERE absences > (
        SELECT AVG(absences + 3) 
        FROM employee
    )
ORDER BY absences DESC;
```
## 13.Department-Wise Absences Above Average
```sql
-- Solution 13: Absences above department average
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
```
## 14.Female Employees by Marital Status
```sql
-- Solution 14: Female employees by marital status
SELECT 
    sex, 
    maritaldesc, 
    employee_name
FROM employee
WHERE sex = 'F' 
  AND maritaldesc IN ('Single', 'Married')
GROUP BY sex, maritaldesc, employee_name;
```
## 15. Salary Increase for Widowed and Divorced Female Employees
```sql
-- Solution 15: Salary increment (+5%) for widowed/divorced women
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
    sex, maritaldesc, employee_name, salary, updated_salary
ORDER BY salary DESC;
```
