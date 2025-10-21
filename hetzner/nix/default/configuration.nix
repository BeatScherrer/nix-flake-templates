{
  nixpkgs,
  modulesPath,
  pkgs,
  config,
  ...
}:

{

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # TODO:
  ];

  networking = {
    hostName = "hetzner";
    useNetworkd = true;
    # common firewall configs
    # firewall = {
    #   enable = true;
    #   allowedTCPPorts = [
    #     80 # HTTP
    #     443 # SSL
    #     5432 # PostgreSQL
    #   ];
    #   allowedUDPPorts = [
    #     53 # DNS
    #   ];
    # };
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      address = [
        "TODO" # Define your IPv6 address here
      ];
      routes = [
        { Gateway = "fe80::1"; }
      ];
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "TODO"; # change this to your email address
  };

  services.openssh.enable = true;
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "TODO"
      ];
    };
    user = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
      openssh.authorizedKeys.keys = [
        "TODO"
      ];
    };
  };

  # Reverse proxy for HTTPS/TLS
  # Caddy reverse proxy
  # services.caddy = {
  #   enable = true;
  #   virtualHosts."TODO" = {
  #     # change this to your domain
  #     extraConfig = ''
  #       reverse_proxy localhost:5678
  #
  #       # Security headers
  #       header {
  #         Strict-Transport-Security "max-age=31536000; includeSubDomains"
  #         X-Frame-Options "DENY"
  #         X-Content-Type-Options "nosniff"
  #         X-XSS-Protection "1; mode=block"
  #         Referrer-Policy "strict-origin-when-cross-origin"
  #       }
  #
  #       # Compression
  #       encode gzip
  #
  #       # Handle WebSocket connections for real-time updates
  #       @websockets {
  #         header Connection *Upgrade*
  #         header Upgrade websocket
  #       }
  #       reverse_proxy @websockets localhost:5678
  #     '';
  #   };
  # };

  system.stateVersion = "25.11";
}
