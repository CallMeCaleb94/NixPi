{
  description = "RaspberryPi 3 Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {

    nixosConfigurations."Nixpi" = nixpkgs.lib.nixosSystem {
      # 1. This MUST be the architecture of the machine running the build (your x86 laptop)
      system = "x86_64-linux";
      
      modules = [

        {
          nixpkgs.buildPlatform.system = "x86_64-linux";
          nixpkgs.hostPlatform.system = "aarch64-linux";
        }
        
        # 2. Core image builder and hardware modules
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        nixos-hardware.nixosModules.raspberry-pi-3
        
        # 3. Your custom configurations
        ./configuration.nix
        ./hardware-configuration.nix
        
        # 4. Image overrides (Wrapped as a function to cleanly access 'pkgs')
        ({ pkgs, lib, ... }: {
          hardware.raspberry-pi.firmware.uboot.enable = true;
          boot.supportedFilesystems.zfs = lib.mkForce false;
          boot.kernelPackages = pkgs.linuxPackages;
          sdImage.compressImage = false;
        })
      ];
    };
    
  };
}
