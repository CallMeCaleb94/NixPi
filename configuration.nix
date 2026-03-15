# configuration

{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    #./pihole.nix
    ./neovim.nix
    #./nginx.nix
    ./jelly.nix
    #./ollama.nix
    #./adguard.nix
  ];

  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];

  networking.networkmanager.wifi.powersave = false;

  boot.kernelParams = [ "brcmfmac.feature_disable=0x82000" ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of the /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

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


# Sets tmux to launch
 programs.fish.shellInit = ''
    if status is-interactive
      if not tmux info &>/dev/null
        if test -z "$TMUX"
          exec tmux
        end
      end
    end
  '';


# Enable the OpenSSH daemon.
services = {
  openssh.enable = true;
  tailscale.enable = true;
};

environment.systemPackages = with pkgs; [
  aria2
  neovim
  htop
  bottom
  git
  ifwifi
  nettools
  proton-vpn-cli
  python313Packages.aria2p
  ranger
  spotdl
  sshfs
  snitch
  tmux
  wget
  yt-dlp
];

nixpkgs.config.allowUnfree = true;

programs.mosh.enable = true;

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
    core = {
      editor = "${pkgs.neovim}/bin/nvim";
    };
  };
};
#
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

swapDevices = [ {
  device = "/var/lib/swapfile";
  size = 2048; # 2GB
  priority = 10; # Lower priority than zRAM (100)
} ];

programs.fish.enable = true;
environment.variables = {
  SHELL = "fish";
  EDITOR = "nvim";
  VISUAL = "nvim";
};

programs.neovim.defaultEditor = true;

system.stateVersion = "26.05";

}
