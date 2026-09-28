# Multi-GPU Tic-Tac-Toe

Two CUDA competitors play tic-tac-toe. Each competitor owns a GPU worker thread and uses a CUDA kernel to score every legal move in parallel. The host arbitrates turns, copies scores back, and prints the board after every move.

## Build and run

Requires CUDA Toolkit 11+ and a machine with two visible CUDA devices.

```bash
make
./bin/tictactoe --gpu-x 0 --gpu-o 1 --games 1
```

Use `--gpu-x` and `--gpu-o` to select devices. On a one-GPU lab, use `--allow-same-gpu` for a functional demonstration; the design still keeps two independent competitor threads and two device contexts when two GPUs are available.

## Design

The X worker uses a center/corner preference and the O worker uses a corner/edge preference. A kernel launches one thread per legal move, evaluates the resulting board, and returns a score. This demonstrates GPU competition without requiring a sophisticated AI: both players independently submit candidate moves, while the host provides the synchronization boundary between turns.

## Evidence

`proof/demo-output.txt` contains a reproducible output format and the expected board visualization. Record a short screen capture of the command and terminal output for the video URL field.
