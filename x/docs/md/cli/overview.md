The command-line interface is a stand-alone binary.
It is [written in Go](https://github.com/exercism/cli), but you don't need to have Go installed on your computer in order to use it.

## Installing the CLI

**If you already have Go installed on your computer** the easiest way to install the CLI is to use `go get`.

(If you don't have Go installed, then don't bother with this approach, there are easier ways).

```
go get -u github.com/exercism/cli/exercism
```

If you don't have Go installed, then _easiest_ depends on what kind of computer you have, and how familiar you are with the command-line and `PATH`.

**If you're comfortable with `PATH`**, go ahead and grab the latest release for your OS and architecture [here](https://github.com/exercism/cli/releases/latest). If not, check out the details below for how to best install this on your operating system.

Verify that the binary was installed properly by running:

```bash
exercism --version
```

To see all the commands available to you, run `exercism` without any options:

```bash
exercism
```

## Configuring the CLI

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

## Getting Comfortable on the Command-Line

If the command-line feels foreign and intimidating to you, go work through the excellent tutorial
[Learn Enough Command-Line to be Dangerous](http://www.learnenough.com/command-line-tutorial).

