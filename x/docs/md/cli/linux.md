
## Linux

View the CLI releases to [choose and download the appropriate package for your operating system](https://github.com/exercism/cli/releases/tag/v2.3.0).

If you're unsure what architecture your processor has, the command `uname -m` should tell you.

Extract the binary using `tar -xzvf FILENAME`, e.g.

```
tar -xzvf exercism-linux-32bit.tgz
```

Place the binary in your `PATH`, e.g.:

```
mkdir ~/bin
mv exercism ~/bin/
export PATH=$HOME/bin:$PATH
```

You will want to stick the `export PATH=$HOME/bin:$PATH` line into your shell configuration. E.g. if your
shell is `bash`, you could run:

```
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
```

To check which shell you have, run `echo $SHELL`.

### Package Managers

These are not officially supported, and sometimes (often) lag behind the latest release.

There's a [freshports build](http://www.freshports.org/misc/exercism), an [AUR package](https://aur.archlinux.org/packages/exercism-cli), and an [openSUSE package](https://software.opensuse.org/package/golang-github-exercism-cli).

### Verify

Verify that the binary was installed properly by running:

```bash
exercism --version
```

To see all the commands available to you, run `exercism` without any options:

```bash
exercism
```

### Configuring the CLI

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

If you need help, view the [help on exercism.io](http://exercism.io/help), [join the exercism.io chat on gitter](https://gitter.im/exercism/support): [![Join the chat at https://gitter.im/exercism/support](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/exercism/support)

