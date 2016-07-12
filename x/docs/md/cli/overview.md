The command-line interface is a stand-alone binary.
Install the binary by choosing your operating system from the left navigation.

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

## Submitting Solutions

Use the submit command with the file you want to submit:

```
exercism submit path/to/file
```

To add a comment to your solution, use the `--comment` flag:

```
exercism submit path/to/file --comment 'Implementing it this way because...'
```

This is a great place to say what you were thinking, what was interesting about
the exercise, what you got stuck on, what surprised you, what trade-offs you
made, etc.

## Getting Comfortable on the Command-Line

If the command-line feels foreign and intimidating to you, go work through the excellent tutorial
[Learn Enough Command-Line to be Dangerous](http://www.learnenough.com/command-line-tutorial).
