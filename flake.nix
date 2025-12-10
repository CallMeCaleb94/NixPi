# flake.nix

{
  desciption = "RaspberryPi 3 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: rec {

  # here goes other flake outputs, if you need them

    nixosConfigurations."pi" = nixpkgs.lib.nixosSystem {
      system = "aarcg64-linux";
      modules = [
          ./configuration.nix
        ];
      };
    };
}
