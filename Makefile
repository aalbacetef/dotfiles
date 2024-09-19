

help:
	@echo ""
	@echo "dotfiles"
	@echo "========"
	@echo ""
	@echo "Run 'make MODULE_NAME' to install a module"
	@echo "The currently available ones are:"
	@echo "  - bash"
	@echo "  - git"
	@echo "  - macchina"
	@echo "  - tmux"
	@echo "  - emacs"
	@echo "  - ranger"
	
.PHONY: macchina 
macchina:
	./macchina/__module.sh

.PHONY: bash
bash:
	./bash/__module.sh

.PHONY: git
git:
	./git/__module.sh

.PHONY: helix
helix:
	./helix/__module.sh

.PHONY: tmux 
tmux: sync
	./tmux/__module.sh

.PHONY: emacs
emacs: sync
	./emacs/__module.sh

.PHONY: ranger
ranger: sync
	./ranger/__module.sh

sync:
	git submodule update --init --recursive
