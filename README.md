# PSFetch.ps1

## What is PSFetch?

A popular implementation of the Bash Screenshot System Information Utility (screenFetch), built in PowerShell.

Similar (in vein) to both [WinScreeny](https://github.com/Nijikokun/WinScreeny) and [CMDfetch](https://github.com/hal-ullr/cmdfetch)
without the dependencies of LUA or a different command shell. This script is 100% written in PowerShell.


![psfetch](http://i.imgur.com/EImqg5p.png)


## Instructions

Clone the repository into a folder under your profile.

    cd %UserProfile%

    git clone https://github.com/mikepruett3/psfetch.git psfetch

Once the repo has been cloned to your user profile simply place this PowerShell script in your path somewhere, or create a link to the script in a folder
which is already in your path...

    PS > mklink %SystemRoot%\System32\psfetch.ps1 %UserProfile%\psfetch\psfetch.ps1

After that, make sure that your PowerShell Environment - **Execution Policy** is configured for **Unrestricted**.

    PS > Set-ExecutionPolicy Unrestricted

## Usage

Once the script is somewhere in your path, you can execute it from any directory using the following...

    PS > psfetch.ps1

If you want to actually take a screenshot, include the **-PATH** variable to specify where to store the screenshot

    PS > psfetch.ps1 -Path "Path\to\output\file"

