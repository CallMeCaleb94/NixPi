{ config, pkgs, ... }:
{

environment.systemPackages = with pkgs; [ nginx ];

services.nginx = {
  enable = true;
  recommendedProxySettings = true;
  recommendedTlsSettings = true;
  
  virtualHosts."jellyfin.me" = {
    default = true;  
    # If you have a real domain, put it here. Otherwise, use .local
    extraConfig = ''
      client_max_body_size 20M; # Allows large metadata/poster uploads
    '';
    locations."/" = {
      proxyPass = "http://10.233.0.2:8096"; # Your container's internal IP
      proxyWebsockets = true; # Critical for the remote control features
    };
  };
};

# Open the standard web ports on your Pi's firewall
networking.firewall.allowedTCPPorts = [ 80 443 ];

services.avahi = {
  enable = true;
  nssmdns4 = true;
  publish = {
    enable = true;
    addresses = true;
    workstation = true;
    userServices = true;
  };
  extraServiceFiles.jellyfin = ''
    <?xml version="1.0" standalone='no'?>
    <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
    <service-group>
      <name replace-wildcards="yes">jellyfin</name>
      <service>
        <type>_http._tcp</type>
        <port>80</port>
      </service>
    </service-group>
  '';
};

}
