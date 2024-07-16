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
        "cmake"
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
        "nerdfonts"
        "openssl_3_2"
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
        "ansible"
        "ansible-lint"
        "asciidoctor"
        "bun"
        "checksec"
        "devenv"
        "doctl"
        "emacs"
        "ffmpeg"
        "fish"
        "gh"
        "glab"
        "helix"
        "htop"
        "http-server"
        "httpie"
        "jq"
        "kitty"
        "macchina"
        "minio-client"
        "netcat-openbsd"
        "nmap"
        "nmap-formatter"
        "neovim"
        "obsidian"
        "terraform"
        "thc-hydra"
        "tmux"
        "yarn"
        "yq"
      ];

      langs = [
        "go"
        "lua"
        "luarocks"
        "maxima"
        "nodejs"
        "poetry"
        "python312"
        "racket"
        "ruby"
        "rustup"
        "sbcl"
        "scala"
        "solc"
        "zig"
      ];

      commonPackages = apps ++ langs ++ essentials;

      linuxPkgs = [
        "autotools-language-server"
        "calibre"
        "chromium"
        "ghdl"
        "koreader"
        "ngspice"
        "octaveFull"
        "qucs-s"
        "remmina"
        "shfmt"
        "signal-desktop"
        "vagrant"
      ] ++ commonPackages;

      darwinPkgs = [
        "alacritty"
        "rectangle"
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
