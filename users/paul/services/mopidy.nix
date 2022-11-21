{ pkgs, lib, config, ... }:

{
	home-manager.users.paul.services = {
		mopidy = {
			enable = true;
			extensionPackages = with pkgs; [
				mopidy-mpd
					mopidy-mpris
					mopidy-local
			];
			settings = {
				audio = {
					mixer_volume = 30;
				};

				mpd = {
					enabled = true;
					hostname = "127.0.0.1";
					port = 6600;
					max_connections = 20;
					connection_timeout = 60;
				};

				local = {
					enabled = true;
					media_dir = "/home/paul/Musik/Files/";
				};

				file = {
					media_dirs = [
						"/home/paul/Musik/Files/|Music"
					];
				};
				m3u = {
					enabled = true;
					playlists_dir = "/home/paul/Musik/Playlists/";
					base_dir = "/home/paul/Musik/Playlists/";
				};

				mpris = {
					enabled = true;
					bus_type = "session";
				};
			};
		};
	};
}
