select
	e.first_name,
	e.last_name,
	e.gender,
	e.birth_date,
	e.hire_date,
	de.from_date as "Department start date",
	d.dept_name,
	t.from_date as "Title start date",
	t.title,
	s.salary
 from Employees as e
left join Dept_emp as de on e.emp_no = de.emp_no
left join Departments as d on de.dept_no = d.dept_no
left join Titles as t on e.emp_no = t.emp_no
left join Salaries as s on e.emp_no = s.emp_no
where e.emp_no = 499942;
