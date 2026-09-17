# Linux for noobs

## Boot logs

```bash
journalctl -b                 # current startup logs
journalctl -b -p warning      # warnings, errors, criticals
journalctl -b -p err          # errors only
journalctl -k -b              # kernel logs from current boot
journalctl --list-boots       # boot history
journalctl -b -1              # previous boot
```

## App or service logs

```bash
systemctl | rg running                # list running services
journalctl -b -u bluetooth.service    # service logs this boot
journalctl -u bluetooth.service -f    # follow live service logs
systemctl status bluetooth.service    # service state + latest logs
systemctl restart bluetooth.service   # restart service
```

## Find boot problems

```bash
systemctl --failed                    # failed units
systemctl list-jobs                   # stuck startup jobs
systemd-analyze                       # boot time summary
systemd-analyze blame                 # slow units
systemd-analyze critical-chain        # boot dependency chain
```

## Search logs

```bash
journalctl -b | rg -i error
journalctl -b | rg -i failed
journalctl -b --since "10 minutes ago"
journalctl -b -o short-iso
```

## Common checks

```bash
df -h                                  # disk space
free -h                                # memory
ip addr                                # network addresses
ss -tulpn                              # listening ports
ps aux | rg bluetooth                  # process search
```

Replace `bluetooth.service` with your app's systemd unit name.
