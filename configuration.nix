# configuration

{ pkgs, lib, ... }:

{
  imports = [
    #./hardware-configuration.nix
  ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of the /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

# Networking settings
networking = {
  hostName = "pi";

  # Optional: static IP on Ethernet if you still want it
  interfaces.end0 = {
    ipv4.addresses = [{ address = "192.168.1.42"; prefixLength = 24; }];
  };
  defaultGateway = { address = "192.168.1.1"; interface = "end0"; };
  nameservers = [ "192.168.1.1" "1.1.1.1" ];

  # This is the important part for Wi-Fi
  wireless = {
    enable = true;                                   # ← enables wpa_supplicant
    interfaces = [ "wlan0" ];
    networks = {
      "MySpectrumWiFi45-5" = {
        psk = "12345678";                 # plaintext PSK
        # pskRaw = "abcd…";                          # if you prefer the hashed version
        priority = 10;
      };
      # "GuestNetwork" = { psk = "..."; };
    };
  };
};

users.users.admin = {
  isNormalUser = true;
  extraGroups = [ "wheel" ]; #Enable sudo for the users
};

# Enable the OpenSSH daemon.
services.openssh.enable = true;

environment.systemPackages = with pkgs; [
  neovim
  git
  wget
];


# allows the use of flakes
#nix.package = pkgs.nixFlakes;
nix.extraOptions = ''
  keep-outputs = true
  keep-derivations = true
  experimental-features = nix-command flakes
'';

# this allows you to run `nixos-rebuild --target-host admin@this-machine` from a different host
#nix.settings.trusted.users = [ "admin" ];

programs.fish.enable = true;
environment.variables = {
  SHELL = "fish";
  EDITOR = "neovim";
};

}
