---
applyTo: ".github/workflows/*.yml"
---

- **`paths-ignore: "*.md"` only matches root-level files**: In GitHub Actions, `"*.md"` matches only files at the repository root (e.g., `README.md`, `CONTRIBUTING.md`). It does NOT match nested paths like `tests/scrut/*.md`. The pattern `**/*.md` would be needed to match all depths. Do not flag `"*.md"` in `paths-ignore` as skipping test files in subdirectories.
