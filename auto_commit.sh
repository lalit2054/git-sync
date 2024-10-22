#!/bin/bash

# Define the path to your config file
CONFIG_FILE="repos.conf"

# Read the repo paths from the config file, ignoring lines that start with '#'
REPOS=$(grep -v '^#' $CONFIG_FILE)

# Iterate over each repository path
for REPO_PATH in $REPOS; do
    echo "Processing repo at $REPO_PATH"
    
    # Check if the directory exists
    if [ -d "$REPO_PATH" ]; then
        cd $REPO_PATH
        
        # Pull latest changes
        git pull
        
        # Add all changes to git
        git add .
        
        # Commit the changes with a generic message (you can customize this)
        git commit -m "Auto commit"
        
        # Push changes to remote
        git push origin main
        
        echo "Successfully synced $REPO_PATH"
    else
        echo "Directory $REPO_PATH does not exist. Skipping."
    
