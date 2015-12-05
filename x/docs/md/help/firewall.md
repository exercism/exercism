### Firewall

If you live behind a firewall, you can configure exercism to go through your proxy.

In linux and on mac, it will look like so:

```bash
set http_proxy=http://[user]:[pass]@[proxy host/port]
# or
export http_proxy=http://[user]:[pass]@[proxy host/port]
```

The following command will work inside PowerShell (tested on V3.0/Win7).

```bash
[Environment]::SetEnvironmentVariable("http_proxy","http://[user]:[pass]@[proxy]:[port]")
```
