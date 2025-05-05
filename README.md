# Course Management SQL Project

## Overview

This project simulates a university-level course management system using PostgreSQL. It covers a wide range of database functionalities including:

* Creating databases and tables
* Inserting and manipulating data
* Complex queries for data insights
* Creation of views, indexes, and triggers

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

## Challenges Encountered

* Ensuring referential integrity during deletions and updates
* Handling inconsistent sample data (e.g., missing instructors for courses)
* Designing realistic queries to extract meaningful insights
* Testing the trigger to ensure correct logging behavior

## Insights Gained

* Deepened understanding of foreign key relationships and cascading effects
* Practical exposure to writing complex SQL queries for real-world problems
* Experience in modularizing SQL logic using views and triggers
* Awareness of indexing for performance optimization

---

