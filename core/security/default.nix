{ config, pkgs, ... }:

{
  imports = [
    #./firejail.nix
  ];
  security = {
    sudo.enable = false;
    apparmor = {
      enable = true;
    };
  };
  networking = {
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openconnect
        networkmanager-openvpn
      ];
    };
    firewall = {
      enable = true;
      #needed for kdeconnect
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
        # {
        #   from = 80;
        #   to = 80;
        # }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      # samba browsing
      extraCommands = "iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns";
    };
  };
  programs.ssh = {
    # askPassword = "${pkgs.ssh-askpass-fullscreen}/bin/ssh-askpass-fullscreen";
    enableAskPassword = false;
  };
  boot.initrd.services.udev.rules = ''
    KERNEL=="ttyUSB*", GROUP="dialout"
  '';
  # services.nginx = {
  #   enable = true;
  #   appendHttpConfig = ''
  #     server {
  #       listen 80;
  #       location / {
  #         proxy_pass http://192.168.122.249;
  #         proxy_set_header Host $host;
  #         proxy_set_header X-Real-IP $remote_addr;
  #       }
  #     }
  #   '';
  # };
}
