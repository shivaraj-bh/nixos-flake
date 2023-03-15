# nixos-template

WIP: Extracting common stuff out of https://github.com/srid/nixos-config

## Module

The `flakeModule` (flake-parts module) contains the following:

| Name                         | Description                                    |
| ---------------------------- | ---------------------------------------------- |
| `lib`                        | Functions `mkLinuxSystem` and `mkDarwinSystem` |
| `packages.update`            | Flake app to update key inputs                 |
| `packages.activate`          | Flake app to build & activate the system       |
| `nixosModules.home-manager`  | Home-manager setup module for NixOS            |
| `darwinModules.home-manager` | Home-manager setup module for Darwin           |

In addition, all modules implicitly receive the following `specialArgs`:

- `flake@{inputs, config}` (corresponding to flake-parts' arguments)
- `system` (the system type, e.g. `x86_64-linux`)
- `rosettaPkgs` (if on darwin)