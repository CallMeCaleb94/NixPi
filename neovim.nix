{ config, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
	alejandra # Opinionated Nix Formatter
	black #Python Formatter
	bottom
	clang
	cmake
	gcc
	gdb
	gdu
	gitFull
	lazygit
	lua-language-server
	neovim
	nil # Nix LSP
	nixd
	ninja
	nodejs-slim_24
	python314
	pyright # Python
	ripgrep
	tmux
	typescript-language-server
	valgrind
	vscode-langservers-extracted #HTML/CSS/JSON/ESLint
	wl-clipboard
	xclip
];

}
