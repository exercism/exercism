### Can't Fetch or Submit

If you're having trouble fetching or submitting exercises, you may not have the most recent version of the command-line client.

To determine which version of the CLI you're using, run:

```bash
exercism -v
```

The most recent version of the CLI can be found [on GitHub](https://github.com/exercism/cli/releases/latest).

Next verify that the CLI is configured. Run:

```bash
exercism debug
```

Look at the API key, and compare it to the one in [your account](http://exercism.io/account/key). It will look something like this:

```plain
API Key: 91a1cc34b03dbcc93d81603454087da526fcc6c5
```

If the API key is incorrect, then re-run the `configure` command:

```bash
exercism configure --key=YOUR_API_KEY
```

Next look at the Exercises Directory. It will look something like this:

```plain
Exercises Directory: /home/you/exercism
```

To change the directory where exercises are downloaded, use the following command (Be sure to enclose the directory path inside double quotes):

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
