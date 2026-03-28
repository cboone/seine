# GitHub Copilot Instructions for seine

For full project conventions, see AGENTS.md in the repository root.

## PR Review

- **Done plans are historical records**: Files in `docs/plans/done/` are completed plan documents preserved for reference. They may not match the final implementation. Do not flag discrepancies between done plan content and the actual codebase.
- **Prettier `printWidth: 10000` is intentional**: This project uses a high `printWidth` in `.prettierrc.json` to prevent Prettier from wrapping lines. Combined with `proseWrap: preserve` for Markdown, this preserves author line breaks. Do not suggest reducing printWidth to 80 or 120.
- **Homebrew formula SHA256 placeholders are intentional**: `Formula/seine.rb` uses placeholder strings like `SHA256_FOR_DARWIN_AMD64` that are replaced with real checksums during the release workflow. Do not suggest using `sha256 :no_check` or flag these as broken.
