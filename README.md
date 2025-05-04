# Code Journal

This repository serves as a living log of my coding journey. Here, I document the evolution of my skills and experiences while working on many different projects. Each entry represents a snapshot of my work, ideas, and problem-solving processes at a given point in time.

Feel free to browse through and follow along as I explore new technologies and push the boundaries of my knowledge.

## Log File Naming Schema

Logs are stored in the `logs` directory with filenames based on the date. Here are some naming conventions:

- **Standard Entry:**  
  Use the ISO 8601 format:  
  `YYYY-MM-DD.md`  
  Example: `2025-04-14.md`

- **Multiple Entries in a Day:**  
  Option 1: Append the time component (hour and minute):  
  `YYYY-MM-DD_HH-MM.md`  
  Example: `2025-04-14_10-30.md`  
  Option 2: Append a sequential number:  
  `YYYY-MM-DD_001.md`

These conventions keep your log entries organized and chronologically sorted.

## Automating Log File Creation

This repository includes a script to automate the creation of a new log file using today's date as a filename. The script, `create-log.sh`, creates a new log file in the `logs` directory. If a file for today's date already exists, it appends a sequential number (e.g., `_001`, `_002`) to generate a unique filename.

### How to Use the Script

1. **Navigate to the project directory in your terminal:**
   ```bash
   cd /Users/dumarkus/Documents/Repositories/code-journal
   ```
2. **Make sure the script is executable:**
   ```bash
   chmod +x create-log.sh
   chmod +x create-log-dir.sh
   ```
3. **Run the script to create a new log file:**
   ```bash
   ./create-log.sh
   ```

If the log file for today (e.g., `YYYY-MM-DD.md`) already exists, the script automatically creates a new file with an appended suffix (e.g., `YYYY-MM-DD_001.md`).

These steps will help automate your logging process and ensure all log files are uniquely and consistently named.
