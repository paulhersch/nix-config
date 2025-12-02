{ pkgs, ... }:

let
  # https://sthibaul.pages.freedesktop.org/pipewire/page_module_filter_chain.html
  # with an edit so that pw can find the encoder
  virtual-surround-conf = ''
    context.modules = [
    {   name = libpipewire-module-filter-chain
      args = {
        node.description = "Dolby Surround Sink"
          media.name       = "Dolby Surround Sink"
          filter.graph = {
            nodes = [
            {
              type  = builtin
                name  = mixer
                label = mixer
                control = { "Gain 1" = 0.5 "Gain 2" = 0.5 }
            }
            {
              type   = ladspa
              name   = enc
              plugin = ${pkgs.ladspaPlugins}/lib/ladspa/surround_encoder_1401.so
              label  = surroundEncoder
            }
            ]
              links = [
              { output = "mixer:Out" input = "enc:S" }
              ]
                inputs  = [ "enc:L" "enc:R" "enc:C" null "mixer:In 1" "mixer:In 2" ]
                outputs = [ "enc:Lt" "enc:Rt" ]
          }
        capture.props = {
          node.name      = "effect_input.dolby_surround"
            media.class    = Audio/Sink
            audio.channels = 6
            audio.position = [ FL FR FC LFE SL SR ]
        }
        playback.props = {
          node.name      = "effect_output.dolby_surround"
            node.passive   = true
            audio.channels = 2
            audio.position = [ FL FR ]
        }
      }
    }
    ]
  '';

in
{
  services.pulseaudio.enable = false;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
    configPackages = [
      (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/virtual-5.1.conf" virtual-surround-conf)
    ];
    extraLv2Packages = with pkgs; [
      swh_lv2
      lsp-plugins
    ];
  };
  security.rtkit.enable = true;
}
