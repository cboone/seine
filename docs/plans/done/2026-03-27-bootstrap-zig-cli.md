# Bootstrap Zig CLI Project: seine

## Context

seine is a new Zig CLI project ("a fast streaming entropy scanner") that needs full scaffolding. The repository currently has only LICENSE, README.md, and .gitignore from the initial commit. The existing cboone-cc-plugins ecosystem has no Zig-specific tools, so this plan combines language-agnostic plugin tools with manual Zig-specific setup.

**Zig version**: 0.15.2 (installed via Homebrew)

## Tool Status

| #   | Tool                  | Status      | Notes                                                                          |
| --- | --------------------- | ----------- | ------------------------------------------------------------------------------ |
| 1   | scaffold-new-repo     | Scoped down | LICENSE/README/.gitignore exist; add CHANGELOG, agent config, .gitignore merge |
| 2   | Zig scaffolding       | Manual      | `zig init` + customization, cross-compilation targets in build.zig             |
| 3   | CI workflow           | Manual      | Zig CI with test, format, build, and cross-compile validation jobs             |
| 4   | setup-linters         | Scoped down | Cross-language only (EditorConfig, Prettier, markdownlint)                     |
| 5   | setup-secret-scanning | Will run    | Language-agnostic                                                              |
| 6   | add-community-files   | Will run    | Language-agnostic                                                              |
| 7   | Scrut CLI tests       | Manual      | Adapt from add-scrut-cli-tests patterns                                        |
| 8   | Release workflow      | Manual      | Single-runner cross-compiled releases (Zig advantage)                          |
| 9   | Installers            | Manual      | Homebrew formula + install.sh (adapt setup-installers patterns for Zig)        |

## Execution Plan

### Step 1: Foundation (scaffold-new-repo, scoped down)

Run the scaffold-new-repo command with scoped-down behavior:

- **Skip**: LICENSE (exists), README (will be rewritten manually with Zig content)
- **.gitignore**: Merge common entries (`.DS_Store`, `.env`, `.claude/settings.local.json`, secrets patterns) into existing file, preserving the Zig entries. Also add `node_modules/`, `*.d`, `*.pdb`.
- **CHANGELOG.md**: Standard Keep a Changelog template
- **Agent config**: AGENTS.md, CLAUDE.md (symlink to AGENTS.md), `.claude/settings.json`, `.github/copilot-instructions.md`
- **docs/plans**: Create `docs/plans/done/.gitkeep` and `docs/plans/todo/.gitkeep`

Command ref: `/Users/ctm/.claude/plugins/marketplaces/cboone-cc-plugins/plugins/scaffold-new-repo/commands/scaffold-new-repo.md`

### Step 2: Zig Project Structure (manual)

Run `zig init` in the project root, then customize:

- **build.zig.zon**: Update name to `seine`, version `0.0.0`, minimum Zig version `0.15.2`
- **build.zig**: Rename executable to `seine`. Add cross-compilation support with explicit target triples for release builds:
  - `x86_64-linux-gnu`, `aarch64-linux-gnu`, `x86_64-macos`, `aarch64-macos`, `x86_64-windows-gnu`
  - The build.zig must accept `-Dtarget` and `-Doptimize` options (standard from zig init)
  - Use `ReleaseSafe` for production builds (safety checks matter for an entropy scanner)
- **src/main.zig**: Replace default with minimal seine entry point using `GeneralPurposeAllocator`
- **src/root.zig**: Remove (zig init creates it for library use; not needed yet)
- **Makefile**: Convenience wrapper with targets: `build`, `test`, `fmt`, `fmt-check`, `lint`, `run`, `clean`, `release`, `help`
  - `release` target loops over all cross-compilation targets

### Step 3: Update README.md

Rewrite with Zig-specific content:

- Description: "a fast streaming entropy scanner"
- Installation section: Homebrew, shell script, build from source (`zig build`)
- Usage section (placeholder)
- Development section with `make build`, `make test`, `make fmt`, `make lint`
- License section

### Step 4: CI Workflow (manual)

Create `.github/workflows/ci.yml` with parallel jobs using `mlugg/setup-zig@v2` (pinned to 0.15.2):

- **test**: `zig build test`
- **format**: `zig fmt --check src/ build.zig`
- **build**: `zig build`
- **cross-compile**: Validate all 5 release targets compile. This is cheap (single runner, fast builds) and catches cross-compilation issues before release time. Unique Zig advantage.

Standard path-ignore patterns and concurrency settings.

### Step 5: Cross-Language Linters (setup-linters, scoped down)

Run setup-linters skill for cross-language tools only:

- **.editorconfig**: Base template + `[*.zig]` section (4-space indent, space style)
- **.prettierrc.json** / **.prettierignore**: For Markdown/YAML/JSON. Ignore `.zig-cache/`, `zig-out/`, `node_modules/`, `*.sh`
- **.markdownlint-cli2.jsonc**: Standard config with MD013 disabled
- **cspell.json**: Add `seine` and `zig` to word list

### Step 6: Secret Scanning (setup-secret-scanning command)

Create `.github/workflows/gitleaks.yml` and `.github/workflows/trufflehog.yml`.

Command ref: `/Users/ctm/.claude/plugins/marketplaces/cboone-cc-plugins/plugins/setup-secret-scanning/commands/setup-secret-scanning.md`

### Step 7: Community Files (add-community-files skill)

Create CONTRIBUTING.md, CODE_OF_CONDUCT.md, `.github/SECURITY.md`, `.github/PULL_REQUEST_TEMPLATE.md`. Customize CONTRIBUTING.md with Zig contribution instructions after generation.

### Step 8: Scrut CLI Tests (manual adaptation)

- Create `tests/scrut/help.md` with starter test
- Add Makefile targets: `test-scrut`, `test-scrut-update`, `test-all`
- Binary path: `zig-out/bin/seine`
- Add scrut test job to CI workflow

### Step 9: Release Workflow (manual)

Create `.github/workflows/release.yml`:

- Triggered by `v*` tags
- **Single runner builds all 5 targets** (Zig's cross-compiler needs no additional toolchains, unlike Rust which requires different runners and toolchains per target at 10x cost for macOS runners)
- Tarball naming: `seine-VERSION-OS-ARCH.tar.gz` (`.zip` for Windows)
- OS labels: `linux`, `darwin`, `windows`. Arch labels: `amd64`, `arm64`
- Generates `checksums.txt` (SHA-256)
- Creates GitHub Release via `softprops/action-gh-release@v2` with `generate_release_notes: true`
- `cancel-in-progress: false` for releases
- Uses `ReleaseSafe` optimization

### Step 10: Installers (manual, following setup-installers patterns)

#### Homebrew Formula (`Formula/seine.rb`)

Cross-platform formula with `on_macos`/`on_linux` blocks for intel/arm:

- Placeholder SHA256 values (updated after first release)
- Points to GitHub Releases tarballs
- `bin.install "seine"` + version test
- Create issue on `cboone/homebrew-tap` with the formula and setup instructions

#### Shell Install Script (`install.sh`)

Cross-platform curl installer following the setup-installers template:

- Detects OS (linux/darwin) and arch (amd64/arm64)
- Downloads from GitHub Releases
- Verifies SHA-256 checksum from `checksums.txt`
- Validates archive paths for safety
- Installs to `~/.local/bin` by default
- Supports `--version` flag
- `chmod +x install.sh`
- Validate with ShellCheck

#### README Installation Section

Add Homebrew (`brew install cboone/tap/seine`) and shell script install methods.

### Step 11: Finalize Configuration

- Update AGENTS.md with complete project structure tree and all development commands
- Add Zig conventions: `zig fmt` for formatting, `snake_case` for functions, `PascalCase` for types, error unions, `GeneralPurposeAllocator`
- Note Zig 0.15.2 as target version

## Deferred Items

These are valuable but should wait until the corresponding code exists:

| Item             | When to add                                       |
| ---------------- | ------------------------------------------------- |
| Fuzzing          | When entropy calculation module is written        |
| AddressSanitizer | When C interop is needed                          |
| Doc generation   | When API surface is substantial                   |
| Benchmarking     | When there is code to benchmark (MB/s throughput) |

## Final Project Structure

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
    done/.gitkeep
    todo/.gitkeep
  Formula/seine.rb
  src/main.zig
  tests/scrut/help.md
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
  install.sh
  LICENSE
  Makefile
  README.md
```

## Verification

1. `zig build` compiles successfully
2. `zig build run` executes the binary
3. `zig build test` passes
4. `zig fmt --check src/ build.zig` passes
5. `make help` shows all targets
6. Cross-compile all 5 targets: `zig build -Dtarget=x86_64-linux-gnu -Doptimize=ReleaseSafe` (repeat for each)
7. `scrut test tests/scrut/` passes (after building)
8. `shellcheck install.sh` passes
9. All CI workflow YAML files have valid syntax
