#!/bin/bash

FILE="$1"
TMP_FILE="/tmp/vim-plugins.json"

function fetch() {
    echo ">> Fetching $1 ($2)" >&2
    ( nix-prefetch-git "$2" || jq -n '{url:"'$2'"}' ) | jq '{url, rev, sha256} | {key:"'$1'", value:.}'
    echo "" >&2
}

( if [ "$#" -lt 3 ]; then
    cat "$FILE" | jq -r 'to_entries[] | "\(.key) \(.value.url)"' \
    | while read name url; do fetch $name $url; done
else
    cat "$FILE" | jq -r 'to_entries[]'
    echo "${@:2}" \
    | while read name url; do fetch $name $url; done
fi ) | jq -sS 'from_entries' > $TMP_FILE

mv "$TMP_FILE" "$FILE"

