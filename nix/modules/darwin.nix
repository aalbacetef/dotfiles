
  { sysPkgs }:
with sysPkgs;

  let 
    isDarwinIntel = builtins.match "x86_64-darwin" system != null;
    isDarwinARM = builtins.match "aarch64-darwin" system != null;

    darwinPkgs = [
        gnused
        rectangle
        skhd
        texliveMedium
        texstudio
    ];

  in
    darwinPkgs 
