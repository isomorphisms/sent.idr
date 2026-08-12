# sent.idr

A compact terminal translation of suckless `sent` in Idris 2. The source is
`Sent.idr`; Idris requires a capitalized module name and matching filename.

```sh
idris2 --build sent.ipkg
build/exec/sent slides
```

Each paragraph is a slide. Lines beginning with `#` are comments. A leading
backslash escapes the first character. A paragraph whose first line begins
with `@` is an image slide. `--dump` parses a deck without opening the
interactive presenter and is intended for tests and other programs.

Run the behavioral test with `./test.sh`.

Example decks are in `examples/`. To see the parser's complete rendering of
one without interacting:

```sh
build/exec/sent --dump examples/demo.sent
```

The behavioral reference is suckless `sent`, revision
`882d54c225b83c762acf5bb3967f4890c3ecef86`.
The original C implementation is preserved on the `main` branch. Copyright
and ISC-license details remain in `LICENSE` and in the importing commit.

This port currently renders text and image-slide placeholders in a terminal.
It does not yet reproduce sent's X11 font fitting or farbfeld image display.
