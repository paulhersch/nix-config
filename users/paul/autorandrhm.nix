{ ... }: {
  enable = true;
  profiles = {
    "single-desktop" = {
      fingerprint = {
        DP-2 = "00ffffffffffff00220e8235000000001f1e0104a53c22783b8ce5a55850a0230b5054a54b00d1c0a9c081c0d100b30095008100a940565e00a0a0a029503020350055502100001a000000fd003090dfdf3c010a202020202020000000fc00485020323778710a2020202020000000ff00434e4b303331314652320a202001f0020316f149101f041303120211012309070783010000023a801871382d40582c450055502100001e023a80d072382d40102c458055502100001ee8e40050a0a067500820980455502100001a87bc0050a0a055500820780055502100001a4c6b0050a0a030500820280855502100001a000000000000000000000000000000b1";
      };
      config = {
        HDMI-0.enable = false;
        DP-0.enable = false;
        DP-1.enable = false;
        DP-2 = {
          enable = true;
          crtc = 0;
          primary = true;
          position = "0x0";
          mode = "2560x1440";
          rate = "143.86";
        };
        DP-3.enable = false;
        DP-4.enable = false;
        DP-5.enable = false;
      };
    };
  };
}
