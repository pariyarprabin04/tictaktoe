 import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TicTacToePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});

  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  // Board state: 9 spots initialized to empty strings
  List<String> board = List.filled(9, '');
  
  // X always goes first
  bool isXTurn = true;
  
  // Track game status
  String? winner;
  bool isDraw = false;

  // Handle box tap
  void _handleTap(int index) {
    // Do nothing if the spot is already taken or the game is over
    if (board[index] != '' || winner != null || isDraw) {
      return;
    }

    setState(() {
      board[index] = isXTurn ? 'X' : 'O';
      isXTurn = !isXTurn;
      
      // Check for a winner or draw after every move
      _checkGameStatus();
    });
  }

  // Check all possible winning combinations
  void _checkGameStatus() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6],           // Diagonals
    ];

    for (var combo in winningCombinations) {
      String a = board[combo[0]];
      String b = board[combo[1]];
      String c = board[combo[2]];

      if (a != '' && a == b && b == c) {
        setState(() {
          winner = a;
        });
        return;
      }
    }

    // Check for a draw if the board is full and no winner found
    if (!board.contains('') && winner == null) {
      setState(() {
        isDraw = true;
      });
    }
  }

  // Reset the game board
  void _resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
      winner = null;
      isDraw = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic Tac Toe'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Status text
          Text(
            winner != null
                ? 'Winner: $winner!'
                : isDraw
                    .toString() == 'true' && isDraw // Simple check for draw display
                    ? 'It\'s a Draw!'
                    : 'Current Turn: ${isXTurn ? 'X' : 'O'}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Game Board Grid
          Center(
            child: SizedBox(
              width: 320,
              height: 320,
              child: GridView.builder(
                itemCount: 9,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _handleTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepPurple.shade200, width: 2),
                      ),
                      child: Center(
                        child: Text(
                          board[index],
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: board[index] == 'X' ? Colors.blue : Colors.red,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
          
          // Restart Button
          ElevatedButton.icon(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart Game'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}