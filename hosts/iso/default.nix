{ pkgs
, lib
, ...
}:


let
  cli = import ./../../core/pkgs/cliutils.nix { inherit pkgs; };
in
{
  imports = [
    ./../../core/zsh/default.nix
    ./../../core/pkgs/fonts.nix
  ];

  isoImage.edition = lib.mkDefault "paul-sway";

  services.displayManager.autoLogin = {
    enable = true;
    user = "nixos";
  };

  services.xserver.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures = { base = true; gtk = true; };
    extraOptions = [
      "--unsupported-gpu" # in case of nvidia gpu
    ];
  };

  environment.systemPackages = cli ++ (with pkgs; [
    wmenu
    foot
    neovim
  ]);

  # TODO: basic neovim setup with my colors in here?
}
