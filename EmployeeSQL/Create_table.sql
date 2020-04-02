-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/5e2XSw
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

-- SQL Homework
-- UT-TOR-DATA-PT-01-2020-U-C Assignment
-- (c) Boris Smirnov

CREATE TABLE "Departments" (
    "dept_no" CHAR(4)   NOT NULL,
    "dept_name" VARCHAR(20)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "Employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "gender" CHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "Dept_managers" (
    "dept_no" CHAR(4)   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    -- every department had several managers (one at a time)
    -- each manager managed only one department
	FOREIGN KEY("dept_no") REFERENCES "Departments" ("dept_no"),
    -- every manager is an employee
    -- employee may be a manager or may be not
	FOREIGN KEY("emp_no") REFERENCES "Employees" ("emp_no")
);

CREATE TABLE "Dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" CHAR(4)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    -- every department employee is company employee
    -- there are employees who worked for more then one department
	FOREIGN KEY("emp_no") REFERENCES "Employees" ("emp_no"),
    -- every departmnet has many employees
    -- there are employees who worked in more then one department
	FOREIGN KEY("dept_no") REFERENCES "Departments" ("dept_no")
);

CREATE TABLE "Titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    -- an employee may have many titles (one at a time)
    -- every title have many employees
	FOREIGN KEY("emp_no") REFERENCES "Employees" ("emp_no")
);

CREATE TABLE "Salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL,
    -- every salary was paid to one employee
    -- every employee was paid salary one or more times
	FOREIGN KEY("emp_no") REFERENCES "Employees" ("emp_no")
);
