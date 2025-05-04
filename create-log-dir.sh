#!/bin/bash
# filepath: /Users/dumarkus/Documents/Repositories/code-journal/create-log-dir.sh

LOGS_DIR="logs"
mkdir -p "${LOGS_DIR}" # Ensure the base logs directory exists

DATE=$(date '+%Y-%m-%d')
PRIMARY_DIR="${LOGS_DIR}/${DATE}"
TEMPLATE_FILE="logs/_template-log.md"
LOG_FILENAME="${DATE}.md" # Define the log filename based on the date

create_dir_from_template() {
    local target_dir="$1"
    local log_file_path="${target_dir}/${LOG_FILENAME}"

    mkdir "${target_dir}"
    # Copy the template into the new directory with the date as the filename
    cp "${TEMPLATE_FILE}" "${log_file_path}"
    # Replace "Today's date" with the actual date in the new log file (macOS sed command)
    sed -i "" "s/Today's date/${DATE}/" "${log_file_path}"
    echo "Created log directory: ${target_dir}"
    echo "Created log file: ${log_file_path}"
}

# Check if the directory for today already exists
if [[ ! -d "${PRIMARY_DIR}" ]]; then
    # If it doesn't exist, create it using the template
    create_dir_from_template "${PRIMARY_DIR}"
else
    # If it already exists, print a message and do nothing
    echo "Log directory for today already exists: ${PRIMARY_DIR}"
fi