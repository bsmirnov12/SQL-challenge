-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/5e2XSw
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- SQL Homework
-- UT-TOR-DATA-PT-01-2020-U-C Assignment
-- (c) Boris Smirnov

CREATE TABLE Departments (
    dept_no CHAR(4)   NOT NULL   PRIMARY KEY,
    dept_name VARCHAR(20)   NOT NULL
);



CREATE TABLE Employees (
    emp_no INT   NOT NULL   PRIMARY KEY,
    birth_date DATE   NOT NULL,
    first_name VARCHAR(30)   NOT NULL,
    last_name VARCHAR(30)   NOT NULL,
    gender CHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL
);

CREATE INDEX idx_Employees_last_name 
ON Employees(last_name);

CREATE INDEX idx_Employees_first_name 
ON Employees(first_name);

CREATE INDEX idx_Employees_hire_date 
ON Employees(hire_date);



CREATE TABLE Dept_managers (
    dept_no CHAR(4)   NOT NULL,
    emp_no int   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    -- Relationship: Dept_managers.dept_no Many-One Departments.dept_no
	-- every department had several managers (one at a time)
    -- each manager managed only one department
    FOREIGN KEY(dept_no) REFERENCES Departments(dept_no),
    -- Relationship: Dept_managers.emp_no ZeroOrOne-One Employees.emp_no
    -- every manager is an employee
    -- employee may be a manager or may be not
    FOREIGN KEY(emp_no) REFERENCES Employees(emp_no)
);

CREATE INDEX idx_Dept_managers_emp_no
ON Dept_emp(emp_no);

CREATE INDEX idx_Dept_managers_dept_no
ON Dept_emp(dept_no);



CREATE TABLE Dept_emp (
    emp_no INT   NOT NULL,
    dept_no CHAR(4)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	-- Hypothesis:
	--  * An employee works in one department only at any particular moment
	--  * It is possible for an employee to change departments
	--  * Start date of employment at a department along with employee id uniquely identify every row in the table
	-- PRIMARY KEY(emp_no, from_date),
	-- Hypothesis failed: Employee 21076 started working in Production and Development on the same day. Import failed.
	--
    -- Relationship: Dept_emp.emp_no Many-One Employees.emp_no
	-- every department employee is company employee
    -- there are employees who worked for more then one department
    FOREIGN KEY(emp_no) REFERENCES Employees(emp_no),
    -- Relationship: Dept_emp.dept_no Many-Many Departments.dept_no
    -- every departmnet has many employees
    -- there are employees who worked in more then one department
    FOREIGN KEY(dept_no) REFERENCES Departments(dept_no)
);

CREATE INDEX idx_Dept_emp_emp_no
ON Dept_emp(emp_no);

CREATE INDEX idx_Dept_emp_dept_no
ON Dept_emp(dept_no);



CREATE TABLE Titles (
    emp_no INT   NOT NULL,
    title VARCHAR(30)   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
	-- Hypothesis:
	--  * An employee has one title only at any particular moment
	--  * It is possible for an employee to change title
	--  * Start date of obtaining a title along with employee id uniquely identify every row in the table
	PRIMARY KEY(emp_no, from_date),
	-- Hypothesis proved to be true - data import succeeded
	--
    -- Relationship: Titles.emp_no Many-Many Employees.emp_no
	-- an employee may have many titles (one at a time)
    -- every title have many employees
    FOREIGN KEY(emp_no) REFERENCES Employees(emp_no)
);



CREATE TABLE Salaries (
    emp_no INT   NOT NULL   PRIMARY KEY,
    salary INT   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL,
    -- Relationship: Salaries.emp_no Many-One Employees.emp_no
    -- every salary was paid to one employee
    -- every employee was paid salary one or more times
	-- In fact, this table is One-One relationship
    FOREIGN KEY(emp_no) REFERENCES Employees(emp_no)
);
