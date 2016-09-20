## Mac OSX

Below are instructions for install using the most common method - using Homebrew. For further help and instructions, see:

1. [Install Alternatives for instructions on installing without Homebrew](/cli/install)
2. [exercism.io general help](http://exercism.io/help)
3. [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)

### Installing With Homebrew

#### 1: Check For Homebrew

Homebrew is a package manager for OS X which installs the stuff that Apple didn't.
Find out if you have homebrew installed via the terminal.

You can open a terminal using Spotlight with the keys: 'command + space', and then type 'terminal' in the space provided.
On the command prompt, type in the command:

`\brew --version`

If homebrew is installed you may see output like the following (version numbers may vary):
```
Homebrew 0.9.9 (git revision a5586; last commit 2016-05-09)
Homebrew/homebrew-core (git revision 3b4c; last commit 2016-05-09)
```
If homebrew isn't installed, you can:
1. install via [homebrew's brew.sh site](http://brew.sh/)
2. see [Install Alternatives for instructions on installing without homebrew](/cli/install)

#### 2: Install Homebrew
Install the CLI via homebrew with the following command:

```
brew update && brew install exercism
```

Verify that it was installed properly by running:

```
exercism --version
```

If there was a problem you will get an error message saying command not found.

#### 3: Verify Installation
Verify that the binary was installed properly by running:

```bash
exercism --version
```

To see all the commands available to you, run `exercism` without any options:

```bash
exercism
```

#### 4: Configure the CLI

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
#### 5: Continue
You can now continue by [choosing a language](http://exercism.io/languages).

### Removing Exercism CLI

With Homebrew

If you wish to remove your exercism config file, you will need to
locate it before uninstalling the cli

You can locate it by running

```bash
exercism debug
```

Then go ahead and remove this file with

```bash
rm /path/to/config/file
```

You can remove the exercism cli with:

```bash
brew uninstall exercism
```


