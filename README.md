#  Course Management Database System

This project implements a relational database system for managing a simplified academic institution's data, including students, instructors, courses, and enrollments. It also demonstrates SQL features like constraints, views, indexing, triggers, and complex queries.

## Database Structure

### 1. Database
- `course_management`: The main database created to hold all relevant tables and data.

### 2. Tables
- **students**: Stores student personal and contact information.
- **instructors**: Contains information about course instructors.
- **courses**: Details course offerings and links each to an instructor.
- **enrollments**: Represents student registrations in courses along with grades.
- **enrollment_logs**: A log table automatically populated with new enrollments via a trigger.

##  Sample Data

Each table is seeded with meaningful sample data to simulate a working academic environment. Some entries are deleted or updated to test constraints and maintain data integrity.

## Queries Included

The SQL file includes various queries to explore and analyze the dataset:

- List students enrolled in one or more courses.
![Screenshot](Screenshot%20from%202025-05-04%2014-56-24.png)

- Identify students enrolled in multiple courses.

![Screenshot 1](Screenshot%20from%202025-05-04%2015-14-34.png)
- Count students per course.
![Screenshot 2](Screenshot%20from%202025-05-04%2015-41-05.png)
- Calculate grade distribution per course.
![Screenshot 3](Screenshot%20from%202025-05-04%2017-35-51.png)
- students who have not enrolled in any course
![Screenshot 4](Screenshot%20from%202025-05-04%2017-35-58.png)
- students and all their grades across courses
![Screenshot 5](Screenshot%20from%202025-05-04%2017-43-30.png)
- Display instructors with the number of courses taught.
![Screenshot 6](Screenshot%20from%202025-05-04%2017-56-30.png)
- Trace students pursuing coursses taught by insstructor named John Smith.
![Screenshot 7](Screenshot%20from%202025-05-04%2018-58-00.png)
- Identify top performers (`A`, `B`, `C` grades).
![Screenshot 8](Screenshot%20from%202025-05-04%2018-58-16.png)
- Students failing with an E in more than one course.
![Screenshot 9](Screenshot%20from%202025-05-04%2020-40-59.png)

## Views and Indexes

- `student_course_summary`: A view summarizing each student's courses and grades.
- `idx_students_id`: An index created on `enrollments.students_id` to optimize query performance.

##  Triggers

A **trigger** is defined to **automatically log every new student enrollment** into the `enrollment_logs` table:

- **Trigger Function**: `log_new_enrollment()` a trigger function executed every time a new enrollment is made

- **Trigger Event**: `AFTER INSERT` on the `enrollments` that fire after an INSERT operation is made on the 'enrollments' table which in turn reflects on the 'enrollment_logs' table
- **Logged Info**: The information being held in the 'enrollment_logs' table of the new record of students being enrolled is : Student ID, Course ID, Timestamp

## Insights and Challenges

### Insights Gained
- Learned how to design and normalize relational database schemas for real-world systems (students, instructors, courses, enrollments).
- Understood the importance of **foreign key constraints** in maintaining data integrity across related tables.
- Practiced using **SQL JOINs** for deriving meaningful insights, such as student performance, course popularity, and instructor activity.
- Implemented **views** for abstraction and reuse of complex queries.
- Utilized **triggers** and **logging mechanisms** to track real-time changes and maintain audit trails.
- Applied **indexing** to optimize query performance on frequently accessed columns.

###  Challenges Encountered
- Managing foreign key dependencies during deletions and updates required careful query sequencing.
- slow execution and database connection with dbeaver made me switch to vs code.
- Some sample data had issues with unique constraints (e.g., duplicate or malformed email addresses), which required validation and correction.
- To ensure correct results for edge cases such as students with no enrollments or failing grades in multiple courses I had to update and delete some records in the table which was not easy especially because I had foreign keys defined as unique constraints in multiple tables.
- Understanding PL/pgSQL syntax was not easy especially because it's an advanced SQL extension.


