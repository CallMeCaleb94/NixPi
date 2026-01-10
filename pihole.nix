{ config, pkg, ... }:
{

# The core DNS engine
services.pihole-ftl = {
  enable = true;
  # Open the standard DNS port 53 on the firewall
  openFirewallDNS = true;
  settings = {
    dns = {
      listendingMode = "BIND";
      upstreams = [ 
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8" 
     ];
     CNAMEdeepInspect = "true";
    };
  };
  # Professional tip: Start with a simple blocklist to save RAM
  lists = [
    {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
      type = "block";
      enabled = true;
      description = "Steven Black's HOSTS";
    }
    {
      url = "https://big.oisd.nl";
      type = "block";
      enabled = true;
      description = "OISD Big - The Industry Standard";
    }
  ];
};

# The web dashboard (optional, but you probably want it)
services.pihole-web = {
  enable = true;
  # Use a port other than 80 if you have a media server running already
  ports = [ 8080 ]; 
};

networking.firewall.allowedTCPPorts = [ 8080 ];

}
