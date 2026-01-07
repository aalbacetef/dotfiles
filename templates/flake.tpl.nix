{
  description = "A basic development shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; 
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f pkgsFor.${system});
      pkgsFor = nixpkgs.legacyPackages; # Simpler reference for packages
    in
    {
      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zig
            zls
            pkg-config # Add pkg-config to buildInputs
          ];

          # Define environment variables or shell hooks here
          shellHook = ''
            echo "Entering a basic Nix development shell."
          '';
        };
      });
    };
}
