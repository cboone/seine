# GitHub Copilot Instructions for seine

For full project conventions, see AGENTS.md in the repository root.

## PR Review

- **Done plans are historical records**: Files in `docs/plans/done/` are completed plan documents preserved for reference. They may not match the final implementation. Do not flag discrepancies between done plan content and the actual codebase.
- **Prettier `printWidth: 10000` is intentional**: This project uses a high `printWidth` in `.prettierrc.json` to prevent Prettier from wrapping lines. Combined with `proseWrap: preserve` for Markdown, this preserves author line breaks. Do not suggest reducing printWidth to 80 or 120.
- **Homebrew formula SHA256 placeholders are intentional**: `Formula/seine.rb` uses placeholder strings like `SHA256_FOR_DARWIN_AMD64` that are replaced with real checksums during the release workflow. Do not suggest using `sha256 :no_check` or flag these as broken.
- **Two-scanner secret detection strategy is intentional**: Gitleaks runs on all pushes and pull requests (real-time gating). TruffleHog runs only on `main` pushes and a weekly schedule (deep secondary scan). Do not suggest adding `pull_request` triggers to TruffleHog; PR scanning is handled by Gitleaks.
- **CLAUDE.md is a symlink to AGENTS.md**: `CLAUDE.md -> AGENTS.md` in the structure tree is accurate. It is a real filesystem symlink, not a duplicate file. Do not flag this as misleading or suggest removing the symlink notation.
