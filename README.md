# Course Management SQL Project

## Overview

This project simulates a university-level course management system using PostgreSQL. It covers a wide range of database functionalities including:

* Creating databases and tables.
* An Entity Relationship Diagram named erd.png.
* Inserting and manipulating data.
* Complex queries for data insights.
* Creation of views, indexes, and triggers.
* outputs of the query inform of screenshots named screenshots.

The system manages students, instructors, courses, and enrollments, ensuring data integrity and providing advanced querying capabilities.

## Schema Design

### Database

```sql
CREATE DATABASE course_management;
```

### Tables

#### Students

```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE,
  date_of_birth DATE NOT NULL
);
```

#### Instructors

```sql
CREATE TABLE instructors (
  instructor_id INT PRIMARY KEY NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE
);
```

#### Courses

```sql
CREATE TABLE courses (
  course_id INT PRIMARY KEY NOT NULL,
  course_name VARCHAR(50) NOT NULL,
  course_description TEXT NOT NULL,
  instructors_id INT REFERENCES instructors(instructor_id)
);
```

#### Enrollments

```sql
CREATE TABLE enrollments (
  enrollment_id INT PRIMARY KEY NOT NULL,
  students_id INT REFERENCES students(student_id) NOT NULL,
  courses_id INT REFERENCES courses(course_id) NOT NULL,
  enrollment_date DATE NOT NULL,
  grade VARCHAR(1) NOT NULL
);
```

### Data Manipulation

Includes insertion of sample data, updates to reflect data constraints, and deletions to simulate realistic scenarios.

### Analytical Queries

* Students enrolled in multiple courses
* Total number of students per course
* Average grade distribution
* Instructor teaching loads
* Students with failing grades in multiple courses

### View

```sql
CREATE VIEW student_course_summary AS
SELECT
  s.first_name || ' ' || s.last_name AS student_name,
  c.course_name,
  e.grade
FROM enrollments e
JOIN students s ON s.student_id = e.students_id
JOIN courses c ON c.course_id = e.courses_id;
```

### Index

```sql
CREATE INDEX idx_students_id ON enrollments(students_id);
```

### Trigger and Logging

Logging new enrollments using a trigger:

```sql
CREATE TABLE enrollment_logs (
  log_id SERIAL PRIMARY KEY,
  student_id INT,
  course_id INT,
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_new_enrollment()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO enrollment_logs(student_id, course_id)
  VALUES (NEW.students_id, NEW.courses_id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_enrollment_insert
AFTER INSERT ON enrollments
FOR EACH ROW
EXECUTE FUNCTION log_new_enrollment();
```

## Insights Gained

### Got appreciation of foreign keys and primary keys
I got to truly use foreign keys and primary keys in closely related tables to help in connecting tables through joins so that retrieval and connection of closely and intuitively connected data records is made easy.
### Deepened understanding of foreign key relationships and cascading effects
For example I realized that a foreign key can take a unique(foreign_key_name) constraint which is used to ensure that a record belongs to only one entity in a database.
I also realised that deleting records that have a foreign key constraint is not possible unless you remove the foreign key or you delete from the table that has the primary key that is a forein key of the table with the constraint.
### Practical exposure to writing complex SQL queries for real-world problems
For example, I got to use CTE to display the students who got a grade of A, B or C a the top performing students.
I also got to  use an index called idx_students_id on the enrollemts table which is a deeply intuitively connected table to be able to speed up retrieval of data from the table.
I also got to learn the use of trigger tables that are managed using trigger functions to keep track of new records.

### learning from errors
Got to the point of making many erroors that brought me to closely pay attention to how i join multiple tables, knowing that the where clause should come after the join clause, knowing that thae order clause should not be included in the CTE definition but should be included in the main SELECT clause statement, and other keen details that i would not have paid attention to without getting messy with the project.



---


## Challenges Encountered

- Managing foreign key dependencies during deletions and updates required careful query sequencing.
- slow execution and database connection with dbeaver made me switch to vs code.
- Some sample data had issues with unique constraints (e.g., duplicate or malformed email addresses), which required validation and correction.
- To ensure correct results for edge cases such as students with no enrollments or failing grades in multiple courses I had to update and delete some records in the table which was not easy especially because I had foreign keys defined as unique constraints in multiple tables.
- Understanding PL/pgSQL syntax was not easy especially because it's an advanced SQL extension.


> **Note:** This project is a learning exercise designed to simulate a production-like relational database system. Ensure PostgreSQL is installed to test these queries in a real environment.
