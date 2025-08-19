#!/bin/bash

set -e
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

echo "Running all scripts"

sh "$SCRIPT_DIR/install/install.sh"
sh "$SCRIPT_DIR/generate/generate.sh"
sh "$SCRIPT_DIR/patch/patch.sh"

echo "Done running all scripts"
