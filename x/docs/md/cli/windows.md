
## Windows 

Below are instructions for install using the most common methods - using Powershell & Chocolately Package Manager. For further help and instructions, see:
1. [troubleshooting for instructions on installing manually on windows](#troubleshooting)
2. [exercism.io general help](http://exercism.io/help)
3. [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)


### Using Powershell and the Chocolatey Package Manager for Windows <a name="chocolatey"></a>  
**NOTE:** You can find more information about using Chocolatey at the [Chocolatey site](https://chocolatey.org/).

#### Using PowerShell 
Windows ships with a powerful scripting language called [PowerShell](https://en.wikipedia.org/wiki/Windows_PowerShell).

Type in `powershell` in the search or run window in Windows. You may see two options - `PowerShell` and `PowerShell ISE`. The first is the regular PowerShell command prompt window. The second is the Interactive Scripting Environment. Feel free to choose either one. Here's [more](http://www.powershellpro.com/powershell-tutorial-introduction/tutorial-windows-powershell-console/) on getting started with PowerShell. Paste and run the following script and you're ready to go. This downloads Chocolatey, sets the environment path variable, and installs the exercism CLI.

```powershell
function which($name) { Get-Command $name -ErrorAction SilentlyContinue | Select-Object Definition }

if ((which cinst) -eq $null) {
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

cinst exercism-io-cli
```

#### Using the Command Prompt 
1. Open a command line interface (CLI) by clicking on "Start", typing "cmd" into the search bar and pressing enter
2. Next copy and paste the following command into the command window:
```
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
```
3. Once the installation finishes, Chocolatey should be installed. To test the installation you can open a new command window (step 1) and enter the following command:
```
choco /?
```
You should see the help documentation for the "choco" command if all is well
4. Next we need to install the Exercism CLI.  Open up a new command window (step 1) and type in the following:
```
choco install exercism-io-cli
```
5. Proceed to [Running exercism](#run-exercism) to test the exercism install
6. If at anytime you need to update the exercism CLI to a newer version you can open up a command line (step 1) and type in the following:
```
choco update exercism-io-cli
```

#### Verifying Your Installation 
Verify that the binary was installed properly by running:

```
exercism --version
```

To see all the commands available to you, run `exercism` without any options:

```
exercism
```

#### Configuring the CLI 

Configure the exercism client so that it knows which account to post your solutions to:

```
exercism configure --key=YOUR_API_KEY
```

Your exercism API key can be found in [your account](/account/key).

By default the CLI will fetch exercises to `~/exercism`.
You can configure a different directory by passing the `--dir` option:

```
exercism configure --dir=~/some/other/place
```
### Continue 
You can now continue by [choosing a language](http://exercism.io/languages).