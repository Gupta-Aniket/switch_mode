# Project Launcher Bash Tool

> **Automated macOS Workspace Launcher**

A productivity-focused bash script that allows quick switching between home and work development environments. Automatically closes unnecessary apps, selects projects interactively, and opens appropriate browser and editor based on your work mode.

---

## 📦 Project Structure

This is a simple standalone bash script. You can place it anywhere in your system.

---

## 🔧 Features

- Interactive mode selection: Home / Work
- Hides all currently open apps (except Terminal and Finder)
- Closes Visual Studio Code cleanly before launching a new project
- Interactive directory scan for selecting a project folder
- Automatically opens preferred browser (Brave for Home, Firefox for Work)
- Opens Xcode Simulator after switching

---

## 💻 Usage Instructions

### 1️⃣ Set your project paths

Modify these two variables at the top of your script to match your system directories:

```bash
HOME_DIR="$HOME/Development/REact"  # <-- Your home projects folder
WORK_DIR="$HOME/Development/Codenicely"  # <-- Your work projects folder
```

### 2️⃣ Make the script executable

```bash
chmod +x launcher.sh
```

### 3️⃣ Run the script

```bash
./launcher.sh
```

### 4️⃣ Select Mode

- `h` → Home Mode
- `w` → Work Mode
- `-1` → Exit

You’ll then get an interactive list of all project directories inside the chosen folder. Pick a project number, and it will launch the correct browser + VS Code instance.

---

## 📄 Full Bash Script

```bash
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
    sleep 1  
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

hide_all_apps  
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

open -a "Simulator"
```

---

## 🏷️ Tags

- macOS Automation
- Workspace Setup
- Productivity Script
- VS Code Launcher
- Bash Scripting
- Interactive CLI

---

## 👨‍💻 Author

- Developed by Aniket 

