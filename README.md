# Notes App — Flask + MySQL + Bootstrap 5

A complete starter project styled to match the supplied screenshots: blue navigation/footer, login and registration cards, a notes dashboard with View/Edit/Delete actions, and a centered Add/Edit Note form.

## Features

- User registration and login (username or email)
- Password hashing using Werkzeug; no plain-text passwords stored
- Flask session management and logout
- Per-user private notes: create, list, view, update, and delete
- Search notes by title or content
- Forgot-password flow with expiring, one-time reset tokens sent through SMTP
- About and Contact pages
- Bootstrap 5 responsive UI, flash messages, CSRF tokens on POST forms
- Parameterized SQL queries and ownership checks on every note read/update/delete
- MySQL foreign keys with cascade delete

## Requirements

- Python 3.10 or later
- MySQL 8+ (or compatible MySQL/MariaDB)
- Optional: Gmail or another SMTP account for password reset emails

## Run on Windows / VS Code

1. Extract the project ZIP and open the extracted `notes_management_system_screenshot` folder in VS Code.
2. Open **Terminal → New Terminal** and run:

   ```powershell
   py -m venv .venv
   .\.venv\Scripts\Activate.ps1
   pip install -r requirements.txt
   ```

   If PowerShell blocks activation, use Command Prompt and run `.venv\Scripts\activate.bat` instead.

3. Create the database and tables. In MySQL Workbench, open and execute `schema.sql`. Or, if the MySQL command-line client is on your PATH:

   ```powershell
   mysql -u root -p < schema.sql
   ```

4. Create your local environment file by copying `.env.example` to `.env`:

   ```powershell
   Copy-Item .env.example .env
   ```

5. Edit `.env`. Set your MySQL password and generate a private Flask secret key:

   ```powershell
   python -c "import secrets; print(secrets.token_hex(32))"
   ```

   Copy the generated output into `SECRET_KEY` in `.env`. Configure `DB_USER`, `DB_PASSWORD`, and `DB_NAME` to match your MySQL setup.

6. Start the application:

   ```powershell
   python app.py
   ```

7. Open **http://127.0.0.1:5000** in your browser, register an account, log in, and create notes.

## Configure forgot-password email

For Gmail, enable 2-Step Verification and create a Google App Password. Put the App Password in `MAIL_PASSWORD` in `.env`, and configure `MAIL_USERNAME` and `MAIL_DEFAULT_SENDER`. Do not use your normal Gmail password and do not commit `.env` to GitHub.

The app deliberately displays the same confirmation message whether or not an email address exists. During local development, if SMTP fails and `FLASK_DEBUG=true`, the reset URL is printed to the terminal for testing only. Never run with debug mode enabled in production.

## Routes

| Purpose | URL |
|---|---|
| Login | `/login` |
| Register | `/register` |
| Notes dashboard | `/notes` or `/viewall` |
| Add note | `/addnote` |
| View a note | `/viewnotes/<id>` |
| Edit a note | `/updatenote/<id>` |
| Delete a note | `/deletenote/<id>` (POST only) |
| Forgot password | `/forgot-password` |
| Reset password | `/reset-password/<token>` |
| About | `/about` |
| Contact | `/contact` |

## Database tables

- `users`: username, email, password hash, created timestamp
- `notes`: title, content, owner (`user_id`), created and updated timestamps
- `password_resets`: hashed reset token, expiry, used timestamp

If you already have a database from an earlier version, back it up before changing the schema. The SQL uses `CREATE TABLE IF NOT EXISTS`, which does not alter existing tables.

## Security / production checklist

- Use a long random `SECRET_KEY` and keep `.env` private.
- Set `FLASK_DEBUG=false` in production.
- Set `COOKIE_SECURE=true` when serving over HTTPS.
- Create a least-privilege MySQL database user instead of using `root` in production.
- Serve through HTTPS and a production WSGI server; add login/reset rate limiting.
- The supplied Flask development server is for local learning and testing only.
