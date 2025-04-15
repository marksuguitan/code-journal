#!/bin/bash
# filepath: /Users/dumarkus/Documents/Repositories/code-journal/create-log.sh

LOGS_DIR="logs"
mkdir -p "${LOGS_DIR}"

DATE=$(date '+%Y-%m-%d')
BASE_FILENAME="${LOGS_DIR}/${DATE}"
PRIMARY_FILE="${BASE_FILENAME}.md"

if [[ ! -e "${PRIMARY_FILE}" ]]; then
    touch "${PRIMARY_FILE}"
    echo "Created log file: ${PRIMARY_FILE}"
else
    n=1
    while true; do
        SUFFIX=$(printf "_%03d" "$n")
        NEW_FILE="${BASE_FILENAME}${SUFFIX}.md"
        if [[ ! -e "${NEW_FILE}" ]]; then
            touch "${NEW_FILE}"
            echo "Created log file: ${NEW_FILE}"
            break
        fi
        n=$((n+1))
    done
fi