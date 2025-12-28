{ config, pkgs, ... }:
{

services.adguardhome = {
  enable = true;
  openFirewall = true; # Automatically opens Port 53 (DNS) and 3000 (Web UI)
};

}
