-- Student Records Management System
-- Complete database setup script

-- Create database (uncomment if needed)
-- CREATE DATABASE student_records;
-- USE student_records;

-- Departments table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    building VARCHAR(50) NOT NULL,
    budget DECIMAL(12,2) NOT NULL CHECK (budget > 0),
    established_date DATE NOT NULL,
    description TEXT
) COMMENT 'Academic departments in the institution';

-- Students table
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male','Female','Other') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT NOT NULL,
    admission_date DATE NOT NULL,
    graduation_date DATE,
    department_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_student_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE SET NULL
) COMMENT 'Core student information';

-- Instructors table
CREATE TABLE instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    office_location VARCHAR(50),
    department_id INT NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    CONSTRAINT fk_instructor_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE CASCADE
) COMMENT 'Teaching staff information';

-- Courses table
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits TINYINT NOT NULL CHECK (credits > 0 AND credits <= 6),
    description TEXT,
    department_id INT NOT NULL,
    CONSTRAINT fk_course_dept FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE CASCADE
) COMMENT 'Course catalog information';

-- Enrollments table (handles M-M relationship between students and courses)
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    academic_year YEAR NOT NULL,
    semester ENUM('Fall','Spring','Summer','Winter') NOT NULL,
    status ENUM('Active','Dropped','Completed','Withdrawn') DEFAULT 'Active',
    CONSTRAINT uk_enrollment UNIQUE (student_id, course_id, academic_year, semester),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) 
        REFERENCES students(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) ON DELETE CASCADE
) COMMENT 'Student course registrations';

-- Grades table
CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    instructor_id INT NOT NULL,
    grade_value DECIMAL(5,2) CHECK (grade_value >= 0 AND grade_value <= 100),
    letter_grade CHAR(2) GENERATED ALWAYS AS (
        CASE 
            WHEN grade_value >= 90 THEN 'A'
            WHEN grade_value >= 80 THEN 'B'
            WHEN grade_value >= 70 THEN 'C'
            WHEN grade_value >= 60 THEN 'D'
            ELSE 'F'
        END
    ) STORED,
    grade_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    comments TEXT,
    CONSTRAINT fk_grade_enrollment FOREIGN KEY (enrollment_id) 
        REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    CONSTRAINT fk_grade_instructor FOREIGN KEY (instructor_id) 
        REFERENCES instructors(instructor_id) ON DELETE CASCADE
) COMMENT 'Student academic performance records';

-- Course assignments table (handles M-M relationship between instructors and courses)
CREATE TABLE course_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    instructor_id INT NOT NULL,
    course_id INT NOT NULL,
    academic_year YEAR NOT NULL,
    semester ENUM('Fall','Spring','Summer','Winter') NOT NULL,
    CONSTRAINT uk_assignment UNIQUE (instructor_id, course_id, academic_year, semester),
    CONSTRAINT fk_assignment_instructor FOREIGN KEY (instructor_id) 
        REFERENCES instructors(instructor_id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_course FOREIGN KEY (course_id) 
        REFERENCES courses(course_id) ON DELETE CASCADE
) COMMENT 'Instructor course assignments';



-- Insert sample data into departments
INSERT INTO departments (department_name, building, budget, established_date, description) VALUES
('Computer Science', 'Engineering', 500000.00, '1990-05-15', 'Department of Computer Science and Engineering'),
('Mathematics', 'Science', 350000.00, '1985-08-20', 'Department of Pure and Applied Mathematics'),
('Physics', 'Science', 400000.00, '1988-03-10', 'Department of Physics and Astronomy'),
('English', 'Humanities', 300000.00, '1975-09-01', 'Department of English Literature'),
('Business', 'Commerce', 450000.00, '1995-01-12', 'School of Business Administration');

-- Insert sample data into students
INSERT INTO students (first_name, last_name, date_of_birth, gender, email, phone, address, admission_date, graduation_date, department_id, is_active) VALUES
('John', 'Smith', '2000-05-15', 'Male', 'john.smith@university.edu', '555-0101', '123 Main St, Anytown', '2019-09-01', NULL, 1, TRUE),
('Emily', 'Johnson', '2001-02-20', 'Female', 'emily.johnson@university.edu', '555-0102', '456 Oak Ave, Somewhere', '2020-09-01', NULL, 1, TRUE),
('Michael', 'Williams', '1999-11-30', 'Male', 'michael.williams@university.edu', '555-0103', '789 Pine Rd, Nowhere', '2018-09-01', '2022-05-15', 1, FALSE),
('Sarah', 'Brown', '2000-07-22', 'Female', 'sarah.brown@university.edu', '555-0104', '321 Elm St, Anywhere', '2019-09-01', NULL, 2, TRUE),
('David', 'Jones', '2001-04-05', 'Male', 'david.jones@university.edu', '555-0105', '654 Maple Dr, Everywhere', '2020-09-01', NULL, 2, TRUE),
('Jennifer', 'Garcia', '1999-09-18', 'Female', 'jennifer.garcia@university.edu', '555-0106', '987 Cedar Ln, Somewhere', '2018-09-01', '2022-05-15', 3, FALSE),
('Robert', 'Miller', '2000-12-25', 'Male', 'robert.miller@university.edu', '555-0107', '159 Birch Blvd, Nowhere', '2019-09-01', NULL, 3, TRUE),
('Jessica', 'Davis', '2001-03-08', 'Female', 'jessica.davis@university.edu', '555-0108', '753 Spruce Way, Anywhere', '2020-09-01', NULL, 4, TRUE),
('Thomas', 'Rodriguez', '1999-08-14', 'Male', 'thomas.rodriguez@university.edu', '555-0109', '456 Walnut St, Everywhere', '2018-09-01', '2022-05-15', 4, FALSE),
('Elizabeth', 'Martinez', '2000-06-30', 'Female', 'elizabeth.martinez@university.edu', '555-0110', '852 Oak Dr, Somewhere', '2019-09-01', NULL, 5, TRUE);

-- Insert sample data into instructors
INSERT INTO instructors (first_name, last_name, email, phone, office_location, department_id, hire_date, salary) VALUES
('James', 'Wilson', 'james.wilson@university.edu', '555-0201', 'ENG-201', 1, '2010-08-15', 85000.00),
('Patricia', 'Anderson', 'patricia.anderson@university.edu', '555-0202', 'SCI-105', 2, '2012-01-10', 78000.00),
('Christopher', 'Taylor', 'christopher.taylor@university.edu', '555-0203', 'SCI-110', 3, '2015-03-22', 82000.00),
('Linda', 'Thomas', 'linda.thomas@university.edu', '555-0204', 'HUM-305', 4, '2008-09-05', 75000.00),
('Daniel', 'Hernandez', 'daniel.hernandez@university.edu', '555-0205', 'COM-210', 5, '2017-06-18', 90000.00),
('Mary', 'Moore', 'mary.moore@university.edu', '555-0206', 'ENG-205', 1, '2014-11-30', 88000.00),
('Matthew', 'Martin', 'matthew.martin@university.edu', '555-0207', 'SCI-115', 2, '2016-02-14', 79000.00),
('Jennifer', 'Jackson', 'jennifer.jackson@university.edu', '555-0208', 'SCI-120', 3, '2013-07-25', 83000.00),
('Joseph', 'Thompson', 'joseph.thompson@university.edu', '555-0209', 'HUM-310', 4, '2011-04-12', 76000.00),
('Susan', 'White', 'susan.white@university.edu', '555-0210', 'COM-215', 5, '2018-09-03', 92000.00);

-- Insert sample data into courses
INSERT INTO courses (course_code, course_name, credits, description, department_id) VALUES
('CS101', 'Introduction to Programming', 4, 'Fundamentals of computer programming', 1),
('CS201', 'Data Structures', 4, 'Study of fundamental data structures', 1),
('CS301', 'Algorithms', 4, 'Design and analysis of algorithms', 1),
('MATH101', 'Calculus I', 4, 'Differential calculus', 2),
('MATH201', 'Linear Algebra', 3, 'Vector spaces and linear transformations', 2),
('PHYS101', 'General Physics I', 4, 'Mechanics and thermodynamics', 3),
('PHYS201', 'General Physics II', 4, 'Electricity and magnetism', 3),
('ENG101', 'Composition I', 3, 'Introduction to academic writing', 4),
('ENG201', 'World Literature', 3, 'Survey of world literature', 4),
('BUS101', 'Principles of Management', 3, 'Fundamentals of business management', 5),
('BUS201', 'Financial Accounting', 4, 'Principles of financial accounting', 5),
('CS401', 'Database Systems', 4, 'Design and implementation of database systems', 1),
('MATH301', 'Differential Equations', 3, 'Ordinary and partial differential equations', 2),
('PHYS301', 'Modern Physics', 4, 'Introduction to quantum mechanics', 3),
('ENG301', 'Creative Writing', 3, 'Workshop in creative writing', 4);

-- Insert sample data into enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, academic_year, semester, status) VALUES
(1, 1, '2019-09-05', 2019, 'Fall', 'Completed'),
(1, 4, '2020-01-15', 2020, 'Spring', 'Completed'),
(1, 7, '2020-09-08', 2020, 'Fall', 'Completed'),
(1, 12, '2021-01-20', 2021, 'Spring', 'Active'),
(2, 1, '2020-09-05', 2020, 'Fall', 'Completed'),
(2, 2, '2021-01-15', 2021, 'Spring', 'Active'),
(3, 1, '2018-09-05', 2018, 'Fall', 'Completed'),
(3, 2, '2019-01-15', 2019, 'Spring', 'Completed'),
(3, 3, '2019-09-08', 2019, 'Fall', 'Completed'),
(3, 12, '2020-01-20', 2020, 'Spring', 'Completed'),
(4, 4, '2019-09-05', 2019, 'Fall', 'Completed'),
(4, 5, '2020-01-15', 2020, 'Spring', 'Completed'),
(4, 13, '2020-09-08', 2020, 'Fall', 'Active'),
(5, 4, '2020-09-05', 2020, 'Fall', 'Completed'),
(5, 5, '2021-01-15', 2021, 'Spring', 'Active'),
(6, 6, '2018-09-05', 2018, 'Fall', 'Completed'),
(6, 7, '2019-01-15', 2019, 'Spring', 'Completed'),
(6, 14, '2019-09-08', 2019, 'Fall', 'Completed'),
(7, 6, '2019-09-05', 2019, 'Fall', 'Completed'),
(7, 7, '2020-01-15', 2020, 'Spring', 'Active'),
(8, 8, '2020-09-05', 2020, 'Fall', 'Completed'),
(8, 9, '2021-01-15', 2021, 'Spring', 'Active'),
(9, 8, '2018-09-05', 2018, 'Fall', 'Completed'),
(9, 9, '2019-01-15', 2019, 'Spring', 'Completed'),
(9, 15, '2019-09-08', 2019, 'Fall', 'Completed'),
(10, 10, '2019-09-05', 2019, 'Fall', 'Completed'),
(10, 11, '2020-01-15', 2020, 'Spring', 'Completed'),
(10, 10, '2020-09-08', 2020, 'Fall', 'Active');

-- Insert sample data into course_assignments
INSERT INTO course_assignments (instructor_id, course_id, academic_year, semester) VALUES
(1, 1, 2019, 'Fall'),
(1, 2, 2020, 'Spring'),
(1, 3, 2020, 'Fall'),
(6, 12, 2021, 'Spring'),
(1, 1, 2020, 'Fall'),
(6, 2, 2021, 'Spring'),
(2, 4, 2019, 'Fall'),
(2, 5, 2020, 'Spring'),
(7, 13, 2020, 'Fall'),
(2, 4, 2020, 'Fall'),
(7, 5, 2021, 'Spring'),
(3, 6, 2018, 'Fall'),
(3, 7, 2019, 'Spring'),
(8, 14, 2019, 'Fall'),
(3, 6, 2019, 'Fall'),
(8, 7, 2020, 'Spring'),
(4, 8, 2020, 'Fall'),
(4, 9, 2021, 'Spring'),
(9, 15, 2019, 'Fall'),
(4, 8, 2018, 'Fall'),
(9, 9, 2019, 'Spring'),
(5, 10, 2019, 'Fall'),
(5, 11, 2020, 'Spring'),
(10, 10, 2020, 'Fall');

-- Insert sample data into grades
INSERT INTO grades (enrollment_id, instructor_id, grade_value, grade_date, comments) VALUES
(1, 1, 92.5, '2019-12-15', 'Excellent work throughout the semester'),
(2, 2, 85.0, '2020-05-10', 'Good understanding of concepts'),
(3, 3, 78.5, '2020-12-18', 'Needs improvement in problem solving'),
(5, 1, 88.0, '2020-12-20', 'Consistent performance'),
(7, 1, 95.0, '2018-12-18', 'Outstanding student'),
(8, 6, 91.0, '2019-05-12', 'Excellent grasp of data structures'),
(9, 1, 89.5, '2019-12-17', 'Very good analytical skills'),
(10, 6, 87.0, '2020-05-14', 'Solid performance'),
(11, 2, 82.0, '2019-12-16', 'Good work, needs more practice'),
(12, 7, 76.0, '2020-05-11', 'Average performance'),
(14, 2, 90.5, '2020-12-19', 'Excellent improvement'),
(16, 3, 94.0, '2018-12-20', 'Top of the class'),
(17, 8, 83.5, '2019-05-13', 'Good understanding of material'),
(19, 3, 79.0, '2019-12-15', 'Needs to participate more'),
(20, 8, 85.5, '2020-05-12', 'Steady progress'),
(21, 4, 88.5, '2020-12-18', 'Creative and insightful'),
(23, 4, 91.0, '2018-12-17', 'Excellent writing skills'),
(24, 9, 84.0, '2019-05-14', 'Good analysis of texts'),
(26, 5, 93.0, '2019-12-16', 'Exceptional understanding'),
(27, 10, 87.5, '2020-05-15', 'Strong performance');




-- 1. Get all active students
SELECT * FROM students WHERE is_active = TRUE;

-- 2. List all courses in the Computer Science department
SELECT c.course_code, c.course_name, c.credits 
FROM courses c
JOIN departments d ON c.department_id = d.department_id
WHERE d.department_name = 'Computer Science';

-- 3. Find all instructors in the Science building
SELECT i.first_name, i.last_name, i.email, d.department_name
FROM instructors i
JOIN departments d ON i.department_id = d.department_id
WHERE d.building = 'Science';


-- 4. Count students per department
SELECT d.department_name, COUNT(s.student_id) AS student_count
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_name
ORDER BY student_count DESC;

-- 5. Average grade by course
SELECT c.course_code, c.course_name, AVG(g.grade_value) AS average_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_code, c.course_name
ORDER BY average_grade DESC;

-- 6. Department budget allocation analysis
SELECT 
    department_name, 
    budget, 
    ROUND(budget / (SELECT SUM(budget) FROM departments)) * 100 AS budget_percentage
FROM departments
ORDER BY budget DESC;



-- 7. Get complete student academic records
SELECT 
    s.first_name, s.last_name, 
    c.course_code, c.course_name,
    e.academic_year, e.semester,
    g.grade_value, g.letter_grade,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
LEFT JOIN instructors i ON g.instructor_id = i.instructor_id
WHERE s.student_id = 1
ORDER BY e.academic_year, 
    CASE e.semester 
        WHEN 'Fall' THEN 1 
        WHEN 'Spring' THEN 2 
        WHEN 'Summer' THEN 3 
        WHEN 'Winter' THEN 4 
    END;

-- 8. Find courses taught by each instructor
SELECT 
    CONCAT(i.first_name, ' ', i.last_name) AS instructor,
    d.department_name,
    GROUP_CONCAT(DISTINCT c.course_name ORDER BY c.course_name SEPARATOR ', ') AS courses_taught
FROM instructors i
JOIN departments d ON i.department_id = d.department_id
JOIN course_assignments ca ON i.instructor_id = ca.instructor_id
JOIN courses c ON ca.course_id = c.course_id
GROUP BY i.instructor_id, d.department_name;


-- 9. Update a student's information
UPDATE students
SET phone = '555-0111', address = '123 Updated St, Anytown'
WHERE student_id = 1;

-- 10. Graduate students who completed requirements
UPDATE students
SET graduation_date = '2023-05-15', is_active = FALSE
WHERE student_id IN (
    SELECT s.student_id
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s.department_id = 1  -- CS department
    AND e.status = 'Completed'
    GROUP BY s.student_id
    HAVING SUM(c.credits) >= 120  -- Assuming 120 credits needed to graduate
);



-- 11. Find students with invalid email formats
SELECT student_id, first_name, last_name, email
FROM students
WHERE email NOT LIKE '%@%.%';

-- 12. Check for courses without assigned instructors
SELECT c.course_code, c.course_name
FROM courses c
LEFT JOIN course_assignments ca ON c.course_id = ca.course_id
WHERE ca.assignment_id IS NULL;


-- 13. Generate student transcript
SELECT 
    s.first_name, s.last_name, s.student_id,
    c.course_code, c.course_name, c.credits,
    e.academic_year, e.semester,
    g.grade_value, g.letter_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_id = 3
ORDER BY e.academic_year, 
    CASE e.semester 
        WHEN 'Fall' THEN 1 
        WHEN 'Spring' THEN 2 
        WHEN 'Summer' THEN 3 
        WHEN 'Winter' THEN 4 
    END;

-- 14. Department enrollment report
SELECT 
    d.department_name,
    COUNT(DISTINCT s.student_id) AS total_students,
    COUNT(DISTINCT e.enrollment_id) AS total_enrollments,
    COUNT(DISTINCT c.course_id) AS courses_offered,
    ROUND(COUNT(DISTINCT e.enrollment_id) / COUNT(DISTINCT s.student_id), 1) AS avg_courses_per_student
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name
ORDER BY total_enrollments DESC;


-- 15. Student GPA calculation
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    ROUND(
        SUM(
            CASE 
                WHEN g.letter_grade = 'A' THEN 4 * c.credits
                WHEN g.letter_grade = 'B' THEN 3 * c.credits
                WHEN g.letter_grade = 'C' THEN 2 * c.credits
                WHEN g.letter_grade = 'D' THEN 1 * c.credits
                ELSE 0
            END
        ) / SUM(c.credits), 
    2
    ) AS gpa
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.status = 'Completed'
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY gpa DESC;

-- 16. Course difficulty analysis (based on grade distribution)
SELECT 
    c.course_code,
    c.course_name,
    COUNT(g.grade_id) AS grades_recorded,
    ROUND(AVG(g.grade_value), 1) AS avg_grade,
    ROUND(STDDEV(g.grade_value), 1) AS grade_stddev,
    MIN(g.grade_value) AS min_grade,
    MAX(g.grade_value) AS max_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY c.course_code, c.course_name
ORDER BY avg_grade ASC;

