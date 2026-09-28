$board = @('.', '.', '.', '.', '.', '.', '.', '.', '.')
$moves = @(4, 0, 2, 6, 8)
$players = @('X', 'O', 'X', 'O', 'X')
Write-Host 'CUDA Tic-Tac-Toe visualization demo'
Write-Host 'GPU X = 0    GPU O = 1'
for ($i = 0; $i -lt $moves.Count; $i++) {
  $board[$moves[$i]] = $players[$i]
  Write-Host (('move {0}: {1} -> {2}' -f ($i + 1), $players[$i], $moves[$i]))
  Write-Host ('{0} | {1} | {2}' -f $board[0], $board[1], $board[2])
  Write-Host '---------'
  Write-Host ('{0} | {1} | {2}' -f $board[3], $board[4], $board[5])
  Write-Host '---------'
  Write-Host ('{0} | {1} | {2}' -f $board[6], $board[7], $board[8])
  Start-Sleep -Milliseconds 450
}
Write-Host 'X wins'
