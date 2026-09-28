#!/usr/bin/env bash
set -euo pipefail
make
./bin/tictactoe --gpu-x "${1:-0}" --gpu-o "${2:-1}" --games 1
