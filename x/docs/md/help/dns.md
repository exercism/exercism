### "No DNS Server" Error

If you get an error that says "TCP Dial: No DNS Server", then you may have an invalid `/etc/resolve.conf` file.

If you're not sure what to put there, try this:

```
nameserver 127.0.0.1
```
