{
  description = "declarative package setup";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    roc.url = github:roc-lang/roc;
    nixgl.url = github:guibou/nixGL;
    ags = {
      url = github:aylur/ags;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pinnedRacketVersion.url = github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce;
    pinnedNeovimVersion.url = github:NixOS/nixpkgs/84b8c066959156b1a1c408d73669592b3ab10a9c;
    pinnedGCLVersion.url = github:NixOS/nixpkgs/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73;
    pinnedBWVersion.url = github:NixOS/nixpkgs/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73;
    pinnedGnomeExtVersion.url = github:NixOS/nixpkgs/6ef2b63f3929c62a1ec6a960234fe06940ce3b10;
  };

  outputs = { 
    self, 
    nixpkgs, roc, nixgl, ags, 
    pinnedRacketVersion, 
    pinnedNeovimVersion, 
    pinnedGCLVersion, 
    pinnedBWVersion, 
    pinnedGnomeExtVersion, 
  ... }:
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

      pinnedNeovim = final: prev: {
        neovim = pinnedNeovimVersion.legacyPackages.${prev.system}.neovim;
        solana-cli = pinnedNeovimVersion.legacyPackages.${prev.system}.solana-cli; 
      };

      pinnedGCL = final: prev: {
        golangci-lint = pinnedGCLVersion.legacyPackages.${prev.system}.golangci-lint;
      };

      pinnedBW = final: prev: {
        bitwarden-cli = pinnedBWVersion.legacyPackages.${prev.system}.bitwarden-cli;
      };

      pinnedGnomeExt = final: prev: {
        gnomeExtensions.caffeine = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.caffeine;
        gnomeExtensions.extension-list = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.extension-list;
        gnomeExtensions.just-perfection = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.just-perfection;
        gnomeExtensions.sound-output-device-chooser = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.sound-output-device-chooser;
        gnomeExtensions.todotxt = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.todotxt;
        gnomeExtensions.user-themes = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.user-themes;
        gnomeExtensions.vitals = pinnedGnomeExtVersion.legacyPackages.${prev.system}.gnomeExtensions.vitals;
      };

      overlay_settings = {
        "x86_64-linux" = [ 
          wrapWithNixGL 
          pinnedNeovim
          pinnedGnomeExt
        ];

        "x86_64-darwin" = [
          pinnedRacket
          pinnedNeovim
          pinnedBW
        ];

        ## work mac 
        "aarch64-darwin" = [
          pinnedRacket
          pinnedNeovim
          pinnedGCL
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
        openssl_3_6
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
        # devops and infra
        ansible
        ansible-lint
        doctl
        gh
        glab
        terraform

        # apps 
        brave
        emacs
        helix
        ladybird
        meld
        neovim
        obsidian
        octaveFull
        ranger
        vlc

        # general CLI tools
        alacritty
        asciidoctor
        bitwarden-cli
        btop
        bun
        devenv
        fish
        ffmpeg
        http-server
        httpie
        jq
        kitty
        macchina
        minio-client
        tmux
        tree-sitter
        yq

        ## network and security tools 
        netcat
        nmap
        nmap-formatter
        semgrep
        thc-hydra


        ## solana dev environment 
        anchor
        solana-cli

        ## dev tools
        air
        goose
        web-ext 
        wrk

        ## AI
        aider-chat
        gemini-cli
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
        purescript
        racket
        ruby
        rustup
        sbcl
        sbt
        scala
        scalafmt
        solc
        zig_0_14

        ## python
        poetry
        python313
        uv

        roc.packages.${system}.cli
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

        popcorntime
        transmission_4-gtk
        vagrant

        virter
        virt-manager

        ## gnome extensions 
        gnomeExtensions.caffeine
        gnomeExtensions.extension-list
        gnomeExtensions.just-perfection
        gnomeExtensions.sound-output-device-chooser
        gnomeExtensions.todotxt
        gnomeExtensions.user-themes
        gnomeExtensions.vitals

        ## gaming 
        lutris
        wine

        ## wm  
        # NOTE: requires the following installed via apt: sway, swaybg
        swayidle
        swayimg
        swaylock
        waybar
        wofi
        mako 
        nwg-launchers
        nwg-look
        blueman
        eww
        dracula-icon-theme
        ags.packages.${system}.agsFull
      ] ++ commonPackages pkgsLinux;

      darwinPkgs = sysPkgs: with sysPkgs; [
        gnused
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
          paths = linuxPkgs;
        };

      packages.x86_64-darwin.default =
        let
          pkgs = pkgsDarwinX86;
          rocPkgs = roc.packages.x86_64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages";
          paths = darwinPkgs pkgsDarwinX86;
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
