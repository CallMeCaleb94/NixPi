{ config, pkgs, lib, ... }:
{

networking.nat = {
  enable = true;
  internalInterfaces = ["ve-+"];
  externalInterface = "wlan0";
  # Lazy IPv6 connectivity for the container
  enableIPv6 = true;
};

# Force the Host to allow traffic to the container subent
networking.firewall.trustedInterfaces = [ "ve-jelly" ];

containers.jelly = {
  autoStart = true;  # Automatically start the container at boot
  #privateNetwork = true;  # Isolate the container's network
  #hostAddress = "10.233.0.1";  # Host IP
  #localAddress = "10.233.0.2";  # Container IP
  extraFlags = [ "--bind=/home/cpb/Jelly/Jellyfin" ];
  # Configure the ports to be forwarded from container to host
  forwardPorts = [
    { containerPort = 8096; hostPort = 8096; }
    { containerPort = 8920; hostPort = 8920; }
   ];

  config = { config, pkgs, lib, ... }: {
    users.users.jellyfin = {
    isSystemUser = true;
    group = "jellyfin";
      extraGroups = [ "users" ];
      uid = 1000;
    };
    users.groups.jellyfin = {
      gid = 1000;
    };
    systemd.services.jellyfin.serviceConfig.User = lib.mkForce "jellyfin";
    # Inside the container
    system.stateVersion = "26.05";
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
          
    systemd.services.jellyfin.environment = {
      JELLYFIN_DATA_DIR = "/var/lib/jellyfin";
      JELLYFIN_CONFIG_DIR = "/etc/jellyfin";
    };
  };
  
  # Define the bind mounts correctly here
  bindMounts = {
    media = {
      mountPoint = "/mnt/media";  # Path inside the container
      hostPath = "/home/cpb/Jelly/Jellyfin/Shows-Movies";  # Host directory
      isReadOnly = true;  # Read-only mount
      };
      music = {
        hostPath = "/home/cpb/Jelly/Jellyfin/Music";
        mountPoint = "/mnt/music";
        isReadOnly = true;
      };
    };
  };

  # Opens correct firewall port
  networking.firewall.allowedTCPPorts = [ 8096 ];
}
