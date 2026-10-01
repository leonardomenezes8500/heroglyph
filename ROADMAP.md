# Roadmap

The stone, broken into pieces. Milestones are outcomes, sprints are batches of work, and issues are the pieces. Do them in order; each issue is done when its "done when" holds. The commit that finishes an issue checks its box. Sprint 1 was reconstructed from `git log` after the fact.

## Sprint 1

### M1 Core: any text in the mini.nvim pixel style, as ASCII or PNG

1. [x] `generator`: POSIX `sh` + `awk` renderer with the transcribed 4x7 font. Done when `heroglyph "hello world"` prints block art.
2. [x] `png-output`: `-o FILE` through ImageMagick, `-s` scale. Done when a colored PNG matches the grid.
3. [x] `styled-letter`: `LETTER:COLOR1,COLOR2` for `o` and `n`. Done when `assets/example-mini-nvim.png` matches the mini.nvim wordmark.
4. [x] `palettes`: `mini`, `spring`, `summer`, `autumn` with real mini.hues values, `-P` to compare. Done when each palette's `accent1` reads as a different color.
5. [x] `light-variants`: `-l` and `HEROGLYPH_MODE=light`. Done when `-P -l` writes every `-light` render.
6. [x] `env-defaults`: `.env` read as plain `KEY=VALUE`. Done when a `.env` sets the palette without being executed.
7. [x] `dot-glyph`: the `.` from `prefix.gif`. Done when `heroglyph "mini."` matches `prefix.gif` pixel for pixel.
8. [x] `rename`: pixogram becomes heroglyph. Done when the name, `.env` keys, logos and GitHub repo all say heroglyph.

## Next

Nothing planned. New work starts as an issue here, with its "done when".
