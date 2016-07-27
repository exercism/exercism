Download the [latest release](http://github.com/exercism/cli/releases/latest).

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

## Package Managers

These are not officially supported, and sometimes (often) lag behind the latest release.

There's a [freshports build](http://www.freshports.org/misc/exercism), an [AUR package](https://aur.archlinux.org/packages/exercism-cli), and an [openSUSE package](https://software.opensuse.org/package/golang-github-exercism-cli).
