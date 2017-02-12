### Can't Fetch or Submit

If you're having trouble fetching or submitting exercises, you may not have the most recent version of the command-line client.

To determine which version of the CLI you're using, run:

```bash
exercism -v
```

The most recent version of the CLI can be found [on GitHub](https://github.com/exercism/cli/releases/latest).

Next verify that the CLI is configured. Run `exercism configure`. It should look something like this

```bash
$ exercism configure

Configuration written to /home/you/.exercism.json

  --key=91a1cc34b03dbcc93d81603454087da526fcc6c5
  --dir=/home/you/exercism
  --host=http://exercism.io
  --api=http://x.exercism.io

```

The `--key` should look like the API key in [your account](http://exercism.io/account/key).

If the API key is incorrect, then re-run the `configure` command:

```bash
exercism configure --key=YOUR_API_KEY
```

The `--dir` in the output of `exercism configure` is the directory where the exercises will be downloaded. To change it, use the following command (Be sure to enclose the directory path inside double quotes):

```bash
exercism configure --dir="DIRECTORY PATH"
```

This should be the absolute path to the root directory for all the exercism problems. On a Mac, this might look like this:

```plain
Exercises Directory: /Users/you/exercism
```

On windows, it might look like this:

```plain
Exercises Directory: C:\Users\you\exercism
```
