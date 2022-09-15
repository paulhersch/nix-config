{ theme }:

with theme; ''
local wezterm = require "wezterm"
return {
    font_shaper = "Harfbuzz",
    harfbuzz_features = { "kern", "liga", "clig", "calt" },
    font_size = 10.0,
    dpi = 96.0,
    default_cursor_style = 'BlinkingBar',
    animation_fps = 30,
    front_end = 'OpenGL',
    font = wezterm.font_with_fallback {
    	{ family = "Cascadia Code" }
    },
    font_rules = {
	{
            italic = true,
            intensity = "Half",
            font = wezterm.font_with_fallback {
                {
                    family = "Victor Mono",
                    italic = true,
                    weight = 'Regular'
                }
            }
        },
        {
            italic = true,
            intensity = "Normal",
            font = wezterm.font_with_fallback {
                {
                    family = "Victor Mono",
                    italic = true,
                    weight = 'Bold'
                }
            }
        },
	{
            italic = true,
	    intensity = "Bold",
            font = wezterm.font_with_fallback {
                {
                    family = "Victor Mono",
                    italic = true,
                    weight = 'Bold'
                }
            }
        }
    },
    hide_tab_bar_if_only_one_tab = true,
    check_for_updates = false,
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
