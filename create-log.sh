#!/bin/bash
# filepath: /Users/dumarkus/Documents/Repositories/code-journal/create-log.sh

LOGS_DIR="logs"
mkdir -p "${LOGS_DIR}"

DATE=$(date '+%Y-%m-%d')
BASE_FILENAME="${LOGS_DIR}/${DATE}"
PRIMARY_FILE="${BASE_FILENAME}.md"
TEMPLATE_FILE="template-log.md"

create_file_from_template() {
    cp "${TEMPLATE_FILE}" "$1"
    # Replace "Today's date" with the actual date in the created file (macOS sed command)
    sed -i "" "s/Today's date/${DATE}/" "$1"
    echo "Created log file: $1"
}

if [[ ! -e "${PRIMARY_FILE}" ]]; then
    create_file_from_template "${PRIMARY_FILE}"
else
    n=1
    while true; do
        SUFFIX=$(printf "_%03d" "$n")
        NEW_FILE="${BASE_FILENAME}${SUFFIX}.md"
        if [[ ! -e "${NEW_FILE}" ]]; then
            create_file_from_template "${NEW_FILE}"
            break
        fi
        n=$((n+1))
    done
fi