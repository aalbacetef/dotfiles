

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

.PHONY: macchina 
macchina:
	./macchina/__module.sh

.PHONY: bash
bash:
	./bash/__module.sh

.PHONY: git
git:
	./git/__module.sh
