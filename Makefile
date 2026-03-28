.PHONY: build test fmt fmt-check lint run clean release test-scrut test-scrut-update test-all help

build: ## Build the project
	zig build

test: ## Run unit tests
	zig build test

fmt: ## Format source code
	zig fmt src/ build.zig

fmt-check: ## Check formatting (CI mode)
	zig fmt --check src/ build.zig

lint: fmt-check ## Lint (format check + debug build for warnings)
	zig build

run: ## Build and run
	zig build run

clean: ## Remove build artifacts
	rm -rf .zig-cache/ zig-out/ release/

release: ## Build release binaries for all targets
	@set -e; for target in x86_64-linux-gnu aarch64-linux-gnu x86_64-macos aarch64-macos x86_64-windows-gnu; do \
		printf 'Building for %s...\n' "$$target"; \
		zig build -Dtarget="$$target" -Doptimize=ReleaseSafe; \
		mkdir -p "release/$$target"; \
		cp -R zig-out/* "release/$$target/"; \
	done

test-scrut: build ## Run scrut CLI tests
	@if ! command -v scrut >/dev/null 2>&1; then \
		echo "scrut not installed. Install from https://github.com/facebookincubator/scrut"; \
		exit 1; \
	fi
	SEINE_BIN="$(CURDIR)/zig-out/bin/seine" scrut test tests/scrut/

test-scrut-update: build ## Update scrut test expectations
	@if ! command -v scrut >/dev/null 2>&1; then \
		echo "scrut not installed. Install from https://github.com/facebookincubator/scrut"; \
		exit 1; \
	fi
	SEINE_BIN="$(CURDIR)/zig-out/bin/seine" scrut update --replace --assume-yes tests/scrut/

test-all: test test-scrut ## Run all tests (unit + scrut)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'
