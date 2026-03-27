# Contributing to seine

Thank you for your interest in contributing to seine.

Please note that this project has a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold it.

## Reporting Issues

- **Bug reports and feature requests:** Use the [issue tracker](https://github.com/cboone/seine/issues/new/choose)
- **Questions and ideas:** Use [GitHub Discussions](https://github.com/cboone/seine/discussions)
- **Security vulnerabilities:** See [SECURITY.md](.github/SECURITY.md)

## Development Setup

### Requirements

- [Zig](https://ziglang.org/) 0.15.2 or later
- [Prettier](https://prettier.io/) (for Markdown/YAML/JSON formatting)

### Getting Started

```bash
# Clone the repository
git clone https://github.com/cboone/seine.git
cd seine

# Build
make build

# Run tests
make test

# Run linter
make lint
```

## Code Style

- Run `make lint` before committing
- Run `make fmt` to format Zig code
- Run `prettier --write .` to format Markdown, YAML, and JSON files

## Commit Messages

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```text
<type>: <description>
```

**Types:**

- `feat`: new feature
- `fix`: bug fix
- `docs`: documentation changes
- `refactor`: code refactoring (no functional change)
- `test`: adding or updating tests
- `build`: build system or dependency changes
- `ci`: CI configuration changes
- `chore`: maintenance tasks

**Examples:**

```text
feat: add user authentication endpoint
fix: resolve race condition in worker pool
docs: update installation instructions
refactor: simplify configuration loading
test: add unit tests for validation logic
chore: update linter to latest version
```

## Pull Request Process

1. Fork the repository
1. Create a feature branch
1. Make your changes
1. Ensure tests pass: `make test`
1. Ensure linting passes: `make lint`
1. Submit a pull request

### Branch Naming

Use descriptive branch names with a type prefix:

- `feature/*`: new features
- `fix/*`: bug fixes
- `docs/*`: documentation changes
- `refactor/*`: code refactoring
- `test/*`: test additions or fixes
