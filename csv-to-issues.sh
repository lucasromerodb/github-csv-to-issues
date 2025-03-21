#!/bin/bash

# Ensure GitHub CLI is installed
if ! command -v gh &> /dev/null
then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Ensure user is authenticated
if ! gh auth status &> /dev/null
then
    echo "Error: You are not logged into GitHub CLI. Run 'gh auth login' to authenticate."
    exit 1
fi

# Ensure issues.csv exists
read -p "Enter CSV file path: " CSV_FILE_USER_INPUT
CSV_FILE=$CSV_FILE_USER_INPUT
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: CSV file '$CSV_FILE' not found."
    exit 1
fi

# Ask for repository input as a URL
read -p "Enter GitHub repository URL: " REPO_URL_USER_INPUT

# Extract org and repo from URL
ORG_REPO=$(echo "$REPO_URL_USER_INPUT" | sed -E 's|https://github.com/||' | sed -E 's|/.*$||')
REPO_NAME=$(echo "$REPO_URL_USER_INPUT" | sed -E 's|https://github.com/[^/]*/||' | sed -E 's|/.*$||')
REPO_URL="https://github.com/$ORG_REPO/$REPO_NAME"

echo "--------------------------------"
echo "🐙 REPO_URL: $REPO_URL"
echo "🐙 REPO_NAME: $REPO_NAME"
echo "--------------------------------"

# Ensure authentication with proper scopes
gh auth refresh -s project

# Function to check and create label if not exists
check_and_create_label() {
    local label=$(echo "$1" | tr -d '\r') # Normalize label
    local exists=$(gh label list --repo "$REPO_URL" | awk -F"\t" '{print $1}' | grep -w "$label")

    if [ -z "$exists" ]; then
        echo "🏷️ Label '$label' does not exist. Creating..."
        gh label create "$label" --repo "$REPO_URL"
    fi
}

# Read and upload issues from CSV
while IFS="," read -r title body label; do
    # Skip the header row
    if [ "$title" == "title" ]; then
        continue
    fi

    echo ""
    echo "-------------------"
    echo "🐙 PROCESSING ISSUE"

    # Normalize input
    title=$(echo "$title" | tr -d '\r')
    body=$(echo "$body" | tr -d '\r')
    label=$(echo "$label" | tr -d '\r')

    # Ensure title is not empty
    if [ -z "$title" ]; then
        echo "Skipping issue with empty title"
        continue
    fi

    # Ensure body is not empty; provide a default if needed
    if [ -z "$body" ] || [ "$body" == "null" ]; then
        body="No description provided."
    fi

    # Check and create label if needed
    if [ -n "$label" ] && [ "$label" != "null" ]; then
        check_and_create_label "$label"
    fi

    # Construct GitHub CLI command
    CMD="gh issue create --repo $REPO_URL --title \"$title\" --body \"$body\""

    # Add label if present
    if [ -n "$label" ] && [ "$label" != "null" ]; then
        CMD="$CMD --label \"$label\""
    fi

    # Execute the command
    eval $CMD
    echo "✅ Created issue: $title"

done < <(tail -n +2 "$CSV_FILE")
