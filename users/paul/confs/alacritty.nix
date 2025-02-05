{ theme }:

with theme; ''
  ipc_socket = true

  [env]
  WINIT_X11_SCALE_FACTOR = "1"

  [window.padding]
  x = 5
  y = 5

  [window]
  dynamic_padding = true
  decorations = "none"

  [scrolling]
  history = 20000
  multiplier = 5

  [font]
  size = 12
  builtin_box_drawing = true

  [font.normal]
  family = "Iosevka With Fallback"

  [selection]
  save_to_clipboard = true

  [cursor]
  thickness = 0.1

  [cursor.style]
  shape = "beam"
  blinking = "on"

  [mouse]
  hide_when_typing = true

  [colors]
  draw_bold_text_with_bright_colors = false

  [colors.primary]
  background = "#${bg}"
  foreground = "#${fg}"
  
  [colors.normal]
  black = "#${c0}"
  red = "#${c1}"
  green = "#${c2}"
  yellow = "#${c3}"
  blue = "#${c4}"
  magenta = "#${c5}"
  cyan = "#${c6}"
  white = "#${c7}"

  [colors.bright]
  black = "#${c8}"
  red = "#${c9}"
  green = "#${c10}"
  yellow = "#${c11}"
  blue = "#${c12}"
  magenta = "#${c13}"
  cyan = "#${c14}"
  white = "#${c15}"
''
