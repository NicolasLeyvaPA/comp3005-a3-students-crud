# COMP 3005 – Assignment 3, Question 1: Students CRUD App

A Python command-line application that connects to a PostgreSQL database and performs CRUD (Create, Read, Update, Delete) operations on a `students` table.

**Demo video:** PASTE_YOUR_VIDEO_LINK_HERE

## Repository structure

```
comp3005-a3-students-crud/
├── app/
│   └── students_app.py               # the application (4 CRUD functions + command line)
├── db/
│   ├── 01_create_database.sql        # creates the students_db database
│   └── 02_create_table_and_seed.sql  # creates the students table and inserts the initial data
├── requirements.txt                  # Python dependency (psycopg2)
└── README.md
```

## Requirements

- Python 3.9 or newer
- PostgreSQL 13 or newer (local install, Docker, or the course OpenStack VM)
- pgAdmin 4, to run the SQL scripts and check the effect of each operation

## 1. Set up the database

1. Open pgAdmin and connect to your PostgreSQL server.
2. Right-click the default `postgres` database, open the **Query Tool**, and run `db/01_create_database.sql`. This creates `students_db`.
3. Refresh the server, right-click `students_db`, open the **Query Tool**, and run `db/02_create_table_and_seed.sql`. This creates the `students` table and inserts the 3 starting rows. The final `SELECT` in the script shows them.

The `students` table follows the given schema:

| Column | Type and constraints |
|---|---|
| `student_id` | `SERIAL PRIMARY KEY` (integer, auto-increment) |
| `first_name` | `TEXT NOT NULL` |
| `last_name` | `TEXT NOT NULL` |
| `email` | `TEXT NOT NULL UNIQUE` |
| `enrollment_date` | `DATE` |

Running `02_create_table_and_seed.sql` again resets the table to its 3 starting rows.

Using psql instead of pgAdmin:

```powershell
psql -U postgres -f db/01_create_database.sql
psql -U postgres -d students_db -f db/02_create_table_and_seed.sql
```

No PostgreSQL installed? You can start one with Docker:

```powershell
docker run --name comp3005-pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres:16
```

## 2. Install the application

From the repository root (Windows PowerShell):

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

On macOS or Linux, activate the environment with `source .venv/bin/activate` instead.

## 3. Configure the connection

The app reads its connection settings from environment variables. If a variable isn't set, the default is used:

| Variable | Default |
|---|---|
| `DB_HOST` | `localhost` |
| `DB_PORT` | `5432` |
| `DB_NAME` | `students_db` |
| `DB_USER` | `postgres` |
| `DB_PASSWORD` | `postgres` |

Set only the ones that differ from your setup. For example, in PowerShell:

```powershell
$env:DB_PASSWORD = "your_password"
$env:DB_PORT = "5433"
```

## 4. Run the application

Run every command from the repository root.

| Function | Command |
|---|---|
| `getAllStudents()` | `python app/students_app.py list` |
| `addStudent(first_name, last_name, email, enrollment_date)` | `python app/students_app.py add Alice Brown alice.brown@example.com 2023-09-03` |
| `updateStudentEmail(student_id, new_email)` | `python app/students_app.py update-email 4 alice.b@example.com` |
| `deleteStudent(student_id)` | `python app/students_app.py delete 4` |

Run `python app/students_app.py` with no command to open an interactive menu that offers all four operations.

To check the effect of each insert, update and delete, run this in the pgAdmin Query Tool on `students_db`:

```sql
SELECT * FROM students ORDER BY student_id;
```

## How the functions work

- **`getAllStudents()`** runs a `SELECT` on every row, ordered by `student_id`, and prints the rows as a table.
- **`addStudent(first_name, last_name, email, enrollment_date)`** checks the input, then runs an `INSERT ... RETURNING student_id` and prints the id the database generated. The enrollment date is optional. A duplicate email is rejected with a clear message, thanks to the `UNIQUE` constraint.
- **`updateStudentEmail(student_id, new_email)`** runs an `UPDATE` on that student's email. It reports when no student has that id, or when another student already uses the new email.
- **`deleteStudent(student_id)`** runs a `DELETE` for that id and reports when no student has it.

Every query uses parameter placeholders (`%s`), so values are never pasted into the SQL text. This prevents SQL injection. Inserts, updates and deletes are committed right away, and a failed operation is rolled back. If the database can't be reached, the app prints a short message explaining what to check.
