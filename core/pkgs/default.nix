{ pkgs, config, ... }:
let
	media = import ./media.nix { pkgs = pkgs; };
	basic = import ./basic.nix { pkgs = pkgs; };
	guiutils = import ./guiutils.nix { pkgs = pkgs; };
	cliutils = import ./cliutils.nix { pkgs = pkgs; };
	pythonpackages = import ./python.nix { pkgs = pkgs; };

	# there is so much shit to set with xdg
	default_browser = "librewolf.desktop";
	image_viewer = "feh.desktop";
	video_viewer = "vlc.desktop";
in
{
	imports = [ ./fonts.nix ];
	environment.systemPackages = with pkgs; [
		pfetch
		mullvad-vpn
		#(pkgs.callPackage ../../pkgs/satk.nix {})
	]
	++ pythonpackages
	++ basic
	++ media
	++ guiutils
	++ cliutils;
	
	services.mullvad-vpn.enable = true;

	# set defaults
	xdg.mime.defaultApplications = {
		"application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
		"image/png" = image_viewer;
		"image/jpeg" = image_viewer;
		"image/jpg" = image_viewer;
		"image/svg+xml" = image_viewer;
		"x-scheme-handler/mailto" = "thunderbird.desktop";
		"message/rfc822" = "thunderbird.desktop";
		"x-scheme-handler/https" = default_browser;
		"x-scheme-handler/http" = default_browser;
		"x-scheme-handler/about" = default_browser;
		"x-scheme-handler/unknown" = default_browser;
		"text/html" = default_browser;
		"application/x-extension-htm" = default_browser;
		"application/x-extension-html" = default_browser;
		"application/x-extension-shtml" = default_browser;
		"application/xhtml+xml" = default_browser;
		"application/x-extension-xhtml" = default_browser;
		"application/x-extension-xht" = default_browser;
		"video/mp4" = video_viewer;
		"video/x-matroska" = video_viewer;
	};
}
