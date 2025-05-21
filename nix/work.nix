{ sysPkgs }: with sysPkgs; [
  go-ethereum
  golangci-lint
  google-cloud-sdk
  go-task
  kubectl
  kustomize
  krew
  sqlc

  ## additional
  _1password-cli
  google-cloud-sql-proxy
  foundry

  (stdenv.mkDerivation {
    name = "custom-go-pkgs";
    src = pkgs.emptyDirectory;
    buildInputs = [ 
      go_1_24  
      git
      cacert
    ];
    nativeBuildInputs = [ go_1_24 ];


    postInstall = ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH=$TMPDIR/go-path
      export GOBIN=$out/bin
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"

      echo "Installing additional go packages..."

      ${go_1_24}/bin/go install github.com/go-delve/delve/cmd/dlv@v1.24.2
      ${go_1_24}/bin/go install mvdan.cc/gofumpt@v0.8.0
      ${go_1_24}/bin/go install github.com/segmentio/golines@v0.12.2
      ${go_1_24}/bin/go install gotest.tools/gotestsum@v1.12.2
      ${go_1_24}/bin/go install github.com/golang/mock/mockgen@v1.6.0
      ${go_1_24}/bin/go install github.com/gohugoio/hugo@v0.147.4

      echo "Done"
    '';
  })
]
