  { sysPkgs }:
with sysPkgs;

  let 
    isLinux = builtins.match "x86_64-linux" system != null;

    gdk = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components; [
      gke-gcloud-auth-plugin
    ]);

    workPkgs = [
      go-ethereum
      golangci-lint
      go-task
      kubectl
      kustomize
      krew
      sqlc
      dotenvx

      ## additional
      _1password-cli
      google-cloud-sql-proxy
      foundry
      gdk

      ## needed for builds
      protobuf
      protoc-gen-go

      ## helper for dev work
      watch

      ## new task runner 
      just
    ];

    dlv = pkgs.buildGoModule rec {
      pname = "dlv";
      version = "1.24.2";
      src = pkgs.fetchFromGitHub {
        owner = "go-delve";
        repo = "delve";
        rev = "v${version}";
        hash = "sha256-BFezzZpkF88xYsOcn3pI2zsH+OTRLvuwqa3CaU9Fk44=";
      };
      vendorHash = null;
      subPackages = [ "cmd/dlv" ];
      go = pkgs.go_1_24;
      doCheck = false;
    };

    gofumpt = pkgs.buildGoModule rec {
      pname = "gofumpt";
      version = "0.8.0";
      src = pkgs.fetchFromGitHub {
        owner = "mvdan";
        repo = "gofumpt";
        rev = "v${version}";
        hash = "sha256-37wYYB0k8mhQq30y1oo77qW3bIqqN/K/NG1RgxK6dyI=";
      };
      vendorHash = "sha256-T6/xEXv8+io3XwQ2keacpYYIdTnYhTTUCojf62tTwbA=";
      go = pkgs.go_1_24;
      doCheck = false;
    };

    golines = pkgs.buildGoModule rec {
      pname = "golines";
      version = "0.12.2";
      src = pkgs.fetchFromGitHub {
        owner = "segmentio";
        repo = "golines";
        rev = "v${version}";
        hash = "sha256-D0gI9BA0vgM1DBqwolNTfPsTCWuOGrcu5gAVFEdyVGg=";
      };
      vendorHash = "sha256-jI3/m1UdZMKrS3H9jPhcVAUCjc1G/ejzHi9SCTy24ak=";
      go = pkgs.go_1_24;
      doCheck = false;
    };

    gotestsum = pkgs.buildGoModule rec {
      pname = "gotestsum";
      version = "1.12.2";
      src = pkgs.fetchFromGitHub {
        owner = "gotestyourself";
        repo = "gotestsum";
        rev = "v${version}";
        hash = "sha256-l4K+8J24egaKS64inQrBWnPLLGBu1W03OUi4WWQoAgs=";
      };
      vendorHash = "sha256-SJacdFAdMiKDGLnEEBKnblvHglIBIKf2N20EOFCPs88=";
      go = pkgs.go_1_24;
      doCheck = false;
    };

    mockgen = pkgs.buildGoModule rec {
      pname = "mockgen";
      version = "1.6.0";
      src = pkgs.fetchFromGitHub {
        owner = "golang";
        repo = "mock";
        rev = "v${version}";
        hash = "sha256-5Kp7oTmd8kqUN+rzm9cLqp9nb3jZdQyltGGQDiRSWcE=";
      };
      vendorHash = "sha256-5gkrn+OxbNN8J1lbgbxM8jACtKA7t07sbfJ7gVJWpJM=";
      subPackages = [ "mockgen" ];
      go = pkgs.go_1_24;
      doCheck = false;
    };

    hugo = pkgs.buildGoModule rec {
      pname = "hugo";
      version = "0.130.0";
      src = pkgs.fetchFromGitHub {
        owner = "gohugoio";
        repo = "hugo";
        rev = "v${version}";
        hash = "sha256-ZZYItkQI9qxQ/STmvZQoL9kbQGIa+t7zeINeEvGHiG8=";
      };
      vendorHash = "sha256-zwbuTErBeN2G9zmLpEZUQJ8xYhTDMZLlAvE6nvUSdsU=";
      tags = [ "expanded" ];
      go = pkgs.go_1_24;
      doCheck = false;
    };

    migrate = pkgs.buildGoModule rec {
      pname = "migrate";
      version = "4.18.3";
      src = pkgs.fetchFromGitHub {
        owner = "golang-migrate";
        repo = "migrate";
        rev = "v${version}";
        hash = "sha256-aM8okSrLj2oIb3Ey2KkHu3UQY7mSnPjMfwNsdL2Fz28=";
      };
      vendorHash = "sha256-yJ1D0uhUQXBjw7ikRmcW8DFn0wvnBCw6jDYl3UQepXU=";
      subPackages = [ "cmd/migrate" ];
      tags = [ "postgres" ];
      go = pkgs.go_1_24;
      doCheck = false;
    };

    goPkgs = if isLinux then [] else [
      dlv
      gofumpt
      golines
      gotestsum
      mockgen
      hugo
      migrate
    ];
  in
    workPkgs ++ goPkgs
