## Windows

Below are installation instructions, using the most common method, the Chocolately Package Manager. For further help and instructions, see the following:

1. [Install Alternatives for instructions on installing manually on windows](/cli/install)
2. [exercism.io general help](http://exercism.io/help)
3. [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)


### Installing the Chocolatey Package Manager for Windows <a name="chocolatey"></a>

If you already have the Chocolatey Package Manager installed, feel free to skip to the [Exercism CLI installation](#install-exercism-cli).

Chocolately lets you install Windows applications quickly and easily. To install Chocolatey please refer to the [installation instructions on the Chocolatey website](https://chocolatey.org/install).

> **NOTE**
> Please ensure that when you open up your Windows shell, whether it's the Command Prompt or Powershell, you open it with **Administrator privileges**, otherwise the Chocolatey installation will fail. If you are unsure how to do this, please refer to the [help below](#open-win-cmd).

If you want to check if your Chocolatey installation has been successful, please refer to the [help below](#test-choco-install).

### Installing the Exercism CLI <a name="install-exercism-cli"></a>

With Chocolatey installed, you can now install the Exercism CLI. In your Windows shell, either the Command Prompt or Powershell, type in the following:

```
choco install exercism-io-cli
```
> **NOTE**
>  You don't need to open your Windows shell with Administrator privileges to use the `choco` command.

Type 'Y' to accept any prompts during the installation. If the installation was successful you should have output similar to the following:

![Exercism CLI installation](/img/cli/win-exercism-installation.png "Exercism CLI installation")

You now have access to the `exercism` command. You can type in `exercism --version` to get the current version of the Exercism CLI, or `exercism --help` to show the help menu.

![Exercism command](/img/cli/win-exercism-command.png "Exercism command")

### Upgrading the Exercism CLI

If at any time you need to upgrade the exercism CLI to a newer version you can open up your Windows shell and type in the following:

```
choco upgrade exercism-io-cli
```

### Configuring the Exercism CLI

Finally, you need to configure the Exercism CLI so that it knows which account to post your solutions to. You'll need your Exercism API key, which can be found in [your account](http://exercism.io/account/key). In your Windows shell type in the following command:

```
exercism configure --key=YOUR_API_KEY
```

Replace `YOUR_API_KEY` with your own [personal API key](http://exercism.io/account/key).

By default the CLI will fetch exercises to a directory called `exercism` within your home directory, `C:\Users\your-user-name\exercism`. You can configure a different directory by passing the `--dir` option:

```
exercism configure --dir=\my-exercism-exercises
```

This will fetch your exercises to `C:\Users\your-user-name\my-exercism-exercises`. You could also fetch the exercises to a directory outside of your home directory:

```
exercism configure --dir=C:\exercism
```

### Continue
You can now continue by [choosing a language](http://exercism.io/languages).

### Help

#### Opening the Windows Command Prompt with Administrator Privileges <a name="open-win-cmd"></a>

To open the Windows Command Prompt; access the Windows menu, by either clicking on the Windows logo in the Taskbar, or pressing the Windows key on the keyboard. In the search bar that comes up, type in `cmd`, which will bring up the `cmd.exe` program.

![cmd.exe in the Windows menu](/img/cli/win-menu-cmd.png "The cmd program in the windows menu")

To install Chocolately we need to use Administrator privileges. This is important, if you don't use Administrator privileges our computer won't let you install Chocolatey. To do this *right-click* on `cmd.exe` and in the menu that appears choose `Run as administrator`.

![Run cmd.exe as Administrator](/img/cli/win-run-cmd-as-admin.png "Run the cmd program as Administrator")

You will be asked if you want to allow the program to make changes to your computer. You can safely click *Yes* here. The Command Prompt program should then start, and look something similar to this:

![cmd.exe](/img/cli/win-cmd.png "The Windows command Prompt")

You can now continue to the [Chocolatey installation](#chocolatey)

#### Testing the Chocolatey Installation <a name="test-choco-install"></a>

If your installation of Chocolatey has gone well, you should see output in your Windows shell similar to the following:

![Successful Chocolatey installation](/img/cli/win-successful-choco-install.png "Successful Chocolatey installation")

You should now be able to use the `choco` command. Type in `choco`, this should return the version of Chocolatey you have installed.

![Chocolatey version](/img/cli/win-choco-version.png "Chocolatey version")

If this command fails, you may need to restart your Windows Command Prompt. Close it down, and reopen it. Please note that you now don't need to open it with Administrator privileges, so instead of right-clicking on the `cmd.exe` program, you can just click on it.

If Chocolatey has been installed correctly you can now continue to [install the Exercism CLI](#install-exercism-cli)

#### Further Assistance

If you experience any problems installing the Exercism CLI, please don't hesitate to reach out for further help and assistance. Chances are, someone else has had the same problem.

1. [Install Alternatives for instructions on installing manually on windows](/cli/install)
2. [exercism.io general help](http://exercism.io/help)
3. [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)
