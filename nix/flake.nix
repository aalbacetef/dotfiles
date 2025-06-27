{
  description = "declarative package setup";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    roc.url = github:roc-lang/roc;
    nixgl.url = github:guibou/nixGL;
    pinnedRacketVersion.url = github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce;
    pinnedPodmanVersion.url = github:NixOS/nixpkgs/21808d22b1cda1898b71cf1a1beb524a97add2c4;
    pinnedNeovimVersion.url = github:NixOS/nixpkgs/84b8c066959156b1a1c408d73669592b3ab10a9c;
  };

  outputs = { self, nixpkgs, roc, nixgl, pinnedRacketVersion, pinnedPodmanVersion, pinnedNeovimVersion, ... }:
    let
      wrapWithNixGL = final: prev: {
        alacritty = final.writeShellScriptBin "alacritty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.alacritty}/bin/alacritty "$@"
        '';
        kitty = final.writeShellScriptBin "kitty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.kitty}/bin/kitty "$@"
        '';
      };

      pinnedRacket = final: prev: {
        racket = pinnedRacketVersion.legacyPackages.${prev.system}.racket;
      };

      pinnedPodman = final: prev: {
        podman = pinnedPodmanVersion.legacyPackages.${prev.system}.podman;
      };

      pinnedNeovim = final: prev: {
        neovim = pinnedNeovimVersion.legacyPackages.${prev.system}.neovim;
      };

      overlay_settings = {
        "x86_64-linux" = [ 
          wrapWithNixGL 
          pinnedNeovim
        ];
        "x86_64-darwin" = [
          pinnedRacket
          pinnedPodman
          pinnedNeovim
        ];
        "aarch64-darwin" = [
          pinnedRacket
          pinnedNeovim
        ];
      };

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = overlay_settings."${system}" or  [ ];
      };

      pkgsLinux = pkgsFor "x86_64-linux";
      pkgsDarwinX86 = pkgsFor "x86_64-darwin";
      pkgsDarwinArm = pkgsFor "aarch64-darwin";

      workPkgs = sysPkgs: (import ./work.nix { inherit sysPkgs; });

      essentials = sysPkgs: with sysPkgs; [
        bash-completion
        cmake
        curl
        coreutils-full
        fd
        fzf
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
        openssl_3_4
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
        tree-sitter
        tmux
        web-ext
        wrk
        yq

        ## solana dev environment 
        anchor
        solana-cli

        ## migrations tool
        goose

        ## AI
        aider-chat
      ];

      langs = sysPkgs: with sysPkgs; [
        ammonite
        dotnet-sdk_8
        elixir
        fnm
        fsharp
        go_1_24
        lua
        luarocks
        metals
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
        python313
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

      commonPackages = sysPkgs: 
        apps sysPkgs ++ 
        langs sysPkgs ++ 
        essentials sysPkgs ++ 
        workPkgs sysPkgs;

      linuxPkgs = with pkgsLinux; [
        aardvark-dns
        apostrophe
        autotools-language-server
        checksec
        chromium
        gdb
        ghdl
        ngspice
        octaveFull
        qucs-s
        remmina
        shfmt
        signal-desktop
        slirp4netns
        sysstat
        vagrant
      ] ++ commonPackages pkgsLinux;

      darwinPkgs = sysPkgs: with sysPkgs; [
        rectangle
        skhd
        texliveMedium
        texstudio
      ] ++ commonPackages sysPkgs;

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
          pkgs = pkgsDarwinX86;
          rocPkgs = roc.packages.x86_64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages";
          paths = darwinPkgs pkgsDarwinX86 ++ [ rocPkgs.cli ];
        };

      packages.aarch64-darwin.default =
        let
          pkgs = pkgsDarwinArm;
          rocPkgs = roc.packages.aarch64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages-arm";
          paths = darwinPkgs pkgsDarwinArm ++ [ rocPkgs.cli ];
        };

    };
}
