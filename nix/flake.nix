

{
  description = "Core packages in use";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
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
        "doctl"
        "fd"
        "ffmpeg"
        "fish"
        "fzf"
        "gdb"
        "git"
        "gh"
        "glab"
        "gnumake"
        "gnuplot"
        "go"
        "go-task"
        "go-toml"
        "graphviz"
        "grpc"
        "jq"
        "lua"
        "luarocks"
        "mc"
        "nasm"
        "neovim"
        "nodejs"
        "obsidian"
        "qemu"
        "podman"
        "poetry"
        "python311"
        "ripgrep"
        "ruby"
        "shellcheck"
        "socat"
        "terraform"
        "tmux"
        "tree"
        "universal-ctags"
        "yq"
        "zig"
      ]; 

      linuxPkgs = [] ++ commonPackages;
      
      darwinPkgs = [
        "fuse-ext2"
        "rectangle"
        "skhd"
        "sketchybar" 
        "texliveMedium"
        "texstudio"
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
