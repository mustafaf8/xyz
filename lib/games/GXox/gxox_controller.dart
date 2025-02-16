class GXoxController {
  // 9 hücreli oyun tahtası
  List<String> board = List.filled(9, '');
  // X mi O mu sırada
  bool xTurn = true;
  // Kazanan (X, O veya Draw)
  String winner = '';
  // Kazanan hücre indeksleri (örnek: [0,1,2])
  List<int> winningPositions = [];

  void resetBoard() {
    board = List.filled(9, '');
    xTurn = true;
    winner = '';
    winningPositions = [];
  }

  void makeMove(int index) {
    // Hücre boş değilse veya kazanan belli ise hamle yapma
    if (board[index] != '' || winner.isNotEmpty) return;

    // Sıradaki oyuncunun işaretini koy
    board[index] = xTurn ? 'X' : 'O';
    // Sıra değiştir
    xTurn = !xTurn;

    // Kazanan var mı kontrol et
    checkWinner();
  }

  void checkWinner() {
    List<List<int>> winPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Satırlar
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Sütunlar
      [0, 4, 8], [2, 4, 6],           // Çaprazlar
    ];

    for (var positions in winPositions) {
      String a = board[positions[0]];
      String b = board[positions[1]];
      String c = board[positions[2]];
      if (a != '' && a == b && b == c) {
        winner = a; // 'X' veya 'O'
        winningPositions = positions;
        return;
      }
    }

    // Boş hücre kalmadıysa ve kazanan yoksa berabere
    if (!board.contains('')) {
      winner = 'Draw';
    }
  }
}
