{ pkgs, theme }:

''
{
  "$schema": "/etc/xdg/swaync/configSchema.json",
  "positionX": "right",
  "positionY": "top",
  "control-center-margin-top": 10,
  "control-center-margin-bottom": 0,
  "control-center-margin-right": 10,
  "control-center-margin-left": 0,
  "notification-icon-size": 64,
  "notification-body-image-height": 100,
  "notification-body-image-width": 200,
  "timeout": 10,
  "timeout-low": 5,
  "timeout-critical": 0,
  "fit-to-screen": false,
  "control-center-width": 500,
  "control-center-height": 1028,
  "notification-window-width": 500,
  "keyboard-shortcuts": true,
  "image-visibility": "when-available",
  "transition-time": 200,
  "hide-on-clear": false,
  "hide-on-action": true,
  "script-fail-notify": true,
  "notification-visibility": {
    "spotify-name": {
      "state": "disabled",
      "urgency": "Low",
      "app-name": "Spotify"
    }
  },
  "widgets": [
    "menubar",
    //"buttons-grid",
    "volume",
    "backlight",
    "mpris",
    "title",
    "dnd",
    "notifications"
  ],
  "widget-config": {
    "title": {
      "text": "Notifications",
      "clear-all-button": true,
      "button-text": "Clear All"
    },
    "dnd": {
      "text": "Do Not Disturb"
    },
    "label": {
      "max-lines": 1,
      "text": "Control Center"
    },
    "mpris": {
      "image-size": 100,
      "image-radius": 5
    },
    "volume": {
      "label": ""
    },
    "backlight": {
      "label": ""
    },
    "menubar": {
      "menu#power": {
        "label": "  Power Menu",
        "position": "left",
        "actions": [
          {
            "label": " Lock",
            "command": "swaylock -c ${theme.bg}"
          },
          {
            "label": "󰗽 Logout",
            "command": "${pkgs.sway}/bin/swaymsg exit"
          },
          {
            "label": " Suspend",
            "command": "systemctl suspend"
          },
          {
            "label": " Reboot",
            "command": "systemctl reboot"
          },
          {
            "label": " Shutdown",
            "command": "systemctl poweroff"
          }
        ]
      }
    },
    //"buttons-grid": {
    //  "actions": [
    //    {
    //       "label": "",
    //       "command": "${pkgs.pamixer}/bin/pamixer -t"
    //     },
    //     {
    //       "label": "",
    //       "command": "${pkgs.pamixer}/bin/pamixer --default-source -t"
    //     },
    //     {
    //       "label": "",
    //       "command": "${pkgs.networkmanagerapplet}/bin/nm-connection-editor"
    //     }
    //  ]
    //}
  }
}

''
