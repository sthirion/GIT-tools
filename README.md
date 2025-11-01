# GIT-tools

A collection of command-line utilities for enhanced Git workflow and repository management, providing visual git status information and branch management tools.

## Features

- **Enhanced Git Prompt**: Display detailed git repository status directly in your shell prompt
- **Cross-Platform Support**: Works on Linux/macOS (Bash/Zsh) and Windows (PowerShell)
- **Real-time Status**: Shows branch name, ahead/behind commits, staged files, conflicts, changes, and untracked files
- **Visual Indicators**: Color-coded symbols for different git states
- **Branch Listing**: Utility to list all branches across multiple git repositories

## Tools Overview

### 1. Git Status Prompt (`git_colors.sh` / `git-prompt.psm1`)
Enhances your shell prompt with real-time git repository information including:
- Current branch name
- Number of commits ahead/behind remote
- Number of staged files (●)
- Number of conflicted files (✖)
- Number of modified files (✚)
- Number of untracked files (…)
- Clean repository indicator (✔)

### 2. Git Status Parser (`gitstatus.py`)
Python script that parses git repository status and outputs formatted information for use by the shell prompt functions.

### 3. Branch Lister (`list_branches.sh`)
Bash script that scans all subdirectories for git repositories and lists their branches.

## Installation

### Prerequisites
- Git installed and accessible from command line
- Python 3.x (for `gitstatus.py`)

### For Linux/macOS (Bash/Zsh)

1. Clone or download this repository:
   ```bash
   git clone https://github.com/sthirion/GIT-tools.git
   cd GIT-tools
   ```

2. Source the git prompt script in your shell configuration file:
   
   **For Zsh** (add to `~/.zshrc`):
   ```bash
   source /path/to/GIT-tools/git_colors.sh
   ```
   
   **For Bash** (add to `~/.bashrc` or `~/.bash_profile`):
   ```bash
   source /path/to/GIT-tools/git_colors.sh
   ```

3. Add the git status to your prompt. Add this to your shell config:
   ```bash
   # Example for Zsh
   PROMPT='%~ $(git_super_status)$ '
   
   # Example for Bash
   PS1='\w $(git_super_status)\$ '
   ```

4. Reload your shell configuration:
   ```bash
   source ~/.zshrc    # for Zsh
   # or
   source ~/.bashrc   # for Bash
   ```

### For Windows (PowerShell)

**✅ Successfully tested and verified on Windows with PowerShell!**

1. Clone or download this repository:
   ```powershell
   git clone https://github.com/sthirion/GIT-tools.git
   Set-Location GIT-tools
   ```

2. Import the PowerShell module in your PowerShell profile:
   
   First, find your PowerShell profile location:
   ```powershell
   $PROFILE
   ```
   
   Create the profile file if it doesn't exist:
   ```powershell
   if (!(Test-Path -Path $PROFILE)) {
       New-Item -ItemType File -Path $PROFILE -Force
   }
   ```
   
   Add this line to your PowerShell profile:
   ```powershell
   Import-Module "C:\path\to\GIT-tools\git-prompt.psm1"
   ```

3. Customize your prompt by adding this to your PowerShell profile:
   ```powershell
   function prompt {
       $location = Get-Location
       Write-Host "$location " -NoNewline
       Get-GitSuperStatus
       Write-Host "> " -NoNewline
       return " "
   }
   ```

4. Reload your PowerShell profile:
   ```powershell
   . $PROFILE
   ```

## Usage

### Git Prompt
Once installed, navigate to any git repository and your prompt will automatically display git status information:

**Linux/macOS/Bash:**
```
~/my-project (main|✚1…2)$ 
```

**Windows PowerShell:**
```
C:\my-project [main|?+1] > 
```

This shows:
- `main`: current branch (colored)
- `?`: untracked files
- `+1`: 1 modified file

### Status Indicators

**Linux/macOS (Bash/Zsh):**
- `●`: Staged files ready for commit
- `✖`: Files with merge conflicts
- `✚`: Modified files (unstaged changes)
- `…`: Untracked files
- `✔`: Clean working directory
- `↑`: Commits ahead of remote
- `↓`: Commits behind remote

**Windows (PowerShell):**
- `*`: Staged files ready for commit (Red)
- `X`: Files with merge conflicts (Red)
- `+`: Modified files (unstaged changes) (Blue)
- `?`: Untracked files (Cyan)
- `✓`: Clean working directory (Green)
- `↑`: Commits ahead of remote (Yellow)
- `↓`: Commits behind remote (Yellow)
- Branch names appear in Magenta

### Branch Listing
To list all git branches in subdirectories:

**Linux/macOS:**
```bash
./list_branches.sh
```

**Windows (using Git Bash or WSL):**
```bash
bash list_branches.sh
```

## Customization

### Colors and Symbols
You can customize the appearance by modifying the theme variables in the configuration files:

**For Bash/Zsh** (in `git_colors.sh`):
```bash
ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[red]%}%{●%G%}"
# ... and more
```

**For PowerShell** (in `git-prompt.psm1`):
```powershell
$global:ZSH_THEME_GIT_PROMPT_PREFIX = "("
$global:ZSH_THEME_GIT_PROMPT_SUFFIX = ")"
$global:ZSH_THEME_GIT_PROMPT_SEPARATOR = "|"
$global:ZSH_THEME_GIT_PROMPT_BRANCH = "`e[35m"  # Magenta
$global:ZSH_THEME_GIT_PROMPT_STAGED = "`e[31m●"  # Red
# ... and more
```

### Performance
For better performance in large repositories, you can enable caching:

**Bash/Zsh:**
```bash
export ZSH_THEME_GIT_PROMPT_CACHE=1
```

**PowerShell:**
```powershell
$global:ZSH_THEME_GIT_PROMPT_CACHE = $true
```

## Features Highlight

### PowerShell Color Support ✨
The Windows PowerShell implementation includes full color support using PowerShell's native `Write-Host` cmdlet:
- Branch names appear in **Magenta**
- Staged files in **Red**
- Modified files in **Blue** 
- Untracked files in **Cyan**
- Clean status in **Green**
- Ahead/behind indicators in **Yellow**

This provides a rich visual experience that makes it easy to quickly understand your repository status at a glance.

## Troubleshooting

### PowerShell Colors Not Working
If colors don't appear in PowerShell:
1. Ensure you're using the updated prompt function that uses `Write-Host`
2. Check that your terminal supports colors (most modern terminals do)
3. Verify the module is properly imported with: `Get-Module git-prompt`

### Python Issues
If you encounter Python-related errors:
1. Ensure Python 3.x is installed and accessible via `python` command
2. Try setting the executable explicitly:
   ```bash
   export GIT_PROMPT_EXECUTABLE="python3"  # Linux/macOS
   ```
   ```powershell
   $global:GIT_PROMPT_EXECUTABLE = "python3"  # PowerShell
   ```

### Windows PowerShell Execution Policy
If you get execution policy errors in PowerShell:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Performance in Large Repositories
For very large repositories, the git status checks might be slow. Consider:
1. Using git's built-in performance optimizations
2. Excluding the prompt in specific large repositories
3. Enabling the cache option mentioned above

## Requirements

- **Git**: Version 2.0 or higher
- **Python**: Version 3.6 or higher
- **Bash/Zsh**: For Linux/macOS shell integration
- **PowerShell**: Version 5.1 or higher for Windows

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Credits

Originally created for enhancing git workflow productivity with visual status indicators across different shell environments.