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