Project Title: Multi-GPU CUDA Tic-Tac-Toe

Project Description: This project implements a turn-based tic-tac-toe game in which two CUDA-based competitors choose moves independently. Each competitor launches a CUDA kernel with one thread per legal move, scores candidate moves, and returns the best move to the host. The host coordinates turns and prints the board after every move, making the game state easy to visualize. With two GPUs, each worker is assigned a different device; the `--allow-same-gpu` option provides a fallback demonstration on a one-GPU lab.

Demonstration video: Run `./bin/tictactoe --gpu-x 0 --gpu-o 1 --games 1` and capture the terminal board output for the course video submission.

Game visualization: The terminal prints the board after every move; the same output is included in `proof/demo-output.txt`.
