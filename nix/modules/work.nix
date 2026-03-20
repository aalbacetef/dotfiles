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
      gum


      ### annoying packages to build

      ## needed for mocks 
      mockgen

      ## needed for formatting 
      golines

      ## for test summaries 
      gotestsum
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
      version = "0.9.2";
      src = pkgs.fetchFromGitHub {
        owner = "mvdan";
        repo = "gofumpt";
        rev = "v${version}";
        hash = "sha256-37wYYB0k8mhQq30y1oo77qW3bIqqN/K/NG1RgxK6dyI=";
      };
      vendorHash = "sha256-T6/xEXv8+io3XwQ2keacpYYIdTnYhTTUCojf62tTwbA=";
      go = pkgs.go_1_26;
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
      vendorHash = "sha256-MuX5CrjOXZOYsGhyaT+e39ne5iQFmnXzGZidyOoIQvM=";
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
