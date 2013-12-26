## Troubleshooting

If you're having trouble fetching or submitting exercises, you may not have the most recent version of the command-line client.

To determine which version of the CLI you're using, run:

```bash
exercism -v
```

The most recent version of the CLI can be found [on GitHub](https://github.com/exercism/cli/releases/latest).

## Firewall

If you live behind a firewall, you can configure exercism to go through your proxy, like so:

```bash
set http_proxy=http://[user]:[pass]@[proxy host/port]
# or
export http_proxy=http://[user]:[pass]@[proxy host/port]
```
