#!/usr/bin/env bash
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)"
cd "$DIR"
for i in lua highlight
do
    pushd "$i"
        git checkout . || true
        patch -p1 < "../${i}.patch"
    popd
done
