## Mac OSX

Below are instructions for install using the most common method - using Homebrew. For further help and instructions, see:

1. [Install Alternatives for instructions on installing without Homebrew](/cli/install)
2. [exercism.io general help](http://exercism.io/help)
3. [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)

### Installing Homebrew

If you already have Homebrew installed, feel free to skip to the [Exercism CLI installation](#install-exercism-cli).

Homebrew is a package manager for OS X which installs the stuff that Apple didn't. Find out if you have Homebrew installed via the terminal.

You can open a terminal using Spotlight with the keys: 'command + space', and then type 'terminal' in the space provided. On the command prompt, type in the command:

```bash
brew --version
```

If Homebrew is installed you may see an output like the following (version numbers may vary):

```
Homebrew 0.9.9 (git revision a5586; last commit 2016-05-09)
Homebrew/homebrew-core (git revision 3b4c; last commit 2016-05-09)
```

If Homebrew isn't installed, you can:

1. install via [Homebrew's brew.sh site](http://brew.sh/)
2. see [Install Alternatives for instructions on installing without Homebrew](/cli/install)

### Installing the Exercism CLI <a name="install-exercism-cli"></a>

Once you have Homebrew installed, you can install the Exercism CLI with the following command:

```bash
brew update && brew install exercism
```

Verify that it was installed properly by running:

```bash
exercism --version
```

If there was a problem you will get an error message saying command not found.

To see all the commands available to you, run `exercism` without any options:

```bash
exercism
```

### Configuring the Exercism CLI

Configure the exercism client so that it knows which account to post your solutions to:

```bash
exercism configure --key=YOUR_API_KEY
```

Your exercism API key can be found in [your account](/account/key).

By default the CLI will fetch exercises to `~/exercism`.
You can configure a different directory by passing the `--dir` option:

```bash
exercism configure --dir=~/some/other/place
```

### Setting up Exercism CLI completion (optional)

#### Bash

If you use a Bash shell, you can use the CLI Bash-completion script.

First download the script [[view source]](http://cli.exercism.io/exercism_completion.bash):

```bash
mkdir -p ~/.config/exercism/
curl http://cli.exercism.io/exercism_completion.bash > ~/.config/exercism/exercism_completion.bash
```

Load up the completion in your `.bashrc`, `.bash_profile` or `.profile` by adding the following snippet:

```bash
if [ -f ~/.config/exercism/exercism_completion.bash ]; then
  . ~/.config/exercism/exercism_completion.bash
fi
```

After opening a new Bash shell, you should be able to type `exercism s` and Bash completion will give you `exercism submit`.

#### Zsh

If you use a Zsh shell, you can use the CLI Zsh-completion script.

First download the script [[view source]](http://cli.exercism.io/exercism_completion.zsh):

```zsh
mkdir -p ~/.config/exercism/
curl http://cli.exercism.io/exercism_completion.bash > ~/.config/exercism/exercism_completion.bash
```

Load up the completion in your `.zshrc`, `.zsh_profile` or `.profile` by adding the following snippet:

```zsh
if [ -f ~/.config/exercism/exercism_completion.zsh ]; then
  . ~/.config/exercism/exercism_completion.zsh
fi
```

If you are using the popular [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) framework to manage your Zsh plugins,
you don't need to add the above snippet, all you need to do is create a file `exercism_completion.zsh` inside `~/.oh-my-zsh/custom`.

After opening a new Zsh shell, you should be able to type `exercism s` and Zsh completion will give you `exercism submit`.

### Continue

You can now continue by [choosing a language](http://exercism.io/languages).

### Removing Exercism CLI

#### With Homebrew

If you wish to remove your exercism config file, you will need to locate it before uninstalling the cli. You can locate it by running:

```bash
exercism debug
```

Then go ahead and remove this file with:

```bash
rm /path/to/config/file
```

You can remove the exercism cli with:

```bash
brew uninstall exercism
```
