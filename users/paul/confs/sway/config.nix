{ pkgs, theme, ... }:
let
	scrotscript = pkgs.writeShellScriptBin "grimslurp" ''
		NAME=$(date +%m-%d-%H%m%S)
		PICTURE_DIR=$(cat $HOME/.config/user-dirs.dirs | grep "XDG_PICTURES" | cut -d "\"" -f 2)

		if [ $1 -eq 1 ] 
		then
			${pkgs.grim}/bin/grim -t jpeg -g "$(${pkgs.slurp}/bin/slurp)" $PICTURE_DIR/Screenshots/$NAME.jpg
		else
			${pkgs.grim}/bin/grim -c -t jpeg $PICTURE_DIR/Screenshots/$NAME.jpg
		fi
	'';
	swaync_css = pkgs.writeText "style.css" (import ./swaync_style.css.nix { inherit theme; });
	swaync_conf = pkgs.writeText "conf.json" (import ./swaync_config.json.nix { inherit theme; inherit pkgs; });
in
with theme; ''
set $mod Mod1

set $left Left
set $down Down
set $up Up
set $right Right

# i am enabling the user service, so no pkgs ref here
set $term alacritty

set $menu "${pkgs.wofi}/bin/wofi --show drun,run"

xwayland enable

input "1267:12541:ELAN071A:00_04F3:30FD_Touchpad" {
    dwt enabled
    tap enabled
    natural_scroll disabled
    middle_emulation enabled
}

input  * {
    xkb_layout "de"
}

#settings for Desktop Monitor
output "HP Inc. HP 27xq CNK0311FR2" mode 2560x1440@144Hz adaptive_sync on

## bg TODO put this in the git repo
output "*" background ~/Bilder/Hintergrundbilder/pelicans.jpg fill

bindsym $mod+0 exec ${pkgs.wlogout}/bin/wlogout

bindsym XF86MonBrightnessUp exec ${pkgs.brightnessctl}/bin/brightnessctl s +5%
bindsym XF86MonBrightnessDown exec ${pkgs.brightnessctl}/bin/brightnessctl s 5%-

bindsym XF86AudioRaiseVolume exec ${pkgs.pamixer}/bin/pamixer -ui 5
bindsym XF86AudioLowerVolume exec ${pkgs.pamixer}/bin/pamixer -ud 5
bindsym XF86AudioMute exec ${pkgs.pamixer}/bin/pamixer --toggle-mute

bindsym XF86AudioPlay exec ${pkgs.playerctl}/bin/playerctl -i firefox play-pause
bindsym XF86AudioPrev exec ${pkgs.playerctl}/bin/playerctl-i firefox previous
bindsym XF86AudioNext exec ${pkgs.playerctl}/bin/playerctl-i firefox next

# screenshot via grim and slurp (no mod: normal, with mod: areaselect)
bindsym Print exec ${scrotscript}/bin/grimslurp 0
bindsym $mod+Print exec ${scrotscript}/bin/grimslurp 1

bindsym $mod+F3 exec ${pkgs.cinnamon.nemo}/bin/nemo
for_window [app_id="nemo"] floating enable

bindsym $mod+Return exec $term
bindsym $mod+Shift+q kill
bindsym $mod+d exec $menu

floating_modifier $mod normal

bindsym $mod+Shift+c reload

# Exit sway (logs you out of your Wayland session)
bindsym $mod+Shift+e exec ${pkgs.sway}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'

### Moving around: ###
# Move your focus around
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

# Move the focused window with the same, but add Shift
bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

### Workspaces: ###
set $switch_ws exec --no-startup-id ${pkgs.i3-wk-switch}/bin/i3-wk-switch
# Switch to workspace
bindsym $mod+1 $switch_ws 1
bindsym $mod+2 $switch_ws 2
bindsym $mod+3 $switch_ws 3
bindsym $mod+4 $switch_ws 4
bindsym $mod+5 $switch_ws 5
bindsym $mod+6 $switch_ws 6
bindsym $mod+7 $switch_ws 7
bindsym $mod+8 $switch_ws 8
bindsym $mod+9 $switch_ws 9
# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace number 1
bindsym $mod+Shift+2 move container to workspace number 2
bindsym $mod+Shift+3 move container to workspace number 3
bindsym $mod+Shift+4 move container to workspace number 4
bindsym $mod+Shift+5 move container to workspace number 5
bindsym $mod+Shift+6 move container to workspace number 6
bindsym $mod+Shift+7 move container to workspace number 7
bindsym $mod+Shift+8 move container to workspace number 8
bindsym $mod+Shift+9 move container to workspace number 9

### Layout stuff: ###
bindsym $mod+h splith
bindsym $mod+v splitv

# Make the current focus fullscreen
bindsym $mod+f fullscreen

# Toggle the current focus between tiling and floating mode
bindsym $mod+Shift+space floating toggle

# Swap focus between the tiling area and the floating area
bindsym $mod+space focus mode_toggle

# Scratchpad: #
bindsym $mod+Shift+Tab move scratchpad
bindsym $mod+Tab scratchpad show

### Resizing containers: ###

mode "resize" {
    bindsym $right resize shrink width 20px
    bindsym $up resize grow height 20px
    bindsym $down resize shrink height 20px
    bindsym $left resize grow width 20px

    bindsym Escape mode "default"
}
bindsym $mod+r mode "resize"

# class                 border  backgr. text     indicator child_border
client.focused          #${llbg} #${bg}  #${fg}   #${lbg}   #${lbg}
client.focused_inactive #${bg}  #${bg}  #${ddfg} #${bg}    #${bg}
client.unfocused        #${bg}  #${bg}  #${ddfg} #${bg}    #${bg}
client.urgent           #${c1}  #${bg}  #${fg}   #${c1}    #${c1}
client.placeholder      #${bg}  #${bg}  #${ddfg} #${bg}    #${bg}

client.background       #${bg}

### Visual Style: ###
gaps inner 9
default_border pixel 2

exec ${pkgs.unstable.swaynotificationcenter}/bin/swaync -s ${swaync_css} -c ${swaync_conf}
exec ${pkgs.autotiling-rs}/bin/autotiling-rs
exec ${pkgs.blueman}/bin/blueman-applet
exec_always ${pkgs.unstable.networkmanagerapplet}/bin/nm-applet --indicator
exec_always pkill gammastep; ${pkgs.gammastep}/bin/gammastep -O 4500
exec_always pkill waybar; ${pkgs.waybar}/bin/waybar -c ~/.config/sway/waybar/config -s ~/.config/sway/waybar/style.css

include /etc/sway/config.d/
''
