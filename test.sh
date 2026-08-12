#!/bin/sh
set -eu

IDRIS2="${IDRIS2:-idris2}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

"$IDRIS2" --build sent.ipkg

cat >"$tmp/input" <<'EOF'
# leading comment
sent

# comments do not create slides
depends on
- Idris 2
# nor do they end one

@diagram.ff

\@literal at sign
\#literal hash
\ordinary leading slash
EOF

cat >"$tmp/want" <<'EOF'
sent

depends on
- Idris 2

[image diagram.ff]

@literal at sign
#literal hash
ordinary leading slash
EOF

build/exec/sent --dump "$tmp/input" >"$tmp/got"
diff -u "$tmp/want" "$tmp/got"

build/exec/sent --dump examples/demo.sent >"$tmp/example.got"
diff -u examples/demo.rendered.txt "$tmp/example.got"

# Exercise next, previous, reload, clamping at both ends, and quit.
printf '\np\np\n\n\n\n\nr\nq\n' | build/exec/sent examples/navigation.sent >"$tmp/navigation.got"
grep -q 'first' "$tmp/navigation.got"
grep -q 'second' "$tmp/navigation.got"
grep -q 'third' "$tmp/navigation.got"

echo "sent parser, example rendering, and navigation tests: passed"
