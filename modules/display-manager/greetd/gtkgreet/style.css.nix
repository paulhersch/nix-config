{ colors }:

''
* {
	all: unset;
}

@define-color dbg #${colors.dbg};
@define-color bg #${colors.bg};
@define-color lbg #${colors.lbg};
@define-color llbg #${colors.llbg};
@define-color fg #${colors.fg};

window {
        background-image: url("file:///etc/nixos/modules/display-manager/greetd/gtkgreet/bg.jpg");
        background-size: cover;
        background-position: center;
}

box#body {
        background-color: @dbg;
        padding: 40px;
        border-radius: 10px;
	border-width: 0 0 0 5px;
	border-style: solid;
	border-color: @lbg;
}

label {
        color: @fg;
}

entry {
	padding: 10px;
        border-radius: 10px;
        background-color: @bg;
        color: @fg;
	transition: background-color 0.3s;
}

entry:focus {
	background-color: @lbg;
}

.text-button {
	border-radius: 10px;
	padding: 10px;
        background-color: @bg;
        transition: background-color 0.5s;
}

.text-button:hover {
        background-color: @lbg;
}

combobox {
	border-radius: 10px;
	background-color: @bg;
}


combobox entry {
	border-radius: 10px 0 0 10px;
	transition: background-color 0.3s;
}

combobox button {
	padding: 10px;
	border-radius: 0 10px 10px 0;
	transition: background-color 0.3s;
}
combobox arrow {
	color: @fg;
}

button:hover {
	background-color: @lbg;
	padding: 10px;	
}

#gtk-combobox-popup-menu {
	background-color: @bg;
	border-radius: 5px;
}

window.popup menuitem {
	padding: 5px;
	margin: 5px;
	background-color: @bg;
	color: @fg;
	transition: background-color 0.3s;
	border-radius: 5px;
}
window.popup menuitem:hover { background-color: @lbg; }
''
