# flake.nix

{
  description = "RaspberryPi 3 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: rec {

  # here goes other flake outputs, if you need them

    nixosConfigurations."pi" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          nixos-hardware.nixosModules.raspberry-pi-3
          ./configuration.nix
          {
            # Pi 3 overrides
            boot.kernelPackages= nixpkgs.legacyPackages.aarch64-linux.linuxPackages_rpi3;
            sdImage.compressImage = false;
          }
        ];
      };
    };
}
