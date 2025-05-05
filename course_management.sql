
--create a database named course_management
create database course_management;

create table students (
student_id int primary key not null,
first_name varchar(50) not null,
last_name varchar (50) not null,
email varchar(100),
date_of_birth date not null,
unique (email)
);

--insert some sample data into the students table
INSERT INTO students(student_id, first_name, last_name, email, date_of_birth) 
VALUES
(1, 'John', 'Doe', 'joedoe@gmail.com', '1990-01-01'),
(2, 'Jane', 'Smith', 'janesmith@hotmail.com', '1992-02-02'),
(3, 'Alice', 'Johnson', 'alicejohnson@yahoo.com', '1995-03-03'),
(4, 'Bob', 'Brown', 'bobbrown@yahoo.com', '1993-04-04'),
(5, 'Charlie', 'Davis', 'charliedavis@gmai.com', '1991-05-05'),
(6, 'David', 'Wilson', 'davidwilson@hotmail.com', '1994-06-06'),
(7, 'Eva', 'Garcia', 'evagarcia@edu.ke', '1996-07-07'),
(8, 'Frank', 'Martinez', 'frankmartin@edu.org', '1992-08-08'),
(9, 'Grace', 'Lopez', 'gracev.@lopez.ke','1999-09-07'),
(10, 'Henry', 'Gonzalez', 'henry.gonzalez@gmail.org', '1990-10-10'),
(11, 'Ivy', 'Hernandez', 'ivy.hernandez@mendy.org', '1991-11-11'),
(12, 'Jack', 'Clark', 'jackclack@outlook.com', '1992-12-12'),
(13, 'Kathy', 'Rodriguez', 'kathyrodriguez@outlook.com', '1993-01-13');
 
--check the data in the students table
select * from students;

--create a table named instructors
create table instructors(
instructor_id int primary key not null,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100),
unique (email)
);

--insert some sample data into the instructors table
INSERT INTO instructors(instructor_id, first_name, last_name, email)
VALUES
(1, 'Dr. Alice', 'Smith', 'alice.smith@yahoo.com'),
(2, 'Prof. Bob', 'Johnson', 'bobjohnson@@gmail.com'),
(3, 'Dr. Charlie', 'Williams', 'charliewilliams@outlook.com'),
(4, 'Prof. David', 'Jones', 'davidjones@proton.me'),
(5, 'Dr. Eva', 'Brown', 'evabrown@edu.org');


--deleted this so that the number of instructors is less than the number of courses
DELETE from instructors where instructor_id IN(4,5);

--check the data in the instructors table after deletion
SELECT * FROM instructors;

 
--create a table named courses

create table courses(
course_id int primary key not null,
course_name varchar(50) not null,
course_description text not null,
instructors_id int references instructors(instructor_id)
);


--insert some sample data into the courses table

INSERT into courses(course_id,course_name,course_description,instructors_id)
VALUES
(101, 'Introduction to Programming', 'Learn the basics of programming using Python.', 3),
(102, 'Data Structures and Algorithms', 'Understand data structures and algorithms in depth.', 1),
(103, 'Web Development', 'Build dynamic websites using HTML, CSS, and JavaScript.', 4),
(104, 'Database Management Systems', 'Learn about relational databases and SQL.', 2),
(105, 'Machine Learning', 'Introduction to machine learning concepts and techniques.', 5);


--updated this so that the number of instructors is less than the number of courses and so that there can be instructors with varying number of courses
UPDATE courses SET instructors_id=1 WHERE instructors_id = 4;
UPDATE courses SET instructors_id=2 WHERE instructors_id = 5;

--check the data in the courses table after the update
select * from courses;
 
--create a table named enrollments
create table enrollments(
enrollment_id int primary key not null,
students_id int references students(student_id) not null,
courses_id int references courses(course_id) not null,
enrollment_date date not null,
grade varchar(1) not null
);

--insert some sample data into the enrollments table
INSERT into enrollments(enrollment_id,students_id,courses_id,enrollment_date,grade)
VALUES
(201, 4, 104, '2010-01-01', 'A'),
( 202, 2, 102, '2011-02-02', 'D'),
(207, 10, 103, '2012-03-03', 'C'),
(204, 4, 101, '2011-04-04', 'B'),
(209, 9, 105, '2014-05-05', 'E'),
(206, 6, 101, '2015-06-06', 'C'),
(203, 7, 104, '2014-07-07', 'B'),
(208, 8, 103, '2019-08-08', 'A'),
(205, 5, 102, '2018-09-09', 'C'),
(211, 1, 105, '2021-10-10', 'D'),
(215, 13, 101, '2016-11-11', 'A'),
(212, 12, 102, '2015-12-12', 'C'),
(213, 11, 103, '2024-01-13', 'B'),
(214, 9, 104, '2014-02-14', 'E'),
(210, 6, 105, '2015-03-15', 'D');


--updated this so that there can be a student who fails E in more than one course
UPDATE enrollments SET grade = 'E' WHERE students_id=9 AND enrollment_id=214;

--check the data in the enrollments table after the update
SELECT * FROM enrollments;


--students who enrolled in atleast one course
SELECT DISTINCT students_id, first_name,last_name
 FROM enrollments
join students on students.student_id = enrollments.students_id;


--students who enrolled in more than one course
SELECT students_id, first_name, last_name, COUNT(courses_id) as courses_pursued FROM enrollments 
JOIN students on students.student_id = enrollments.students_id
GROUP BY students_id,first_name,last_name HAVING count(courses_id) > 1 ; 


--courses with the total number of enrolled students
SELECT courses_id, course_name, COUNT(DISTINCT students_id) as total_students FROM enrollments
JOIN courses on courses.course_id = enrollments.courses_id
GROUP BY courses_id, course_name; 

--average grade per course
SELECT DISTINCT(grade), count(*) FROM enrollments
GROUP BY grade ORDER BY grade;





--students who have not enrolled in any course
SELECT students_id, first_name, last_name FROM enrollments
JOIN students ON students.student_id = enrollments.students_id
WHERE student_id NOT IN (SELECT DISTINCT students_id FROM enrollments);



--students with their grade across all courses
SELECT enrollment_id, students_id, first_name, last_name, courses_id, course_name, grade FROM enrollments
JOIN students ON students.student_id = enrollments.students_id
JOIN courses ON courses.course_id = enrollments.courses_id
group BY enrollment_id, students_id, first_name, last_name, courses_id, course_name, grade
HAVING grade IS NOT NULL
ORDER BY students_id, courses_id;


--instructors and the number of courses they teach
SELECT instructors_id, first_name, last_name, COUNT(course_id) as total_courses_taught FROM courses
JOIN instructors ON instructors.instructor_id = courses.instructors_id
GROUP BY instructors_id, first_name, last_name
ORDER BY instructors_id;


--updated the name of a lecturer to bob smith so that i can find the number of students enrolled in his courses
UPDATE instructors SET first_name = 'DR.John', last_name = 'Smith' , email='john.smith@yahoo.com' WHERE instructor_id = 1;

--validating the update
SELECT * FROM instructors;

--students enrolled in courses taught by John Smith
SELECT s.student_id, s.first_name , s.last_name , c.course_id, c.course_name, i.instructor_id, i.first_name , i.last_name  FROM enrollments e
JOIN students s ON e.students_id=s.student_id 
JOIN courses c ON c.course_id = e.courses_id
JOIN instructors i ON i.instructor_id = c.instructors_id
WHERE i.first_name = 'DR.John' AND i.last_name = 'Smith';


--top 3 students by average grade A,B,C
SELECT e.students_id,s.first_name,s.last_name, e.grade FROM enrollments e 
JOIN students s ON s.student_id =e.students_id
WHERE e.grade in ('A','B','C')
ORDER BY e.grade;


--students failing E in more than one course
SELECT students_id, first_name, last_name, count(*) AS number_of_Es from enrollments
JOIN students on students.student_id=enrollments.students_id
WHERE grade = 'E'
GROUP BY students_id,first_name,last_name;



--a view named student_course_summary that shows the students, their courses, and their grades
CREATE VIEW student_course_summary AS
SELECT 
  s.first_name || ' ' || s.last_name AS student_name,
  c.course_name,
  e.grade
FROM enrollments e
JOIN students s ON s.student_id = e.students_id
JOIN courses c ON c.course_id = e.courses_id;

--an index for enrollments table on the students_id column
CREATE INDEX idx_students_id ON enrollments(students_id);


-- a trigger that logs new enrollments
-- a logging table to sore logs of enrollments
CREATE TABLE enrollment_logs (
  log_id SERIAL PRIMARY KEY,
  student_id INT,
  course_id INT,
  log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- a trigger function executed every time a new enrollment is made
CREATE OR REPLACE FUNCTION log_new_enrollment() -- Define or replace a function named log_new_enrollment
  RETURNS TRIGGER AS $$ -- this function will return a trigger type

-- Begin the function body
BEGIN
  
  INSERT INTO enrollment_logs(student_id, course_id) --insert the 'students_id' and 'courses_id' from the new row 
  VALUES (NEW.students_id, NEW.courses_id); -- 'NEW' holds the new row being inserted into the 'enrollments' table
  RETURN NEW; -- Return the new row 
END;
$$ LANGUAGE plpgsql; --plpsql is used to write complex sql functions


-- a trigger named 'after_enrollment_insert'
CREATE TRIGGER after_enrollment_insert
  AFTER INSERT ON enrollments -- trigger will fire AFTER an INSERT operation on the 'enrollments' table
  FOR EACH ROW --the trigger will fire for each row affected by the insert operation 
  EXECUTE FUNCTION log_new_enrollment(); -- Function call to log the new enrollment whenever the trigger fires


--testing the trigger by inserting a new enrollment
INSERT INTO enrollments(enrollment_id,students_id,courses_id,enrollment_date,grade)
VALUES
(216, 1, 101, '2023-10-01', 'B');
--checking the logs to see if the trigger worked
SELECT * FROM enrollment_logs;

delete from enrollment_logs where log_id = 1;


-- a cte to find the top grades as A,B,C
WITH top_grades AS(
    select students_id, first_name,last_name,grade 
    from enrollments
    JOIN students on enrollments.students_id = students.student_id
    where grade in ('A','B','C')
)
SELECT * FROM top_grades
ORDER BY grade;


-- a cte to find students taught by dr.john smith
