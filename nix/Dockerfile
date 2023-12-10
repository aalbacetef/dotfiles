FROM nixpkgs/nix:latest AS base 

WORKDIR /test
RUN mkdir -p /root/.config/nix

COPY ./config/nix/nix.conf /root/.config/nix/nix.conf 
COPY ./config/nixpkgs/config.nix /root/.config/nixpkgs/config.nix 

COPY flake.nix .

CMD nix profile install . --impure
