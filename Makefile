

help:
	@echo ""
	@echo "dotfiles"
	@echo "========"
	@echo ""
	@echo "Run 'make MODULE_NAME' to install a module"
	@echo "The currently available ones are:"
	@echo "  - bash"
	@echo "  - emacs"
	@echo "  - git"
	@echo "  - helix"
	@echo "  - macchina"
	@echo "  - ranger"
	@echo "  - tmux"
	@echo "  - aider"
	@echo "  - flatpak"

.PHONY: all
all: bash emacs git helix machina ranger tmux
	
.PHONY: bash
bash:
	./bash/__module.sh

.PHONY: emacs
emacs: sync
	./emacs/__module.sh

.PHONY: git
git:
	./git/__module.sh

.PHONY: helix
helix:
	./helix/__module.sh

.PHONY: macchina 
macchina:
	./macchina/__module.sh

.PHONY: ranger
ranger: sync
	./ranger/__module.sh

.PHONY: tmux 
tmux: sync
	./tmux/__module.sh

sync:
	git submodule update --init --recursive

.PHONY: aider
aider:
	./ai/aider/__module.sh

.PHONY: alacritty
alacritty:
	./alacritty/__module.sh

flatpak:
	./linux/flatpak/__module.sh

flatpak-update:
	./linux/flatpak/update.fish

.PHONY: wallpaper
wallpaper:
	./wallpaper/__module.sh

.PHONY: nvim 
nvim:
	./nvim/__module.sh
