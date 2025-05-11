# 🎓 School Records Database

## 📖 Project Description

The **Student Records Management System** is a comprehensive MySQL database solution designed for educational institutions to efficiently manage:

- Student data  
- Course offerings  
- Academic records  
- Faculty information  

This system provides a structured approach to tracking all aspects of student academic journeys, from admissions to graduation.

### 🔑 Key Features

- ✅ Student information management  
- 📚 Course catalog and department structure  
- 📝 Enrollment tracking  
- 📊 Grade recording and analysis  
- 👨‍🏫 Instructor assignments  
- 📈 Academic reporting  

---

## 🛠️ Setup Instructions

### 🔧 Prerequisites

- MySQL Server (**version 8.0+ recommended**)  
- MySQL Workbench or any other SQL client  

### 📥 Installation Steps

1. **Create a new database:**

   ```sql
   CREATE DATABASE student_records;
   USE student_records;
Import the SQL script:

Method 1: Use MySQL Workbench or any GUI client to run the script

Method 2: Use MySQL CLI:
mysql -u [username] -p student_records < student_records.sql
Verify the installation:

SHOW TABLES;
SELECT COUNT(*) FROM students; -- Should return 10

🔍 Entity Relationship Diagram (ERD)

Visual representation of the database structure showing tables and relationships.

🖼️ View Interactive ERD Online
(Replace this with your actual ERD link if hosted online)

📂 Database Schema Overview

The database consists of 6 main tables:

Table	Description
Students	Core student information
departments	Academic departments
courses	Course catalog
instructors	Teaching staff
enrollments	Student course registrations
grades	Academic performance records

🚀 Sample Queries

-- Find all active Computer Science students
SELECT s.first_name, s.last_name, s.email
FROM students s
JOIN departments d ON s.department_id = d.department_id
WHERE d.department_name = 'Computer Science' AND s.is_active = TRUE;
-- Get course enrollment counts
SELECT c.course_code, c.course_name, COUNT(e.enrollment_id) AS enrollment_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_code, c.course_name
ORDER BY enrollment_count DESC;

📜 License

This project is open-source and available under the MIT License.

🤝 Contributing

Contributions are welcome!
Please fork the repository and submit a pull request with your improvements.
