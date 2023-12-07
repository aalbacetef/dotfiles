
all: build run 

build: 
	podman build -t nix-test:latest .

run:
	podman run --rm -it nix-test:latest

run-sh:
	podman run --rm -it nix-test:latest bash

upgrade:
	nix profile upgrade 0 --impure
