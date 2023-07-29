{ theme }:

# - family: Symbols Nerd Font
# Alacritty cant use fallback fonts,
# so until its happening st is best friend
with theme; ''
window:
  padding:
    x: 5
    y: 5
  dynamic_padding: true
  decorations: none
scrolling:
  history: 20000
  multiplier: 5
font:
  normal:
    - family: Iosevka Comfy Motion
  size: 9
  offset: 
    y: 2
  builtin_box_drawing: true
selection:
  save_to_clipboard: true
cursor:
  style:
    shape: beam
    blinking: on
  thickness: 0.1
ipc_socket: true
mouse:
  hide_when_typing: true
draw_bold_text_with_bright_colors: false
colors:
  primary:
    background: '#${bg}'
    foreground: '#${fg}'
  normal:
    black: '#${c0}'
    red: '#${c1}'
    green: '#${c2}'
    yellow: '#${c3}'
    blue: '#${c4}'
    magenta: '#${c5}'
    cyan: '#${c6}'
    white: '#${c7}'
  bright:
    black: '#${c8}'
    red: '#${c9}'
    green: '#${c10}'
    yellow: '#${c11}'
    blue: '#${c12}'
    magenta: '#${c13}'
    cyan: '#${c14}'
    white: '#${c15}'
''
