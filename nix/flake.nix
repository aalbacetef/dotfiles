{
  description = "declarative package setup";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
  };


  outputs = { self, nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      essentials = [
        "bash-completion"
        "curl"
        "coreutils-full"
        "deno"
        "fd"
        "fzf"
        "gdb"
        "git"
        "gnumake"
        "gnuplot"
        "golangci-lint"
        "go-task"
        "go-toml"
        "graphviz"
        "grpc"
        "imagemagick"
        "libssh2"
        "nasm"
        "openssl_3_1"
        "podman"
        "qemu"
        "ripgrep"
        "shellcheck"
        "socat"
        "tree"
        "universal-ctags"
        "wasmtime"
        "wget"
      ];

      apps = [
        "alacritty"
        "bun"
        "doctl"
        "emacs"
        "ffmpeg"
        "fish"
        "gh"
        "glab"
        "jq"
        "minio-client"
        "nmap"
        "nmap-formatter"
        "neovim"
        "obsidian"
        "terraform"
        "tmux"
        "yarn"
        "yq"
      ];

      langs = [
        "clojure"
        "go"
        "groovy"
        "lua"
        "luarocks"
        "maxima"
        "nodejs"
        "python311"
        "poetry"
        "racket"
        "ruby"
        "rustup"
        "sbcl"
        "zig"
      ];


      commonPackages = apps ++ langs ++ essentials;

      linuxPkgs = [
        "calibre"
        "ghdl"
        "koreader"
        "ngspice"
        "octaveFull"
        "qucs-s"
        "signal-desktop"
      ] ++ commonPackages;

      darwinPkgs = [
        "fontconfig"
        "fuse-ext2"
        "nerdfonts"
        "rectangle"
        "sketchybar"
        "skhd"
        "texliveMedium"
        "texstudio"
      ] ++ commonPackages;

    in
    {
      packages.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.buildEnv {
          name = "user-linux-packages";
          paths = (map (p: nixpkgs.legacyPackages.x86_64-linux.${p}) linuxPkgs);
        };

      packages.x86_64-darwin.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages";
          paths = (map (p: nixpkgs.legacyPackages.x86_64-darwin.${p}) darwinPkgs);
        };
    };
}
