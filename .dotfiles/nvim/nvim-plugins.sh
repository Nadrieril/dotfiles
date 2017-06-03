#!/bin/bash

FILE="$1"
TMP_FILE="/tmp/vim-plugins.json"

( (
cat "$FILE" | jq -r 'to_entries[] | "\(.key) \(.value.url)"'
if [ "$#" -eq 3 ]; then echo "$2 $3"; fi
) | while read name url; do
    echo ">> Fetching $name ($url)" >&2
    ( nix-prefetch-git "$url" || jq -n '{url:"'$url'"}' ) | jq '{url, rev, sha256} | {key:"'$name'", value:.}'
    echo "" >&2
done
) | jq -sS 'from_entries' > $TMP_FILE

mv "$TMP_FILE" "$FILE"

