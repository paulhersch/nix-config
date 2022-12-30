{ pkgs, ... }:

[(pkgs.old.python3.withPackages (p: with p; [
	python-lsp-server
	pygobject3
]))]
++ [ pkgs.gobject-introspection pkgs.pipenv ]

