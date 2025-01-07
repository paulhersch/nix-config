{ config, pkgs, ... }:

{
	nix = {
		settings = { #cachix 👍
			substituters = [
				"https://cache.nixos.org?priority=10"
				"https://cache.ngi0.nixos.org/"
				# "https://nixpkgs-wayland.cachix.org"
				"https://fortuneteller2k.cachix.org"
                "https://cuda-maintainers.cachix.org"
			];
			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
				"cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
                "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
				# "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
			];
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
            trusted-users = [ "paul" ];
		};
        gc = {
            automatic = true;
            dates = "weekly";
        };
		extraOptions = ''
			keep-outputs = true
			keep-derivations = true
    		'';
	};
}
