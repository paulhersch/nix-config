{ pkgs, ... }:

[(pkgs.python311.withPackages (p: with p; [
	pandas
	selenium
	seaborn
	python-lsp-server
	keyring
	tornado
	requests
	pynvim
	pygobject3
	beautifulsoup4
]))]
++ [ pkgs.gobject-introspection ]

