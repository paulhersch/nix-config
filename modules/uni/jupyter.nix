{config, pkgs, lib, ...}:
with lib;
let
	cfg = config.services.uni.jupyter;
in {
	options = {
		services.uni.jupyter.enable = mkEnableOption "enables customized jupyterlab env";
	};
	config = mkIf cfg.enable {
		users.users = {
			paul.extraGroups = [ "jupyter" ];
			# https://github.com/NixOS/nixpkgs/issues/253830
			jupyter.group = "jupyter";
		};
		services.jupyter = {
			# force token to be used
			password = "''";
			port = 8888;
			enable = true;
			kernels = {
				python3 = let
					env = (pkgs.python3.withPackages (p: with p; [
						ipykernel
					]));
				in {
					displayName = "Python RNuVS";
					argv = [
						"${env.interpreter}"
						"-m"
						"ipykernel_launcher"
						"-f"
						"{connection_file}"
					];
					language = "python";
				};
			};
		};
		# (hack) make service not autostart
		systemd.services.jupyter.wantedBy = lib.mkForce [];
	};
}
