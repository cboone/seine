# seine

A fast streaming entropy scanner.

## Installation

### Homebrew

```bash
brew install cboone/tap/seine
```

### Build from source

Requires [Zig](https://ziglang.org/) 0.15.2 or later:

```bash
git clone https://github.com/cboone/seine.git
cd seine
zig build -Doptimize=ReleaseSafe
```

The binary will be at `zig-out/bin/seine`.

## Usage

TODO

## Development

```bash
make build       # Build the project
make test        # Run unit tests
make fmt         # Format source code
make fmt-check   # Check formatting (CI mode)
make lint        # Lint (format check + build)
make run         # Build and run
make release     # Build release binaries for all targets
make clean       # Remove build artifacts
make help        # Show all available targets
```

## License

[MIT License](./LICENSE). TL;DR: Do whatever you want with this software, just keep the copyright notice included. The authors aren't liable if something goes wrong.
