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
  hostName = "NixPi";

  # Optional: static IP on Ethernet if you still want it
  #interfaces.end0 = {
  #  ipv4.addresses = [{ address = "192.168.1.42"; prefixLength = 24; }];
  #};
  #defaultGateway = { address = "192.168.1.1"; interface = "end0"; };
  #nameservers = [ "192.168.1.1" "1.1.1.1" ];

  networkmanager.enable = true;
};

networking.firewall.allowedTCPPorts = [ 80 22 443 ];
networking.firewall.allowedUDPPorts = [ 80 22 3389 41641 ];
# Optionally allow SSH access through your Tailscale interface
networking.firewall.trustedInterfaces = [ "tailscale0" ];

users.users.cpb = {
  isNormalUser = true;
  extraGroups = [ "wheel" "networkmanager" ];
  hashedPassword = "$6$keqmQFnFW26JFUXG$Dl3i6zk4NuSiD3gPuD3PFW1ZMX7ihRMw0t0C.MOirIf3v8wDRGIJ4getcAs1C3l1Mo.lZ/bmf8QYQSrE37bzK0";
  shell = "${pkgs.fish}/bin/fish";
};

# Enable the OpenSSH daemon.
services = {
  openssh.enable = true;
  tailscale.enable = true;
};

environment.systemPackages = with pkgs; [
  neovim
  htop
  bottom
  git
  ifwifi
  wget
];

nixpkgs.config.allowUnfree = true;

programs.git = {
  enable = true;
  package = pkgs.git;
  config = {
    user = {
      name = "CallMeCaleb94";
      email = "calebcodes94@gmail.com";
    };
    init = {
    defaultBranch = "main";
    };
  };
};

# allows the use of flakes
#nix.package = pkgs.nixFlakes;
nix.extraOptions = ''
  keep-outputs = true
  keep-derivations = true
  experimental-features = nix-command flakes
'';

zramSwap = {
  enable = true;
  priority = 100;
  memoryPercent = 50;
  algorithm = "zstd";
  swapDevices = 2;
};

programs.fish.enable = true;
environment.variables = {
  SHELL = "fish";
  EDITOR = "neovim";
};

system.stateVersion = "26.05";

}
