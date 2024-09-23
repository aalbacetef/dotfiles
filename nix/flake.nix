{
  description = "declarative package setup";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    roc.url = github:roc-lang/roc;
  };


  outputs = { self, nixpkgs, roc, ... }:
    let
      pkgsFor = system: import nixpkgs {
        inherit system;
      };

      pkgsLinux = pkgsFor "x86_64-linux";
      pkgsDarwin = pkgsFor "x86_64-darwin";

      essentials = sysPkgs: with sysPkgs; [
        bash-completion
        cmake
        curl
        coreutils-full
        fd
        fzf
        gdb
        git
        gnumake
        gnuplot
        golangci-lint
        go-task
        go-toml
        graphviz
        grpc
        imagemagick
        libssh2
        nasm
        nerdfonts
        openssl_3_2
        podman
        qemu
        ripgrep
        shellcheck
        socat
        tree
        universal-ctags
        wasmtime
        wget
      ];

      apps = sysPkgs: with sysPkgs; [
        ansible
        ansible-lint
        asciidoctor
        bun
        devenv
        doctl
        emacs
        ffmpeg
        fish
        gh
        glab
        helix
        htop
        http-server
        httpie
        jq
        kitty
        macchina
        minio-client
        netcat
        nmap
        nmap-formatter
        neovim
        obsidian
        ranger
        terraform
        thc-hydra
        tmux
        yarn
        yq
      ];

      langs = sysPkgs: with sysPkgs; [
        elixir
        go_1_23
        lua
        luarocks
        maxima
        nodejs
        ocamlPackages.reason
        poetry
        python312
        racket
        ruby
        rustup
        sbcl
        scala
        solc
        zig
      ];

      commonPackages = sysPkgs: apps sysPkgs ++ langs sysPkgs ++ essentials sysPkgs;

      linuxPkgs = with pkgsLinux; [
        autotools-language-server
        calibre
        checksec
        chromium
        ghdl
        koreader
        ngspice
        octaveFull
        qucs-s
        remmina
        shfmt
        signal-desktop
        vagrant
      ] ++ commonPackages pkgsLinux;

      darwinPkgs = with pkgsDarwin; [
        alacritty
        rectangle
        skhd
        texliveMedium
        texstudio
      ] ++ commonPackages pkgsDarwin;

    in
    {
      packages.x86_64-linux.default =
        let
          pkgs = pkgsLinux;
          rocPkgs = roc.packages.x86_64-linux;
        in
        pkgs.buildEnv {
          name = "user-linux-packages";
          paths = linuxPkgs ++ [ rocPkgs.cli ];
        };

      packages.x86_64-darwin.default =
        let
          pkgs = pkgsDarwin;
          rocPkgs = roc.packages.x86_64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages";
          paths = darwinPkgs ++ [ rocPkgs.cli ];
        };
    };
}
