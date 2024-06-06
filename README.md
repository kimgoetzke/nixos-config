# My NixOS configuration files

Private for now.

## Commands
#### Build

The first time on a system, use:

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

Clean up all, leaving only the most recent generation, with:
```shell
 nh clean --keep 3 --keep-since 2D --dry
```

Note that:
- `--keep 5` - At least keep 5 generations [default: 1]
- `--keep-since 4D` - At least keep gcroots and generations of the past 4 days [default: 0h]
- `all` instead of the above will do what it says