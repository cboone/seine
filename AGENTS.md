# seine

## Overview

A fast streaming entropy scanner.

## Structure

```text
seine/
  .claude/settings.json
  .github/
    copilot-instructions.md
    PULL_REQUEST_TEMPLATE.md
    SECURITY.md
    workflows/
      ci.yml
      gitleaks.yml
      release.yml
      trufflehog.yml
  docs/plans/
    done/
    todo/
  Formula/seine.rb
  src/main.zig
  tests/scrut/
  .editorconfig
  .gitignore
  .markdownlint-cli2.jsonc
  .prettierignore
  .prettierrc.json
  AGENTS.md
  build.zig
  build.zig.zon
  CHANGELOG.md
  CLAUDE.md -> AGENTS.md
  CODE_OF_CONDUCT.md
  CONTRIBUTING.md
  cspell.json
  LICENSE
  Makefile
  README.md
```

## Development

Requires Zig 0.15.2 or later.

```bash
make build         # Build the project
make test          # Run unit tests
make fmt           # Format source code
make fmt-check     # Check formatting (CI mode)
make lint          # Lint (format check + build)
make run           # Build and run
make release       # Build release binaries for all targets
make test-scrut    # Run scrut CLI tests
make test-all      # Run all tests (unit + scrut)
make clean         # Remove build artifacts
make help          # Show all targets
```

## Conventions

- Zig 0.15.2 target version
- `zig fmt` is the canonical formatter (4-space indent, enforced in CI)
- `snake_case` for functions and variables
- `PascalCase` for types
- Error handling via error unions (`!T`), use `try`/`catch`
- `std.fs.File.stdout()` for stdout (Zig 0.15 API)
- Tests live alongside source in `test` blocks
- Cross-compilation targets: x86_64-linux-gnu, aarch64-linux-gnu, x86_64-macos, aarch64-macos, x86_64-windows-gnu
- `ReleaseSafe` optimization for production builds
- Prettier for Markdown/YAML/JSON formatting
- Conventional Commits for commit messages
