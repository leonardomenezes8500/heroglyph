# heroglyph: design

Status: shipped and in use. One POSIX `sh` file; nothing open. Written after the code, from the README, the old build notes and `git log`.

## 1. Problem

figlet fonts are smooth, hinted or ASCII-ish. The [mini.nvim](https://github.com/nvim-mini/mini.nvim) logo uses a blocky 4x7 pixel font with no antialiasing, and there is no tool to set arbitrary text in it, for a terminal banner, a code comment or a project logo.

## 2. How it works

- **One file.** `heroglyph` is POSIX `sh`; an embedded `awk` program does layout and glyph lookup, since `sh` has no arrays.
- **Font as data.** Every glyph is a hand-authored 4x7 grid of `0`/`1` (`font[ch,row]`), transcribed pixel by pixel from `nvim-mini/assets` `logo-2/font/*.gif`. Only `a-z`, `0-9`, `.` and space exist; anything else renders blank. The `.` comes from `font/prefix.gif` (the "MINI." prefix), which has no glyph file of its own.
- **Two outputs.** Without `-o`, block characters go to stdout and colors are ignored. With `-o FILE`, the grid becomes a PNG through ImageMagick 7 (`magick`), each cell upscaled by `-s` (default 15).
- **Text arguments** are concatenated with no gap (each glyph carries its own trailing blank column). Each may carry `:COLOR`; with none it uses the palette's `fg`.

To add a letter: draw its 4x7 grid and add `font[ch,row]` entries. To add a two-color letter: add `style[ch,row]` entries marking which "on" pixels take the second color (see `o` and `n`).

## 3. Usage

| Flag | Effect |
|---|---|
| `-o FILE` | write a PNG instead of printing |
| `-p PALETTE` | `mini`, `spring`, `summer`, `autumn` (default `summer`) |
| `-l` | the palette's light variant |
| `-P` | one PNG per palette, `FILE-PALETTE.ext` (with `-l`, `-light` suffix) |
| `-b COLOR` | override only the background |
| `-s SCALE` | pixels per grid cell (default 15) |

| Text form | Meaning |
|---|---|
| `text` | palette `fg` |
| `text:#hex` | that color |
| `text:accent1` / `text:accent2` | one of the palette's accents |
| `o:accent` / `o:#a,#b` | styled letter: one glyph split in two colors (only `o`, `n`) |

A `.env` in the current directory sets defaults: `HEROGLYPH_PALETTE`, `HEROGLYPH_MODE=light`, or `HEROGLYPH_BG`/`FG`/`ACCENT1`/`ACCENT2`. `-p` beats `.env`; `-b` beats both.

The repo's logos are made with heroglyph itself: `heroglyph -o assets/logo.png [-P] [-l] "her:accent1" "o:accent" "glyph:accent2"`. `assets/example-mini-nvim.png` is a rendered check of the styled letter on mini.nvim's real colors (`mini:#B3DAF9 n:#A6E1E2,#B8E1C1 vim:#D9D8AA`).

## 4. Palettes

| palette | bg | fg | accents |
|---|---|---|---|
| `summer` | `#27211E` | `#F6CC9B` | `#93E4EE` `#FFC1B9` |
| `autumn` | `#262029` | `#EFCFAB` | `#F1C6E2` `#B4E2C7` |
| `spring` | `#1C2617` | `#D8DA9D` | `#ABE5BE` `#F7C2EA` |
| `mini` | `#00182A` | `#D9D8AA` | `#A6E1E2` `#B8E1C1` |

All values are real [mini.hues](https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-hues.md) colors, dark and light blocks transcribed from its `colors/*.lua`. mini.hues places 8 named hues 45° apart on the OKLCH wheel (`H.make_hues` in `lua/mini/hues.lua`). `spring`, `summer` and `autumn` each take a true complementary pair (180° apart), a different pair per palette, so `accent1` reads as a different color in each. `mini`'s accents (cyan and green, 45° apart) are the real logo's own and stay as they are.

## 5. ImageMagick notes

- `-opaque` collapses to grayscale on a bilevel image (from a P1 PBM): every fill color is quantized to black or white. Recolor with a `-clut` gradient instead.
- Alpha-based compositing for the styled letter painted everything one color (alpha came out uniformly opaque). Instead: a 3-level grayscale PGM (0 = bg, 128 = color 1, 255 = color 2) run through `-clut` against `xc:bg xc:color1 xc:color2 +append`.

## 6. Decisions

1. **POSIX `sh` + `awk`, one file.** Why: runs anywhere, installs with one copy, no runtime. Ruled out: Python or Node (a runtime to install for a banner tool), a figlet `.flf` font (figlet can't do per-segment color or PNG output).
2. **Glyphs transcribed from the real GIFs.** Why: the point is the exact mini.nvim look. Ruled out: drawing a lookalike font by eye.
3. **Real mini.hues colors, chosen by its hue math.** Why: the first picks were eyeballed and 3 of 4 palettes got a near-identical cyan/green `accent1`; autumn's pair was only 90° apart. Ruled out: picking accents by eye.
4. **Default palette `summer`, not `mini`.** Why: with `mini` as the default the output looks like a reskin of the logo it copies. Ruled out: `mini` (too close to the source) and `autumn` (the first default).
5. **Styled letters are hardcoded per letter.** Why: mini.nvim itself does this for one letter only (the "n" in its wordmark). Ruled out: a general rule that splits any letter.
6. **`.env` parsed as plain `KEY=VALUE`, never sourced.** Why: a `.env` in an untrusted directory must not run code. Ruled out: `. ./.env`.
7. **Logo split as her-o-glyph.** Why: keeps the styled middle `o` between the two accents, as the old pix-o-gram mark did. Ruled out: hero/glyph in two flat colors (loses the styled letter).
8. **Renamed pixogram to heroglyph (2026-10-01), no shim for `PIXOGRAM_*` keys.** Why: young tool, no known users outside the repo. Ruled out: reading both key sets.
