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
echo "sent parser test: passed"
