{
  description = "RaspberryPi 3 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {

    nixosConfigurations."pi" = nixpkgs.lib.nixosSystem {
      # 1. This MUST be the architecture of the machine running the build (your x86 laptop)
      system = "x86_64-linux";
      
      modules = [
        # 2. Cross-compilation settings wrapped in an attribute set { }
        {
          nixpkgs.buildPlatform = "x86_64-linux";
          nixpkgs.hostPlatform = "aarch64-linux";
        }
        
        # 3. Core image builder and hardware modules
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixos-hardware.nixosModules.raspberry-pi-3
        
        # 4. Your custom configurations
        ./configuration.nix
        ./hardware-configuration.nix
        
        # 5. Image overrides (Wrapped as a function to cleanly access 'pkgs')
        ({ pkgs, ... }: {
          boot.kernelPackages = pkgs.linuxPackages_rpi3;
          sdImage.compressImage = false;
        })
      ];
    };
    
  };
}
