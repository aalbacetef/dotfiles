
all: build run 

build: 
	podman build -t nix-test:latest .

run:
	podman run --rm -it nix-test:latest

run-sh:
	podman run --rm -it nix-test:latest bash

upgrade:
	nix profile upgrade $(shell nix profile list | grep Name | head | sed 's@[[:cntrl:]]\[[01]m@@g'| tr -s ' '| cut -d' ' -f 2) --impure
