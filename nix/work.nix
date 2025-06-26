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
    ];

    goPkgs = if isLinux then [] else [(stdenv.mkDerivation {
      name = "custom-go-pkgs";
      src = pkgs.emptyDirectory;
      buildInputs = [ 
        go_1_24  
        git
      ];
      nativeBuildInputs = [ go_1_24 ];


      postInstall = ''
        export GOCACHE=$TMPDIR/go-cache
        export GOPATH=$TMPDIR/go-path
        export GOBIN=$out/bin

        echo "Installing additional go packages..."

        ${go_1_24}/bin/go install github.com/go-delve/delve/cmd/dlv@v1.24.2
        ${go_1_24}/bin/go install mvdan.cc/gofumpt@v0.8.0
        ${go_1_24}/bin/go install github.com/segmentio/golines@v0.12.2
        ${go_1_24}/bin/go install gotest.tools/gotestsum@v1.12.2
        ${go_1_24}/bin/go install github.com/golang/mock/mockgen@v1.6.0
        ${go_1_24}/bin/go install -tags 'expanded' github.com/gohugoio/hugo@v0.130.0
        ${go_1_24}/bin/go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@v4.18.3

        echo "Done"
      '';
    })];
  in
    workPkgs ++ goPkgs
