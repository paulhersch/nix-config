{ theme }:

with theme;
''
  local wezterm = require "wezterm"
  return {
      font_shaper = "Harfbuzz",
      -- harfbuzz_features = { "dlig" }, --, "liga", "clig", "ss01", "ss02", "ss19" },
      font_size = 11.0,
      dpi = 96.0,
      default_cursor_style = 'SteadyBar',
      front_end = 'OpenGL',
      font = wezterm.font_with_fallback {
      	'Iosevka Comfy Motion',
  	'all-the-icons',
      },
      hide_tab_bar_if_only_one_tab = true,
      warn_about_missing_glyphs = false,
      check_for_updates = false,
      bold_brightens_ansi_colors = false,
      colors = {
  	background = '#${bg}',
  	foreground = '#${fg}',
  	cursor_bg = '#${fg}',
  	cursor_fg = '#${bg}',
  	cursor_border = '#${fg}',
  	selection_bg = '#${lbg}',
  	selection_fg = '#${fg}',
  	scrollbar_thumb = '#${lbg}',
  	ansi = {
  	    '#${c0}',
  	    '#${c1}',
  	    '#${c2}',
  	    '#${c3}',
  	    '#${c4}',
  	    '#${c5}',
  	    '#${c6}',
  	    '#${c7}',
  	},
  	brights = {
  	    '#${c8}',
  	    '#${c9}',
  	    '#${c10}',
  	    '#${c11}',
  	    '#${c12}',
  	    '#${c13}',
  	    '#${c14}',
  	    '#${c15}',
  	},
      	tab_bar = {
  	    background = "#${lbg}",
  	    active_tab = {
  		bg_color = "#${bg}",
  	    	fg_color = "#${c4}",
  	    	intensity = "Bold"
  	    },
  	    inactive_tab = {
  		bg_color = "#${lbg}",
  		fg_color = "#${fg}",
  	    },
  	    inactive_tab_hover = {
  		bg_color = "#${bg}",
  		fg_color = "#${fg}",
  	    }
  	}
      }
  }
''
