# heroglyph

Read [DESIGN.md](DESIGN.md) (how it works, decisions and what was ruled out) and [ROADMAP.md](ROADMAP.md) (work the next unchecked issue). README.md is for visitors: keep it to a few lines plus links.

- Commits, comments and docs in English. Commits: `type: summary` under 72 chars; the body says why and what was ruled out; `Issue: heroglyph/<slug>` for each roadmap issue it finishes, checking it off in the same commit.
- No changelog: `git log` is the history.
- `make test` before every commit. Logo changes: re-render with `-P` and `-P -l` (DESIGN.md §3).
