# SQL Analysis
## Employee & Department Analysis
# 01. What is the total number of employees in the company?

 SELECT COUNT(*) FROM Employees

# 02. How many employees are working in each department?

SELECT department,COUNT(employee_id) AS employee_count
  FROM Employees 
  GROUP BY department
  ORDER BY employee_count DESC

# 03. What is the average salary of employees in each department?

SELECT department,
        AVG(salary) AS avg_salary_of_employee
       FROM Employees
       ORDER BY avg_salary_of_employee DESC

## Attendance Analysis
# 04. What is the attendance rate of employees,and which employees have the highest number of absences?
# For Attendance_rate
SELECT a.employee_id,
 e.employee_name,
  SUM(CASE 
 WHEN status='Present'THEN 1
 ELSE 0
 END)*100.0/COUNT(*) AS attendance_rate
 FROM Attendance AS a
 JOIN Employees AS e              
 ON a.employee_id = e.employee_id
 GROUP BY a.employee_id,e.employee_name

# For Highest Absent

SELECT a.employee_id,
       e.employee_name,
       COUNT(*) AS absent_count
       FROM Attendance AS a
       JOIN Employees AS e
       ON a.employee_id = e.employee_id
       WHERE status='Absent'
       GROUP BY a.employee_id,e.employee_name
       ORDER BY absent_count DESC

# For Attendance_rate and Highest Absent both im one query

 SELECT a.employee_id,
        e.employee_name,
         SUM(CASE
          WHEN a.status='Present' THEN 1
          ELSE 0
         END)*100.0/COUNT(*) AS attendance_rate,
            SUM(CASE
             WHEN a.status='Absent' THEN 1
             ELSE 0
         END) AS absent_count
        FROM Attendance AS a
        JOIN Employees AS e
         ON a.employee_id = e.employee_id
        GROUP BY a.employee_id,e.employee_id

## Leave Analysis

# Q5. Which employees have taken the highest number of leaves, and what the most common types of leave?
# Employee has taken highest number of leaves

SELECT E.employee_id,
       E.employee_name,
        COUNT(CASE        
         WHEN A.status='Absent' THEN 1
        END)AS taken_leaves
      FROM Employees AS E
      JOIN Attendance AS A
      ON E.employee_id=A.employee_id
      GROUP BY E.employee_id,E.employee_name
      ORDER BY taken_leaves DESC
      LIMIT 1

# Common types of leaves

SELECT leave_type,
       COUNT(*) AS total_leaves
       FROM Leaves 
       GROUP BY leave_type 
       ORDER BY total_leaves DESC
       LIMIT 1

# # Leaves Analysis

# 06. Which departments have the highest leave rates,and 
#      is there any noticeable pattern in leave usage across departments?

#  Departments have the highest leave rates

SELECT  e.department,
        COUNT(DISTINCT e.employee_id)AS total_employee
        COUNT(l.leave_type) AS total_leave,
        COUNT(DISTINCT CASE
        WHEN l.status='Approved' THEN l.employee_id
        END )*100
        /COUNT(DISTINCT e.employee_id) AS leave_rate
        FROM Employees AS e
        LEFT JOIN Leaves AS l
        ON e.employee_id = l.employee_id
        GROUP BY department
        ORDER BY leave_rate DESC

# Identify leave usage patterns from the above result 

# # Performance Analysis

# Q07. Which employees have the highest performance scores, 
#      and which employees may need performance improvement?

# Which employees have the highest performance scores:
SELECT e.employee_id,
       e.employee_name,
       AVG(p.performance_score) AS performance_score
       FROM Employees AS e
          JOIN Performance_reviews AS p
          ON e.employee_id = p.employee_id
          GROUP BY e.employee_id,e.employee_name
          ORDER BY performance_score DESC

#  which employees may need performance improvement
SELECT e.employee_id,
       e.employee_name,
       p.performance_score,
       p.comments
       FROM Employees AS e
       JOIN Performance_reviews AS p
       ON e.employee_id = p.employee_id
       WHERE p.performance_score < 2 OR p.comments = 'Need improvement'
       GROUP BY e.employee_id,e.employee_name

# HR Business Analysis

# # 08. Which departments show a combination of high employee cost, poor attendance, and low performance?

# Which departments show a combination of high employee cost
SELECT department,
      SUM(salary) AS total_salary
      FROM Employees
    GROUP BY department
    ORDER BY total_salary DESC

# Which department show a Poor Attendance
  SELECT e.department,
        COUNT(CASE 
           WHEN a.status = 'Present' THEN 1
           END) AS present_days,
        COUNT(*) AS total_days,
        COUNT(CASE
           WHEN a.status='Present' THEN 1
           END)*100
        /COUNT(*) AS attendance_rate
     FROM Attendance AS a
     JOIN Employees AS e
     ON a.employee_id = e.employee_id
     GROUP BY e.department
     ORDER BY attendance_rate DESC

# Which department show low performance
  SELECT e.department,
          AVG(p.performance_score) AS avg_performance
            FROM Employees AS e
            JOIN Performance_reviews AS p
            ON e.employee_id = p.employee_id
            GROUP BY e.department
            ORDER BY avg_performance ASC