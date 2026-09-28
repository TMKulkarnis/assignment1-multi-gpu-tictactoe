NVCC ?= nvcc
CXXFLAGS ?= -O2 -std=c++17
all: bin/tictactoe
bin/tictactoe: src/tictactoe.cu
	@mkdir -p bin
	$(NVCC) $(CXXFLAGS) $< -o $@
clean:
	rm -rf bin
