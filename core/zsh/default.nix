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

			bindkey '^[^H' backward-kill-word # CTRL + BSPC
			bindkey '^[5~' kill-word # CTRL + DEL
			bindkey '\e[1;5D' backward-word
			bindkey "\e[1;5C" forward-word
			bindkey '^H' backward-kill-word # st-compat
			bindkey '5~' kill-word # st compat
			bindkey '5D' backward-word # st compat
			bindkey '5C' forward-word # st compat
#
#	ALIASES & CUSTOM FUNCTIONS
#
			alias tree="${pkgs.eza}/bin/eza --tree"
			alias cl="clear"
			alias git-update="${pkgs.git}/bin/git fetch --recurse-submodules=no --progress --prune ''${1}"
			# useful for rootless docker, but that shit buggy af anyways
			alias dr="docker -H unix:///run/user/''${UID}/docker.sock"
			ntdate () {
				date --date="@$(( ($1 / 10000000) - 11644473600 ))"
			}
			
			texwithbiber () {
				lualatex "$1" && biber "$1" && lualatex "$1"
			}

			findnixpackage () {
				echo "/"$(readlink -e $(which "$1") | cut -d "/" -f 2,3,4)
			}
			
			calcunixpornyears () { 
				[ "$1" -ge 0 ] || exit
				if [ "$1" -gt 22 ]; then age="$(( ($1 - 22) * 5 + 26 ))"
				elif [ "$1" -gt 18 ]; then age="$(( ($1 - 18) * 2 + 18 ))"
				else age="$1" fi
				echo "$1 human years is $age unixporn years" 
			}

			${pkgs.fortune}/bin/fortune -s | ${pkgs.cowsay}/bin/cowsay -f eyes
			'';
		histFile = "$HOME/.zhistory";
		histSize = 2000;
	};
	users.defaultUserShell = pkgs.zsh;
	programs.starship = {
		enable = true;
		settings = {
			add_newline = true;
			continuation_prompt = "[󱞩 ](bright-black)";
			format = ''
$directory$git_branch$git_status$git_state$nix_shell$python$fill$cmd_duration
''${custom.isroot}$hostname$status '';
			nix_shell = {
				format = "[\\($state\\)]($style) ";
			};
			hostname = {
				format = "[on ](italic white)[$ssh_symbol$hostname]($style) ";
			};
			cmd_duration = {
				format = "[$duration]($style)";
				style = "bold italic yellow";
				min_time = 500;
			};
			status = {
				format = "$symbol ";
				symbol = "[Δ]($bold bright-red)";
				success_symbol = "[Δ]($bold bright-green)";
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
                read_only = " [-]";
			};
			git_branch = {
				format = "[on $branch]($style)";
			};

			git_status = {
				format = "[$ahead_behind]($style)";
				ahead = "⇡$\{count\}";
				behind = "⇣$\{count\}";
			};
			
			python = {
				format = "[\\($virtualenv\\)]($style) ";
			};

			custom.isroot = {
				command = "[ `id -u` = 0 ] && echo 'as root '";
				style = "bold red";
				when = true;
			};
		};
	};
}
