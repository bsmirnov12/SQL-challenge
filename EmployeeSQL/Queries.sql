-- SQL Homework
-- UT-TOR-DATA-PT-01-2020-U-C Assignment
-- (c) Boris Smirnov


-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
-- It appears, Salaries table contains only one year salary for each employee
-- In the ER-diagram I specified the relationship between the two tables as One-to-Many:
--		One employee was paid 1 or more salaries, each salary was paid to one employee.
-- In reality the relationship is One-to-One.
select
	e.emp_no as "Employee Number",
	e.last_name as "Last Name",
	e.first_name as "First Name", 
	e.gender as "Gender",
	s.salary as "Salary"
from Employees as e
left join Salaries as s on s.emp_no = e.emp_no;


-- 2. List employees who were hired in 1986.
select
	e.emp_no as "Employee Number",
	e.last_name as "Last Name",
	e.first_name as "First Name",
	e.hire_date as "Date Hired"
from Employees as e
where extract(year from e.hire_date) = 1986;


-- 3.List the manager of each department with the following information:
--   department number, department name, the manager's employee number, last name, first name,
--   and start and end employment dates.
select
	d.dept_no as "Department Number",
	d.dept_name as "Department Name",
	e.emp_no as "Manager''s Employee Number",
	e.last_name as "Manager''s Last Name",
	e.first_name as "Manager''s First Name",
	dm.from_date as "Start of employment", 
	dm.to_date as "End of employment"
from Dept_managers as dm
left join Employees as e on dm.emp_no = e.emp_no
left join Departments as d on dm.dept_no = d.dept_no;


-- 4. List the department of each employee with the following information:
--    employee number, last name, first name, and department name.
-- The problems:
--  a. employees can change departments -> I'll choose only the last department where an employee worked
--  b. there is at least on employee (id:21076, I think there were 29 of them) who started to work in two different
--     departments at the same time but finished at different dates. For such cases I'll choose the last department
--     an employee worked in (and hope those end times deffer for each department, which in fact is the case)
--  c. by the date this database was last actualized some employees had left the company (and hence a department
--     where they worked), others were still employed. The later employees have their 'to_date' field set to '9999-01-01'
--     but the former have actual date when they left the job (59900 of them).
-- The tactics:
--  a. Use group by on emp_no in the Dept_emp table to find last date an employee left a department - innermost select
--  b. Use these unique combinations of emp_no and that last date as criterion for finding dept_no - middle level select
--  c. Combine emp_no and dept_no with tables Employees and Departments to get names information - top level select
select
	e.emp_no as "Employee Number",
	e.last_name as "Last Name",
	e.first_name as "First Name",
	d.dept_name as "Department Name"
from (
	select
		Dept_emp.emp_no,
		Dept_emp.dept_no
	from (
		select emp_no, MAX(to_date) as max_date
		from Dept_emp
		group by emp_no
	) as Last_emp
	left join Dept_emp on (Last_emp.emp_no = Dept_emp.emp_no) and (Last_emp.max_date = Dept_emp.to_date)
) as dm
left join Employees as e on dm.emp_no = e.emp_no
left join Departments as d on dm.dept_no = d.dept_no;


-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
select
	e.emp_no as "Employee Number",
	e.first_name as "First Name",
	e.last_name as "Last Name"
from Employees as e
where (e.first_name = 'Hercules') and (e.last_name like 'B%');


-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
select
	e.emp_no as "Employee Number",
	e.last_name as "Last Name",
	e.first_name as "First Name",
	d.dept_name as "Department Name"
from Dept_emp as de
left join Employees as e on de.emp_no = e.emp_no
left join Departments as d on de.dept_no = d.dept_no
where
	de.to_date = '9999-01-01' -- current employees
	and de.dept_no in (
		select dept_no
		from Departments
		where dept_name = 'Sales'
	);

-- 7. List all employees in the Sales and Development departments, including their employee number,
-- last name, first name, and department name.
select
	e.emp_no as "Employee Number",
	e.last_name as "Last Name",
	e.first_name as "First Name",
	d.dept_name as "Department Name"
from Dept_emp as de
left join Employees as e on de.emp_no = e.emp_no
left join Departments as d on de.dept_no = d.dept_no
where
	de.to_date = '9999-01-01' -- current employees
	and de.dept_no in (
		select dept_no
		from Departments
		where dept_name in ('Sales', 'Development')
	);


-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
select
	last_name as "Last Name",
	count(emp_no) as "Frequency"
from Employees
group by last_name
order by "Frequency" desc;
