# To install, source this file from your PowerShell profile

# Initialize the Git prompt directory
$global:__GIT_PROMPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Set the Git prompt executable
$global:GIT_PROMPT_EXECUTABLE = $env:GIT_PROMPT_EXECUTABLE -or "python"

# Simple approach without ANSI colors for better compatibility
$global:reset_color = ""

# Default values for the appearance of the prompt. Configure at will.
$global:ZSH_THEME_GIT_PROMPT_PREFIX = "["
$global:ZSH_THEME_GIT_PROMPT_SUFFIX = "]"
$global:ZSH_THEME_GIT_PROMPT_SEPARATOR = "|"
$global:ZSH_THEME_GIT_PROMPT_STAGED = "*"  # Staged files
$global:ZSH_THEME_GIT_PROMPT_CONFLICTS = "X"  # Conflicts
$global:ZSH_THEME_GIT_PROMPT_CHANGED = "+"  # Modified files
$global:ZSH_THEME_GIT_PROMPT_BEHIND = "↓"  # Behind remote
$global:ZSH_THEME_GIT_PROMPT_AHEAD = "↑"  # Ahead of remote
$global:ZSH_THEME_GIT_PROMPT_UNTRACKED = "?"  # Untracked files
$global:ZSH_THEME_GIT_PROMPT_CLEAN = "✓"  # Clean repo

# Function to update Git variables
function Update-GitVars {
    $global:__CURRENT_GIT_STATUS = $null

    if ($global:GIT_PROMPT_EXECUTABLE -eq "python") {
        $gitstatus = "$global:__GIT_PROMPT_DIR/gitstatus.py"
        $global:_GIT_STATUS = & python $gitstatus 2>$null
    } elseif ($global:GIT_PROMPT_EXECUTABLE -eq "haskell") {
        $global:_GIT_STATUS = & git status --porcelain --branch 2>$null | & "$global:__GIT_PROMPT_DIR/src/.bin/gitstatus"
    }

    $global:__CURRENT_GIT_STATUS = $global:_GIT_STATUS -split " "
    $global:GIT_BRANCH = $global:__CURRENT_GIT_STATUS[0]
    $global:GIT_AHEAD = $global:__CURRENT_GIT_STATUS[1]
    $global:GIT_BEHIND = $global:__CURRENT_GIT_STATUS[2]
    $global:GIT_STAGED = $global:__CURRENT_GIT_STATUS[3]
    $global:GIT_CONFLICTS = $global:__CURRENT_GIT_STATUS[4]
    $global:GIT_CHANGED = $global:__CURRENT_GIT_STATUS[5]
    $global:GIT_UNTRACKED = $global:__CURRENT_GIT_STATUS[6]
}

# Function to update Git variables before executing a command
function PreExec-UpdateGitVars {
    param (
        [string]$command
    )
    if ($command -match "^(git|hub|gh|stg)") {
        $global:__EXECUTED_GIT_COMMAND = $true
    }
}

# Function to update Git variables before displaying the prompt
function PreCmd-UpdateGitVars {
    if ($global:__EXECUTED_GIT_COMMAND -or -not $global:ZSH_THEME_GIT_PROMPT_CACHE) {
        Update-GitVars
        $global:__EXECUTED_GIT_COMMAND = $null
    }
}

# Function to update Git variables when changing directories
function ChPwd-UpdateGitVars {
    Update-GitVars
}

# Function to get the Git super status with colors
function Get-GitSuperStatus {
    PreCmd-UpdateGitVars
    if ($global:__CURRENT_GIT_STATUS) {
        # Start building the prompt
        Write-Host "$global:ZSH_THEME_GIT_PROMPT_PREFIX" -NoNewline
        Write-Host "$global:GIT_BRANCH" -ForegroundColor Magenta -NoNewline
        
        if ($global:GIT_BEHIND -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_BEHIND$global:GIT_BEHIND" -ForegroundColor Yellow -NoNewline
        }
        if ($global:GIT_AHEAD -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_AHEAD$global:GIT_AHEAD" -ForegroundColor Yellow -NoNewline
        }
        
        Write-Host "$global:ZSH_THEME_GIT_PROMPT_SEPARATOR" -NoNewline
        
        if ($global:GIT_STAGED -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_STAGED$global:GIT_STAGED" -ForegroundColor Red -NoNewline
        }
        if ($global:GIT_CONFLICTS -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_CONFLICTS$global:GIT_CONFLICTS" -ForegroundColor Red -NoNewline
        }
        if ($global:GIT_CHANGED -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_CHANGED$global:GIT_CHANGED" -ForegroundColor Blue -NoNewline
        }
        if ($global:GIT_UNTRACKED -ne 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_UNTRACKED" -ForegroundColor Cyan -NoNewline
        }
        if ($global:GIT_CHANGED -eq 0 -and $global:GIT_CONFLICTS -eq 0 -and $global:GIT_STAGED -eq 0 -and $global:GIT_UNTRACKED -eq 0) {
            Write-Host "$global:ZSH_THEME_GIT_PROMPT_CLEAN" -ForegroundColor Green -NoNewline
        }
        
        Write-Host "$global:ZSH_THEME_GIT_PROMPT_SUFFIX" -NoNewline
        
        # Return empty string since we've already written the output
        return ""
    }
}

# Export the main function
Export-ModuleMember -Function Get-GitSuperStatus
