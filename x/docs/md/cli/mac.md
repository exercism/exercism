### Methods of Installing Exercism CLI

  - [With Homebrew](#installing-with-homebrew)
  - [Without Homebrew](#installing-without-homebrew)

Homebrew is a package manager for OS X which installs the stuff that Apple
didn't.

Find out if you have homebrew installed via the terminal.

You can open a terminal using Spotlight by pressing <command><spacebar> and
then type 'terminal' in the space provided.

On the command prompt, type in the command:

`\brew --version`

If homebrew is installed you may see output like the following (version numbers may vary):

```
Homebrew 0.9.9 (git revision a5586; last commit 2016-05-09)
Homebrew/homebrew-core (git revision 3b4c; last commit 2016-05-09)
```

Install the CLI via homebrew in the following section.  Otherwise see
"[Installing Without Homebrew](#installing-without-homebrew)".

### Installing With Homebrew <a name="installing-with-homebrew"></a>

Install the CLI via [homebrew](http://brew.sh/) with the following command:

```
brew update && brew install exercism
```

Verify that it was installed properly by running:

```bash
exercism --version
```

If there was a problem you will get an error message saying _command not found_.

If everything is fine, you're done installing the CLI, and you can move on to the next step,
which is configuring the CLI.

### Installing Without Homebrew <a name="installing-without-homebrew"></a>

This is described in detail in [this video tutorial](https://www.youtube.com/watch?v=TCT4eHGwfaE).

First you need to know which processor architecture your computer has. If
you're not sure, you can use Terminal.app to find out:

Open Terminal.app and type in the following command:

```bash
uname -m
```

Common values are `i386` (32-bit) and `x86_64` (64-bit). If you have something
different, you'll need to ask Google about the details.

If you don't have a directory in your home directory called `bin`, make one now:

```bash
mkdir ~/bin
```

Next, [get the latest
release](https://github.com/exercism/cli/releases/latest) from GitHub, making
sure to get the one that is both for Mac and for your architecture:

Unzip the downloaded archive:

```bash
cd ~/Downloads
tar -xzvf exercism-mac-64bit.tgz
```

Move the exercism binary to the bin directory:

```bash
mv exercism ~/bin/
```

Check if `~/bin` is on your path:

```bash
echo $PATH
```

Look for a section between two colons that looks like
`/Users/<your-username>/bin` or `~/bin`.

If it's not there, you need to add it. In order to do so, you'll need to
know which shell you use, so that you can add it to the correct config.

Find out, by running:

```bash
echo $SHELL
```

If it says `/bin/bash`, then you're using the default that ships with the Mac.
If not, you'll need to replace `.bash_profile` with the name of the correct
config file.

```bash
echo 'export PATH=~/bin:$PATH' >> ~/.bash_profile
```

Finally, source your shell config:

```bash
source ~/.bash_profile
```

You should now have access to the exercism command:

```bash
exercism --version
```
