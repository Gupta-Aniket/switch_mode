#!/bin/bash

echo "Select mode: (h) Home | (w) Work | (-1 to Exit)"
read -r MODE

if [[ $MODE == "-1" ]]; then
    echo "Exiting..."
    exit 0
fi

HOME_DIR="$HOME/Development/REact"  
WORK_DIR="$HOME/Development/Codenicely"


hide_all_apps() {
    osascript -e 'tell application "System Events" to set visible of every process whose visible is true and name is not "Finder" and name is not "Terminal" to false'
}


close_vs_code() {
    osascript -e 'tell application "Visual Studio Code" to quit'
    sleep 1  # Give it a moment to close properly
}

select_project() {
    local DIR=$1

    if [[ ! -d "$DIR" ]]; then
        echo "Error: Directory $DIR not found!"
        exit 1
    fi

    echo "Available projects in $DIR:"
    
    PROJECTS=()
    while IFS= read -r line; do
        PROJECTS+=("$line")
    done < <(find "$DIR" -mindepth 1 -maxdepth 1 -type d)

    if [[ ${#PROJECTS[@]} -eq 0 ]]; then
        echo "No projects found in $DIR!"
        exit 1
    fi

    for i in "${!PROJECTS[@]}"; do
        echo "$((i+1))) ${PROJECTS[i]}"
    done

    echo "Enter project number (or type full path manually) | (-1 to Exit):"
    read -r CHOICE

    if [[ "$CHOICE" == "-1" ]]; then
        echo "Exiting..."
        exit 0
    fi

    if [[ "$CHOICE" =~ ^[0-9]+$ ]] && (( CHOICE > 0 && CHOICE <= ${#PROJECTS[@]} )); then
        PROJECT_PATH="${PROJECTS[$((CHOICE-1))]}"
        echo "Opening: $PROJECT_PATH"
    else
        PROJECT_PATH="$CHOICE"
        echo "Opening custom path: $PROJECT_PATH"
    fi
}

# Step 1: Hide all apps
hide_all_apps  

# Step 2: Close VS Code before opening a new project
close_vs_code

if [[ $MODE == "h" ]]; then
    select_project "$HOME_DIR"
    echo "Switching to Home Mode..."
    open -a "Brave Browser"
    code "$PROJECT_PATH"

elif [[ $MODE == "w" ]]; then
    select_project "$WORK_DIR"
    echo "Switching to Work Mode..."
    open -a "Firefox"
    code "$PROJECT_PATH"

else
    echo "Invalid option. Exiting."
    exit 1
fi

# Keep the shared apps running
open -a "Simulator"
