
  { sysPkgs, roc }:

  let
    goimports = sysPkgs: sysPkgs.buildGoModule {
      pname = "goimports";
      version = "commit--nov-26-2025"; 

      src = sysPkgs.fetchFromGitHub {
        owner = "golang";
        repo = "tools";
        rev = "d32ec344545c517da66ce368d0298ed9655d27ac"; 
        hash = "sha256-UGT9mUW0xu8Z+w0FgQsuqT5Gc7NP5WrEdVU2gj0BtfA="; 
      };

      subPackages = [ "cmd/goimports" ];
      vendorHash = "sha256-FVtHrFgxgDBAfU4x4+zANNhGa3pfsh3XgEQaQYdV1Bs=";
    };

    langs = with sysPkgs; [
        ammonite
        dhall
        dotnet-sdk_8
        elixir
        fnm
        fsharp
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
        zig_0_15

        ## python
        poetry
        python313
        uv

        roc.packages.${system}.cli

        ## golang 
        go_1_25
        (goimports sysPkgs)

        ## disabled 
        # julia 
    ];

  in
    langs
