{
  inputs = {
    # Principle inputs (updated by `nix run .#update`)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-2311.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    home-manager-2311.inputs.nixpkgs.follows = "nixpkgs-2311";

    flake-parts.url = "github:hercules-ci/flake-parts";
    nixos-flake.url = "github:srid/nixos-flake";
  };

  outputs = inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];

      imports = [ inputs.nixos-flake.flakeModule ];

      flake =
        let
          # TODO: Change username
          myUserName = "john";
          mod = { 
            nixpkgs.hostPlatform = "x86_64-linux";
            imports = [
              # Your machine's configuration.nix goes here
              ({ pkgs, ... }: {
                # TODO: Put your /etc/nixos/hardware-configuration.nix here
                boot.loader.grub.device = "nodev";
                fileSystems."/" = { device = "/dev/disk/by-label/nixos"; fsType = "btrfs"; };
                users.users.${myUserName}.isNormalUser = true;
                system.stateVersion = "23.05";
              })
            ];
          };
        in
        {
          # Configurations for Linux (NixOS) machines
          # TODO: Change hostname from "example1" to something else.

          nixosConfigurations.example1 = self.nixos-flake.lib.mkLinuxSystem { inherit mod; };
          
          nixosConfigurations.example2 = self.nixos-flake.lib.mkLinuxSystem { 
            inherit mod; 
            nixpkgs = inputs.nixpkgs-2311; 
          };

          # home-manager configuration goes here.
          homeModules.default = { pkgs, ... }: {
            imports = [ ];
            programs.git.enable = true;
            programs.starship.enable = true;
            programs.bash.enable = true;
          };
        };
    };
}
