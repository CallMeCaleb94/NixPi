{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    # This allows other machines on your network to use the Pi's LLM
    # Use "0.0.0.0" to listen on all interfaces
    host = "0.0.0.0";
    port = 11434;
    environmentVariables = {
    	# This allows both Chrome and Firefox extensions to talk to the Pi
    	OLLAMA_ORIGINS = "*";
	};
    # Optional: If you have a specific folder for models
    # models = "/var/lib/ollama/models";
  };

  # Open the port so you can talk to the Pi from your Main Host
  networking.firewall.allowedTCPPorts = [ 11434 ];

  # Useful tools for interacting with the model
  environment.systemPackages = with pkgs; [
    curl
    htop # Great for watching the Pi's CPU struggle (in a good way)
  ];
}
