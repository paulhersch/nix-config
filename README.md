# My NixOS configuration
This repo contains all the files needed to replicate my NixOS setup. nothing special, just a backup repo for myself.

## Installation
if you want to try out my config for some reason you would have to add the channels (as root):

```
nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
```
and then let nix check for your hardware, clone this repo and rebuild, which will take some time (config is estimated by nix to download around 17GB of data for a full install without cached packages).

After that you will have a fully functioning system install.
