#include <cuda_runtime.h>
#include <algorithm>
#include <iostream>
#include <string>
#include <thread>
#include <vector>

__global__ void ScoreMoves(const int* board, int* scores, int player) {
  int move = blockIdx.x * blockDim.x + threadIdx.x;
  if (move >= 9 || board[move] != 0) return;
  int center_bonus = (move == 4) ? 3 : 0;
  int corner_bonus = (move == 0 || move == 2 || move == 6 || move == 8) ? 2 : 0;
  scores[move] = (player == 1 ? center_bonus + corner_bonus : corner_bonus) * 10;
}

struct Worker {
  int device;
  int player;
  std::vector<int> Choose(const std::vector<int>& board) {
    cudaSetDevice(device);
    int* d_board = nullptr; int* d_scores = nullptr;
    cudaMalloc(&d_board, 9 * sizeof(int)); cudaMalloc(&d_scores, 9 * sizeof(int));
    cudaMemcpy(d_board, board.data(), 9 * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemset(d_scores, -1, 9 * sizeof(int));
    ScoreMoves<<<1, 9>>>(d_board, d_scores, player); cudaDeviceSynchronize();
    std::vector<int> scores(9); cudaMemcpy(scores.data(), d_scores, 9 * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(d_board); cudaFree(d_scores); return scores;
  }
};

int main(int argc, char** argv) {
  int gx = 0, go = 1; bool allow_same = false; for (int i = 1; i + 1 < argc; ++i) { std::string a(argv[i]); if (a == "--gpu-x") gx = std::stoi(argv[++i]); if (a == "--gpu-o") go = std::stoi(argv[++i]); if (a == "--allow-same-gpu") allow_same = true; }
  int n = 0; cudaGetDeviceCount(&n); if (n < 1) { std::cerr << "No CUDA device\n"; return 1; }
  if (gx >= n || go >= n) { if (allow_same && n == 1) gx = go = 0; else { std::cerr << "Requested GPU is not visible (found " << n << ")\n"; return 2; } }
  Worker x{gx, 1}, o{go, 2}; std::vector<int> board(9, 0); int turn = 1;
  const int wins[8][3] = {{0,1,2},{3,4,5},{6,7,8},{0,3,6},{1,4,7},{2,5,8},{0,4,8},{2,4,6}};
  std::cout << "GPU X=" << gx << " GPU O=" << go << "\n";
  for (int ply = 0; ply < 9; ++ply) { Worker& w = turn == 1 ? x : o; auto scores = w.Choose(board); int move = -1, best = -999; for (int i=0;i<9;++i) if (board[i]==0 && scores[i]>best) best=scores[i],move=i; board[move]=turn; std::cout << "move " << ply+1 << ": " << (turn==1?'X':'O') << " -> " << move << " | "; for(int i=0;i<9;++i) std::cout << (board[i]==1?'X':board[i]==2?'O':'.') << (i%3==2?' ':'|'); std::cout << "\n"; bool won=false; for(auto& r:wins) won |= board[r[0]]==turn&&board[r[1]]==turn&&board[r[2]]==turn; if(won){std::cout << (turn==1?'X':'O') << " wins\n"; break;} turn=3-turn; }
}
