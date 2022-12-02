{ config, lib, pkgs, ... }:
{
	# zsh globally
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		enableBashCompletion = true;
		autosuggestions = {
			enable = true;
			async = true;
		};
		syntaxHighlighting = {
			enable = true;
		};
		interactiveShellInit = ''
export PATH=$PATH:$HOME/.cargo/bin/:$HOME/.local/bin

autoload -U colors zcalc

source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh

zle -N history-substring-search-up
zle -N history-substring-search-down

setopt correct
setopt nocaseglob
setopt nobeep
setopt appendhistory
setopt histignorealldups
setopt autocd

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' cache-path $HOME/.cache/zsh
zstyle ':completion:*' accept-exact '*(N)'
WORDCHARS=''${a-zA-Z0-9}

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

#
# 	BINDS
#

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^H' backward-kill-word # CTRL + BSPC
bindkey '5~' kill-word # CTRL + DEL
bindkey '5D' backward-word #st compat
bindkey '5C' forward-word #st compat
bindkey ';5D' backward-word
bindkey ';5C' forward-word

#
#	ALIASES & CUSTOM FUNCTIONS
#

alias ls="exa"
alias tree="exa --tree"
alias cl="clear"
alias git-update="git fetch --recurse-submodules=no --progress --prune ''${1}"
alias dr="docker -H unix:///run/user/''${UID}/docker.sock"

texwithbiber () {
    lualatex "$1" && biber "$1" && lualatex "$1"
}

findnixpackage () {
	echo "/"$(ls -la $(which "$1") | cut -d ">" -f 2 | cut -d "/" -f 2,3,4)
}

fortune -s | cowsay -f eyes
		'';
		histFile = "$HOME/.zhistory";
		histSize = 2000;
	};
	environment.shells = with pkgs; [ zsh ];

	# starship prompt
	programs.starship = {
		enable = true;
		settings = {
			add_newline = true;
			continuation_prompt = "[󱞩 ](bright-black)";
			format = ''
$status$directory$git_branch$git_state $git_status$fill$cmd_duration
''${custom.isroot}[❯ ](purple)'';

			cmd_duration = {
				format = "[$duration]($style)";
				style = "bold italic yellow";
				min_time = 500;
			};
			status = {
				format = "$symbol ";
				symbol = "[▪]($bold red)";
				success_symbol = "[▪]($bold green)";
				disabled = false;
				pipestatus = true;
				pipestatus_separator = "";
				pipestatus_format = "$pipestatus";
			};
			fill = {
				style = "";
				symbol = " ";
			};
			directory = {
				style = "bold italic blue";
				read_only_style = "bold red";
				home_symbol = "~";
				truncation_length = 5;
				truncation_symbol = "../";
			};
			git_branch = {
				format = "on [$symbol$branch]($style)";
			};

			git_status = {
				format = "[$ahead_behind]($style)";
				ahead = "⇡$\{count\}";
				behind = "⇣$\{count\}";
			};

			custom.isroot = {
				command = "[ `id -u` = 0 ] && echo 'as root '";
				style = "bold red";
				when = true;
			};
		};
	};
}
