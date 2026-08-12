# sent.idr

A compact Idris 2 translation of suckless `sent`'s core behavior.

```sh
idris2 --build sent.ipkg
build/exec/sent slides
```

Each paragraph is a slide. Lines beginning with `#` are comments. A leading
backslash escapes the first character. A paragraph whose first line begins
with `@` is an image slide. `--dump` parses a deck without opening the
interactive presenter and is intended for tests and other programs.

Run the behavioral test with `./test.sh`.

The behavioral reference is suckless `sent`, revision
`882d54c225b83c762acf5bb3967f4890c3ecef86`.
