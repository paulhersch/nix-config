{ lib, config, ... }:
let
  # config.services.uni = lib.options.mkOption {};
  cfg = config.services.uni;
in
{
  imports = [
    ./jupyter.nix
  ];
  options = {
    services.uni.enable = lib.options.mkEnableOption "enable all modules";
  };
  config = lib.mkIf cfg.enable {
    # can we loop through attrs?
    services.uni.jupyter.enable = true;
  };
}
