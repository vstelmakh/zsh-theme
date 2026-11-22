.DEFAULT_GOAL := help
.SILENT:
.PHONY: help test

help: ## Show available commands
	grep -hE '^[a-zA-Z][a-zA-Z-]*:.*## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*## "}; {printf "  \033[32m%-24s\033[0m %s\n", $$1, $$2}'

test: ## Run tests
	zsh tests/run.zsh
