# My NixOS configuration files

Private for now.

## Commands

#### Build

Assuming that the config repo is cloned to `~/projects/nixos-config#default`, the first time on a system use:

```shell
nixos-rebuild switch --flake ~/projects/nixos-config#default
```

After first run or once `nh` installed otherwise, use:

1. For testing:
    ```shell
    nh os test ~/projects/nixos-config -H default
    ```
2. Once finalised (with boot entry):
    ```shell
    nh os switch ~/projects/nixos-config -H default
    ```

If you see errors, run `journalctl -u home-manager-$USER.service`.

#### Clean up

Clean up user generations, leaving only the most recent generation, with:

```shell
nh clean user --keep 3 --keep-since 2d --dry
```

Note that:

- `--keep 5` - At least keep 5 generations [default: 1]
- `--keep-since 4d` - At least keep gcroots and generations of the past 4 days [default: 0h]
- `all` instead of the above will do what it says

Clean up system generations that are older than 3 days, with:

```shell
nix-collect-garbage --delete-older-than 3d
```

Clean up system generations except the current one, with:

```shell
nix-collect-garbage -d
```

IMPORTANT: The above commands remove unused generations, but it doesn't remove the corresponding entries from the
bootloader. You'll need to rebuild again for the bootloader to be updated too.

#### Update

Update with:

```shell
nix flake update ~/projects/nixos-config
nh os switch ~/projects/nixos-config -H default
```

## Reminders

#### Using Gnome and made some config changes in the UI?

Once you've done this once, it's probably best to simply run `dconf watch /` and update the relevant .nix file. If
you've never configured Gnome UI changes in NixOS before, follow these steps:

1. Get the latest settings and convert them to a Nix file:
   ```shell
   dconf dump / > ./assets/configs/gnome/dconf.settings
   
   # Or... (but it's quite buggy and breaks for me)
   dconf dump / | dconf2nix > ./assets/configs/gnome/dconf-raw.nix
   ```
2. Convert the settings to a Nix file:
   ```shell
   dconf2nix -i ./assets/configs/gnome/dconf.settings -o ./assets/configs/gnome/dconf-raw.nix
   ```
   If things break, which they usually do, follow the error messages and fix/remove the offending line(s).
3. Copy everything you need into a new file in the same directory named `dconf.nix` and make sure it's imported by
   `home.nix`. In case of errors, consider replacing `mkTuple` with `lib.hm.gvariant.mkTuple` and `mkUint32`
   with `lib.hm.gvariant.mkUint32` in `dconf.nix` or adding `with.lib.hm.gvariant` at the top of the file.

Check `systemctl status home-manager-$USER` and ensure the service started successfully, if not, dig in with
`journalctl -u home-manager-$USER` and make sure to carefully read the error.