{ config, pkgs, ... }:

{
  nix = {
    settings = {
      #cachix 👍
      substituters = [
        "http://snowstorm:5000?priority=1"
        "http://snowfox:5000?priority=1"
        "https://cache.nixos.org?priority=10"
        "https://fortuneteller2k.cachix.org?priority=5"
        "https://nix-community.cachix.org?priority=5"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "snowstorm:ai98h/+fZl/sz0cYvcNoK96X85ZSMi1F+sfxH+Ro//8="
        "snowfox:ci2gA3ujc4niAJ7iix5zlYYJHlBrV0VraI4Wy/OXIDg="
      ];
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "paul" ];
    };
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    # keep-derivations = true
    extraOptions = ''
      keep-outputs = true
    '';
  };
  services.angrr = {
    enable = true;
    # enableNixGcIntegration = true;
    settings = {
      temporary-root-policies = {
        direnv = {
          path-regex = "/\\.direnv/";
          period = "30d";
        };
        result = {
          path-regex = "/result[^/]*$";
          period = "7d";
        };
        # You can define your own policies
        # ...
      };
      profile-policies = {
        system = {
          profile-paths = [ "/nix/var/nix/profiles/system" ];
          keep-since = "14d";
          keep-latest-n = 5;
          keep-booted-system = true;
          keep-current-system = true;
        };
        user = {
          enable = false; # Policies can be individually disabled
          profile-paths = [
            # `~` at the beginning will be expanded to the home directory of each discovered user
            "~/.local/state/nix/profiles/profile"
            "/nix/var/nix/profiles/per-user/root/profile"
          ];
          keep-since = "1d";
          keep-latest-n = 1;
        };
      };
    };
  };
}
