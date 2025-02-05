{ pkgs, config, ... }:

{
  systemd.user.services."syncthing" = {
    description = "Syncthing daemon";
    documentation = [ "man:syncthing" ];
    serviceConfig = {
      ExecStart = "${pkgs.syncthing}/bin/syncthing serve --no-browser --no-restart --logflags=0";
      Restart = "on-failure";
      RestartSec = 1;
      SuccessExitStatus = "3 4";
      RestartForceExitStatus = "3 4";
      MemoryDenyWriteExecute = "true";
    };
  };
}
