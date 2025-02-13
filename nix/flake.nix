{
  description = "declarative package setup";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    roc.url = github:roc-lang/roc;
    nixgl.url = github:guibou/nixGL;
  };


  outputs = { self, nixpkgs, roc, nixgl, ... }:
    let
      wrapWithNixGL = final: prev: {
        alacritty = final.writeShellScriptBin "alacritty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.alacritty}/bin/alacritty "$@"
        '';
        kitty = final.writeShellScriptBin "kitty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.kitty}/bin/kitty "$@"
        '';
      };

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = if system == "x86_64-linux" then [ wrapWithNixGL ] else [];
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
        go-toml
        graphviz
        grpc
        imagemagick
        libssh2
        nasm
        nerd-fonts._0xproto
        nerd-fonts.caskaydia-cove
        nerd-fonts.hack
        nerd-fonts.inconsolata
        nerd-fonts.roboto-mono
        nerd-fonts.ubuntu
        nerd-fonts.ubuntu-mono
        openssl_3_3
        podman
        podman-compose
        qemu
        ripgrep
        rsync
        shellcheck
        socat
        tree
        universal-ctags
        wabt
        wasmtime
        wget
      ];

      apps = sysPkgs: with sysPkgs; [
        alacritty
        ansible
        ansible-lint
        asciidoctor
        bun
        devenv
        doctl
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
        meld
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
        ammonite
        dotnet-sdk_8
        elixir
        fsharp
        go_1_23
        lua
        luarocks
        metals
        nodejs
        ocaml
        ocamlformat
        ocamlPackages.dune_3
        ocamlPackages.ocaml-lsp
        ocamlPackages.odoc
        ocamlPackages.reason
        ocamlPackages.utop
        opam
        poetry
        purescript
        python312
        racket
        ruby
        rustup
        sbcl
        sbt
        scala
        scalafmt
        solc
        zig
      ];

      commonPackages = sysPkgs: apps sysPkgs ++ langs sysPkgs ++ essentials sysPkgs;

      linuxPkgs = with pkgsLinux; [
        autotools-language-server
        checksec
        chromium
        ghdl
        ngspice
        octaveFull
        qucs-s
        remmina
        shfmt
        signal-desktop
        vagrant
      ] ++ commonPackages pkgsLinux;

      darwinPkgs = with pkgsDarwin; [
        ponyc
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
