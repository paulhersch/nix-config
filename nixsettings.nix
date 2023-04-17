{ config, pkgs, ... }:

{
	nix = {
		settings = { #cachix 👍
			trusted-substituters = [
				"https://cache.nixos.org?priority=10"
				"https://cache.ngi0.nixos.org/"
				"https://nix-community.cachix.org?priority=5"
				"https://nixpkgs-wayland.cachix.org"
				"https://fortuneteller2k.cachix.org"
				"https://nix-gaming.cachix.org"
			];
			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
				"nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
				"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
				"cache.ngi0.nixos.org-1:KqH5CBLNSyX184S9BKZJo1LxrxJ9ltnY2uAs5c/f1MA="
				"nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
			];
			auto-optimise-store = true;
			experimental-features = [ "nix-command" "flakes" ];
		};
		extraOptions = ''
			keep-outputs = true
			keep-derivations = true
    		'';
	};
}
