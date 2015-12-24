There are two options for installing the Exercism CLI on Windows.

1. [Manual Installation](#manual)
1. [Using the Chocolatey Package Manager for Windows](#chocolatey)

## Manual Installation <a name="manual"></a>
What follows are instructions that work for installing exercism on Windows 7 or Windows 8.
Instructions for other versions of Windows may differ slightly, but the principle will be the same.

For a visual guide, [see this screencast](https://www.youtube.com/watch?v=R9Y9yuXA-qA).

**NOTE:** You will need Admin privileges for some of the steps detailed below. If you don't have them, get someone with those privileges to do the install for you.

### Short Version

 1. [Download the zip file](https://github.com/exercism/cli/releases/latest) that corresponds to your Windows installation (32-bit or 64-bit).
 1. Extract `exercism.exe` to a folder of your choice.
 1. Add that folder to your `PATH`.

### Before you start
Before you download exercism you will need to determine whether you are running a 32-bit or 64-bit version of Windows. You can do this as follows:

1. Open the Windows Control Panel
	1. In Windows 7 this can be accomplished by clicking on "Start" and selecting "Control Panel" from the list on the right
	1. In Windows 8 this can be accomplished by right clicking on "Start" and selecting "Control Panel" from the menu that appears
1. Select "System"
1. A reasonable amount of information is displayed, including the "System type". This will tell you whether you have a 32-bit or 64-bit Operating System and whether you have a 32-bit or 64-bit processor
1. **NOTE 1** It is possible to install a 32-bit version of Windows on a 64-bit processor. You need to take note of the version of the Operating System, not the processor
1. **NOTE 2** Keep this System window open as you will make use of it further down

### Downloading the appropriate file
Determine which is the appropriate exercism Windows patch release for your Operating System (`exercism-windows-32bit.zip` for a 32-bit Operating System or `exercism-windows-64bit.zip` for a 64-bit Operating System) and [download it from here](https://github.com/exercism/cli/releases/latest)

### Copying `exercism.exe` to its own folder
1. Open File Explorer and create a new folder where you want to place `exercism.exe` (e.g. `C:\Exercism` or `C:\Program Files\Exercism`)
1. Open the downloaded `exercism-windows-*.zip` file, select `exercism.exe` and copy it into the folder you created in the previous step

### Adding the executable's directory to PATH
Adding the location of exercism.exe to the PATH variable allows you to call exercism from any command line location, i.e.:
```
C:\Users\MyName> exercism help
```
Instead of having to type the full\path\to\exercism.exe every time:
```
C:\Users\MyName> C:\Program Files\Exercism\exercism.exe help
```

Before you start, you can create a backup of your PATH variable by opening cmd.exe (Command Prompt) and typing the following command:
```
C:\Users\MyName> PATH > yyyy-mm-dd_PATH_backup.txt
```
This way you have a copy of PATH as it existed before you start the below steps.

The following instructions will append the location of the exercism.exe file to the current value in the PATH variable. The directories in the PATH are separated by semicolons, so you should add a semicolon to the end of what you currently have, and then add the location of exercism.

1. **WARNING:** You are about to update your "PATH" user or system variable. You must carefully follow the instructions below, as deleting any existing paths could have serious implications for your Windows installation. This is not difficult, just make sure you don't rush through this stage and miss a step. If you are worried about making the change below, I suggest you choose to make exercism available just for you as the impact of any mistake should be significantly less.
1. In the System window left open in "Before you start", Select "Advanced system settings"
1. If you are asked "Do you want to allow the following program to make changes to this computer?" click on "Yes"
1. Click on "Environment Variables..."
1. At this point you have the option of making exercism available just for the current user or for every user:
	1. **Only for the current user:** In the upper list, "User variables for \<your username\>", find and select "PATH" and click on "Edit...". If you can't find "PATH", click on "New..." and type "PATH" into "Variable name"
	1. **For every user:** In the lower list, "System variables", find and select "Path" and click on "Edit..."
1. **WARNING:** If you are adding a path to a previously existing list:
	1. **DO NOT** start typing, as the current "PATH"/"Path" value is selected and will be deleted when you type. If this warning is too late, **YOU MUST** click on "Cancel" and go back to the previous step
	1. Press the "End" key to take you to the end of the value
	1. type in a semi-colon ";"
1. Type in the path to where you have placed `exercism.exe` (you can paste in the location if you open the exercism folder in Explorer, click in the location bar at the top and copy the text)
1. **NOTE:** If you can't remember where you have placed the file, search for "exercism.exe" in Explorer, open the folder by right-clicking on `exercism.exe` and clicking on "Open file location", then follow the instructions in the previous step to copy and paste the location into the PATH value

### Running exercism <a name="run-exercism"></a>
1. Open a command line interface (CLI) by clicking on "Start", typing "cmd" into the search bar and pressing enter
1. In the resulting window type in "exercism" and press Enter
1. If all is well you should be shown information on how to use exercism

## Using the Chocolatey Package Manager for Windows <a name="chocolatey"></a>
**NOTE:** You can find more information about using Chocolatey at the [Chocolatey site](https://chocolatey.org/).

### Using PowerShell
Windows ships with a powerful scripting language called [PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell). With this it's fairly easy to get started.

Type in `powershell` in the search or run window in Windows. You may see two options - `PowerShell` and `PowerShell ISE`. The first is the regular PowerShell command prompt window. The second is the Interactive Scripting Environment. Feel free to choose either one. Here's [more](http://www.powershellpro.com/powershell-tutorial-introduction/tutorial-windows-powershell-console/) on getting started with PowerShell. Paste and run the following script and you're ready to go. This downloads Chocolatey, sets the environment path variable, and installs the exercism CLI.

```powershell
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }

if ((which cinst) -eq $null) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

cinst exercism-io-cli
```

### Using the Command Prompt
1. Open a command line interface (CLI) by clicking on "Start", typing "cmd" into the search bar and pressing enter
1. Next copy and paste the following command into the command window:
```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```
1. Once the installation finishes, Chocolatey should be installed. To test the installation you can open a new command window (step 1) and enter the following command:
```
choco /?
```
You should see the help documentation for the "choco" command if all is well
1. Next we need to install the Exercism CLI.  Open up a new command window (step 1) and type in the following:
```
choco install exercism-io-cli
```
1. Proceed to [Running exercism](#run-exercism) to test the exercism install
1. If at anytime you need to update the exercism CLI to a newer version you can open up a command line (step 1) and type in the following:
```
choco update exercism-io-cli
```
