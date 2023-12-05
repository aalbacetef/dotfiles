

{
  description = "Core packages in use";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    flake-utils.url = "github:numtide/flake-utils";
  };
  

  outputs = { self, nixpkgs, ... }: 
    let 
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ]; 

      commonPackages = [
        "alacritty"
        "bash-completion"
        "coreutils-full"
        "fd"
        "ffmpeg"
        "fish"
        "fzf"
        "gdb"
        "git"
        "gh"
        "glab"
        "go"
        "graphviz"
        "grpc"
        "jq"
        "lua"
        "luarocks"
        "nasm"
        "neovim"
        "nodejs"
        "obsidian"
        "qemu"
        "podman"
        "python311"
        "ripgrep"
        "ruby"
        "shellcheck"
        "socat"
        "tmux"
        "tree"
        "universal-ctags"
        "vagrant"
        "zig"
      ]; 

      linuxPkgs = [] ++ commonPackages;
      
      darwinPkgs = [
        "skhd"
        "sketchybar" 
      ] ++ commonPackages;

    in {
       packages.x86_64-linux.default = let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
       in pkgs.buildEnv {
        name = "user-linux-packages";
        paths = (map (p: nixpkgs.legacyPackages.x86_64-linux.${p}) linuxPkgs);
       };
       
       packages.x86_64-darwin.default = let
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
       in pkgs.buildEnv {
        name = "user-darwin-packages";
        paths = (map (p: nixpkgs.legacyPackages.x86_64-darwin.${p}) darwinPkgs);
       };
    };
}
