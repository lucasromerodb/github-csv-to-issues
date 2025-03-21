
# GitHub Issues CSV Importer

> .csv file to GitHub issues

A bash script utility that enables bulk importing of issues into GitHub repositories from a CSV file. This tool leverages the GitHub CLI (`gh`) to automate the creation of issues with titles, descriptions, and labels.

## 🚀 Features

- Bulk import issues from CSV files
- Automatic label creation
- Input validation and sanitization
- Support for issue titles, descriptions, and labels
- Error handling and validation checks
- Progress tracking with visual indicators

## 📋 Prerequisites

- [GitHub CLI](https://cli.github.com/) installed on your system
- Active GitHub account with repository access
- Bash shell environment
- CSV file containing issue data

## 📥 Installation

1. Clone this repository or download the script
2. Make the script executable:
   ```bash
   chmod +x import-issues.sh
   ```

## 📄 CSV File Format

Your CSV file must follow this example structure:

```csv
title,body,label
Fix payment processing bug when card is declined,,
Improve map loading speed on mobile,Affects multiple users.,
Add dark mode support for the app,This issue occurs intermittently.,documentation
Add support for multiple payment methods,This issue occurs intermittently.,frontend
Fix incorrect distance calculations,,wontfix
```

### Required CSV Headers:
- `title`: Issue title (required)
- `body`: Issue description (optional)
- `label`: Issue label (optional)

## 🔧 Usage

1. Ensure you're logged into GitHub CLI:
   ```bash
   gh auth login
   ```

2. Run the script:
   ```bash
   ./import-issues.sh
   ```

3. When prompted, enter your CSV file path:
   ```bash
   Enter CSV file path: issues.csv
   ```

4. When prompted, enter your GitHub repository URL:
   ```bash
   Enter GitHub repository URL: https://github.com/username/repository
   ```

## 📝 Example

```bash
./import-issues.sh

Enter CSV file path: issues.csv
Enter GitHub repository URL: https://github.com/username/myrepo
--------------------------------
🐙 REPO_URL: https://github.com/username/myrepo
🐙 REPO_NAME: myrepo
--------------------------------

! First copy your one-time code: ABCD-1234
Press Enter to open https://github.com/login/device in your browser...
✓ Authentication complete.

-------------------
🐙 PROCESSING ISSUE

Creating issue in username/myrepo

https://github.com/username/myrepo/issues/34
✅ Created issue: Fix payment processing bug when card is declined

...
```

## 💥 Troubleshooting

### Common Errors and Solutions

1. **GitHub CLI Not Found**
   ```
   Error: GitHub CLI (gh) is not installed. Please install it first.
   ```
   Solution: Install GitHub CLI from https://cli.github.com/

2. **Authentication Error**
   ```
   Error: You are not logged into GitHub CLI. Run 'gh auth login' to authenticate.
   ```
   Solution: Run `gh auth login` and follow the authentication process

3. **CSV File Missing**
   ```
   Error: CSV file not found.
   ```
   Solution: Ensure your CSV file is in the same directory as the script

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.