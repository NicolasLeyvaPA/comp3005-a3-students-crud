-- =============================================================================
-- COMP 3005 - Assignment 3, Question 1
-- Step 2: create the students table and load the initial data.
--
-- Run this while connected to the "students_db" database:
--   pgAdmin: right-click "students_db" > Query Tool > paste > Execute
--   psql:    psql -U postgres -d students_db -f db/02_create_table_and_seed.sql
--
-- Running it again resets the table to its starting state (useful before
-- recording the demo video).
-- =============================================================================

-- Start from a clean table every time the script runs.
DROP TABLE IF EXISTS students;

-- Table definition, following the schema given in the assignment.
CREATE TABLE students (
    student_id      SERIAL PRIMARY KEY,     -- integer, auto-increment, primary key
    first_name      TEXT NOT NULL,          -- required
    last_name       TEXT NOT NULL,          -- required
    email           TEXT NOT NULL UNIQUE,   -- required, no two students can share it
    enrollment_date DATE                    -- optional (NULL allowed)
);

-- Initial data provided in the assignment.
INSERT INTO students (first_name, last_name, email, enrollment_date) VALUES
('John', 'Doe', 'john.doe@example.com', '2023-09-01'),
('Jane', 'Smith', 'jane.smith@example.com', '2023-09-01'),
('Jim', 'Beam', 'jim.beam@example.com', '2023-09-02');

-- Quick check: this should return the 3 rows inserted above.
SELECT * FROM students ORDER BY student_id;
