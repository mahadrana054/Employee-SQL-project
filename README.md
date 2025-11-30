# 📊 Employee HR Dataset — SQL Analysis
A comprehensive SQL project analyzing employee performance, demographics, salaries, attendance, and HR metrics using PostgreSQL.

## 📁 Dataset Overview
This project uses an employee dataset containing demographic, employment, performance, and payroll information.
Below is the schema reconstructed from your sample row.
## 🗂️ Employee Table Schema

| Column Name              | Data Type |
|--------------------------|-----------|
| empid                    | INTEGER   |
| employee_name            | VARCHAR   |
| marriedid                | INTEGER   |
| maritalstatusid          | INTEGER   |
| genderid                 | INTEGER   |
| deptid                   | INTEGER   |
| perf_score_id            | INTEGER   |
| positionid               | INTEGER   |
| employee_source_id       | INTEGER   |
| salary                   | INTEGER   |
| terminated               | INTEGER   |
| absences                 | INTEGER   |
| positions                | VARCHAR   |
| state                    | VARCHAR   |
| birthyear                | INTEGER   |
| dob                      | DATE      |
| sex                      | VARCHAR   |
| maritaldesc              | VARCHAR   |
| citizendesc              | VARCHAR   |
| hispaniclatino           | VARCHAR   |
| race                     | VARCHAR   |
| dateofhire               | DATE      |
| dateoftermination        | DATE      |
| employmentstatus         | VARCHAR   |
| employmentstatus2        | VARCHAR   |
| department               | VARCHAR   |
| managername              | VARCHAR   |
| age                      | INTEGER   |
| recruitmentsource        | VARCHAR   |
| performancescore         | VARCHAR   |
| empsatisfaction          | NUMERIC   |
| engagementsurvey         | NUMERIC   |
| specialprojectscount     | INTEGER   |
| lastperformance_review   | DATE      |
| dayslate_last30          | INTEGER   |
| no_of_dependents         | INTEGER   |

```sql
-- Solution 1: Count married vs non-married employees
SELECT 
    marriedid, 
    COUNT(*) AS total_married
FROM employee
GROUP BY marriedid;
```

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

```sql
-- Solution 3: Count employees in each position
SELECT 
    positions, 
    COUNT(*) AS total_employee_positions
FROM employee
GROUP BY positions;
```

```sql
-- Solution 4: Show employees with highest absences
SELECT 
    employee_name, 
    absences
FROM employee
ORDER BY absences DESC;
```

```sql
-- Solution 5: Employees with low performance ("Needs Improvement")
SELECT 
    employee_name, 
    performancescore, 
    recruitmentsource
FROM employee
WHERE performancescore = 'Needs Improvement';
```

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

```sql
-- Solution 7: Average satisfaction by department (correct method)
SELECT 
    department, 
    ROUND(AVG(empsatisfaction), 1) AS depart_satisfied 
FROM employee
GROUP BY department
ORDER BY depart_satisfied DESC;
```

```sql-- Solution 8: Salary difference from next employee (sorted high → low)
SELECT 
    employee_name, 
    positions, 
    salary,
    (salary - LEAD(salary) OVER (ORDER BY salary DESC)) AS salary_diff
FROM employee;

```

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


```sql
-- Solution 10: Clean incorrect date of birth entries
UPDATE employee
SET dob = NULL
WHERE dob > '2007-01-01';

```

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
