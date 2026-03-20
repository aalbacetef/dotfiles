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
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pinnedRacketVersion.url = github:NixOS/nixpkgs/05bbf675397d5366259409139039af8077d695ce;
    pinnedSolanaVersion.url = github:NixOS/nixpkgs/84b8c066959156b1a1c408d73669592b3ab10a9c;
    pinnedBWVersion.url = github:NixOS/nixpkgs/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73;
    pinnedGnomeExtVersion.url = github:NixOS/nixpkgs/6ef2b63f3929c62a1ec6a960234fe06940ce3b10;
    pinnedDXVersion.url = github:NixOS/nixpkgs/93e8cdce7afc64297cfec447c311470788131cd9;
    pinnedSeanimeVersion.url = github:NixOS/nixpkgs/e4bae1bd10c9c57b2cf517953ab70060a828ee6f;
  };

  outputs = { 
    self, 
    nixpkgs, roc, nixgl, ags, 
    dms, quickshell,
    pinnedRacketVersion, 
    pinnedSolanaVersion, 
    pinnedBWVersion, 
    pinnedGnomeExtVersion, 
    pinnedDXVersion,
    pinnedSeanimeVersion,
  ... }:
    let
      wrapWithNixGL = final: prev: {
        alacritty = final.writeShellScriptBin "alacritty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.alacritty}/bin/alacritty "$@"
        '';
        kitty = final.writeShellScriptBin "kitty" ''
          exec ${nixgl.packages.x86_64-linux.nixGLDefault}/bin/nixGL ${prev.kitty}/bin/kitty "$@"
        '';

        zed-editor = prev.zed-editor.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            # Wrap only the main binary (lowercase hyprland) with nixGL
            mv $out/bin/zed-editor $out/bin/zed-editor-unwrapped
            makeWrapper ${nixgl.packages.${final.system}.nixGLDefault}/bin/nixGL \
              $out/bin/zed-editor \
              --argv0 zed-editor \
              --add-flags $out/bin/zed-editor-unwrapped
          '';
        });

        obsidian = prev.obsidian.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            # Wrap only the main binary (lowercase hyprland) with nixGL
            mv $out/bin/obsidian $out/bin/obsidian-unwrapped
            makeWrapper ${nixgl.packages.${final.system}.nixGLDefault}/bin/nixGL \
              $out/bin/obsidian \
              --argv0 obsidian \
              --add-flags $out/bin/obsidian-unwrapped
          '';
        });

        ## hyprland package has a bunch of binaries but we only want to wrap the main one.
        hyprland = prev.hyprland.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            # Wrap only the main binary (lowercase hyprland) with nixGL
            mv $out/bin/hyprland $out/bin/hyprland-unwrapped
            makeWrapper ${nixgl.packages.${final.system}.nixGLDefault}/bin/nixGL \
              $out/bin/hyprland \
              --argv0 hyprland \
              --add-flags $out/bin/hyprland-unwrapped

            # All the other binaries (hyprctl, hyprpm, hyprpaper, etc.) stay untouched
          '';
        });

        ## niri needs gfx 
        niri = prev.niri.overrideAttrs (old: {
          buildInputs = (old.buildInputs or []) ++ [prev.makeWrapper];
          postInstall = (old.postInstall or "") + ''
            mv $out/bin/niri $out/bin/niri-unwrapped

            makeWrapper ${nixgl.packages.${final.system}.nixGLDefault}/bin/nixGL \
              $out/bin/niri \
              --argv0 niri \
              --add-flags $out/bin/niri-unwrapped
            
            mv $out/bin/niri-session $out/bin/niri-session-unwrapped
            makeWrapper ${nixgl.packages.${final.system}.nixGLDefault}/bin/nixGL \
              $out/bin/niri-session \
              --argv0 niri-session \
              --add-flags $out/bin/niri-session-unwrapped
          '';
        });
      };

      wrappedDocker = final: prev: {
        podman = prev.podman.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            ln -s $out/bin/podman $out/bin/docker
          '';
        });
      };

      pinnedRacket = final: prev: {
        racket = pinnedRacketVersion.legacyPackages.${prev.system}.racket;
      };

      pinnedSolana = final: prev: {
        solana-cli = pinnedSolanaVersion.legacyPackages.${prev.system}.solana-cli; 
      };

      pinnedBW = final: prev: {
        bitwarden-cli = pinnedBWVersion.legacyPackages.${prev.system}.bitwarden-cli;
      };

      pinnedSeanime = final: prev: {
        seanime = pinnedSeanimeVersion.legacyPackages.${prev.system}.seanime;
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

      pinnedDX = final: prev: {
        dotenvx = pinnedDXVersion.legacyPackages.${prev.system}.dotenvx;
      };


      noopOverlayARMDarwin = final: prev: {
        mangayomi = prev.runCommand "stubbed-package" {} ''
          mkdir $out
        '';
        vlc = prev.runCommand "stubbed-package" {} ''
          mkdir $out
        '';

        thc-hydra = prev.runCommand "stubbed-package" {} ''
          mkdir $out
        '';
      };

      overlay_settings = {
        "x86_64-linux" = [ 
          wrapWithNixGL 
          pinnedSolana
          pinnedGnomeExt
          pinnedDX
          pinnedSeanime
          wrappedDocker
        ];

        "x86_64-darwin" = [
          pinnedRacket
          pinnedSolana
          pinnedBW
        ];

        ## work mac 
        "aarch64-darwin" = [
          pinnedRacket
          pinnedSolana
          pinnedDX
          noopOverlayARMDarwin
        ];
      };

      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = overlay_settings."${system}" or  [ ];
      };

      pkgsLinux = pkgsFor "x86_64-linux";
      pkgsDarwinX86 = pkgsFor "x86_64-darwin";
      pkgsDarwinArm = pkgsFor "aarch64-darwin";

      workPkgs = sysPkgs: (
        import ./modules/work.nix { 
          inherit sysPkgs; 
        });

      essentials = sysPkgs: (
        import ./modules/essentials.nix {
          inherit sysPkgs;
        });

      langs =  sysPkgs: (
        import ./modules/langs.nix {
          inherit sysPkgs;
          inherit roc;
        });

      apps = sysPkgs: (
        import ./modules/apps.nix {
          inherit sysPkgs;
        });

      commonPackages = sysPkgs: 
        apps sysPkgs ++ 
        langs sysPkgs ++ 
        essentials sysPkgs;

      linuxPkgs = sysPkgs: (
        import ./modules/linux.nix {
          inherit sysPkgs; 
          inherit dms; 
          inherit quickshell;
        });

      darwinPkgs = sysPkgs: (
        import ./modules/darwin.nix { 
          inherit sysPkgs; 
        });

    in
    {
      packages.x86_64-linux.default =
        let
          pkgs = pkgsLinux;
        in
        pkgs.buildEnv {
          name = "user-linux-packages";
          paths = linuxPkgs pkgsLinux ++ commonPackages pkgsLinux;
        };

      packages.x86_64-darwin.default =
        let
          pkgs = pkgsDarwinX86;
          rocPkgs = roc.packages.x86_64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages";

          paths = darwinPkgs pkgsDarwinX86 ++ commonPackages pkgsDarwinX86 ;
        };

      packages.aarch64-darwin.default =
        let
          pkgs = pkgsDarwinArm;
          rocPkgs = roc.packages.aarch64-darwin;
        in
        pkgs.buildEnv {
          name = "user-darwin-packages-arm";
          paths = darwinPkgs pkgsDarwinArm ++ commonPackages pkgsDarwinArm ++ workPkgs pkgsDarwinArm ;
        };

    };
}
