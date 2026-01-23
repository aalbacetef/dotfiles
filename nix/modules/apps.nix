
  { sysPkgs }:
with sysPkgs;

  let 
    apps = [
        gnused
        rectangle
        skhd
        texliveMedium
        texstudio
    ];

  in
    darwinPkgs 
