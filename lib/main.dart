import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primaryColor: Colors.indigo[900],
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontFamily: 'RobotoMono',
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontFamily: 'Roboto',
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GameScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo[900]!, Colors.purple[700]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo1.jpg',
                  height: min(150, screenWidth * 0.3),
                  errorBuilder: (context, error, stackTrace) => Text(
                    'Logo Not Found',
                    style: TextStyle(
                      color: Colors.red[300],
                      fontSize: min(16, screenWidth * 0.04),
                    ),
                  ),
                )
                    .animate()
                    .scale(duration: 1000.ms, curve: Curves.easeInOut)
                    .shimmer(color: Colors.white.withOpacity(0.3), duration: 1200.ms),
                SizedBox(height: min(16, screenHeight * 0.02)),
                Text(
                  'Tic Tac Toe',
                  style: TextStyle(
                    fontSize: min(32, screenWidth * 0.08),
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                    fontFamily: 'RobotoMono',
                  ),
                ).animate().fadeIn(duration: 1200.ms, delay: 200.ms),
                SizedBox(height: min(8, screenHeight * 0.01)),
                Text(
                  'by CODECRAFT',
                  style: TextStyle(
                    fontSize: min(16, screenWidth * 0.04),
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                    fontFamily: 'Roboto',
                  ),
                ).animate().fadeIn(duration: 1200.ms, delay: 400.ms),
                SizedBox(height: min(8, screenHeight * 0.01)),
                Text(
                  'Intern Zainab',
                  style: TextStyle(
                    fontSize: min(16, screenWidth * 0.04),
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                    fontFamily: 'Roboto',
                  ),
                ).animate().fadeIn(duration: 1200.ms, delay: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String?> board = List.filled(9, null); // 3x3 grid (null, 'X', or 'O')
  bool isXTurn = true; // Track current player
  String? winner; // Track winner
  bool isDraw = false; // Track draw
  List<int>? winningLine; // Track winning combination for animation

  // Check for a winner or draw
  void _checkWinner() {
    const winCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6] // Diagonals
    ];

    for (var combo in winCombinations) {
      if (board[combo[0]] != null &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        setState(() {
          winner = board[combo[0]];
          winningLine = combo;
        });
        return;
      }
    }

    if (!board.contains(null) && winner == null) {
      setState(() {
        isDraw = true;
      });
    }
  }

  // Handle cell tap
  void _makeMove(int index) {
    if (board[index] == null && winner == null && !isDraw) {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
        _checkWinner();
      });
    }
  }

  // Reset the game
  void _resetGame() {
    setState(() {
      board = List.filled(9, null);
      isXTurn = true;
      winner = null;
      isDraw = false;
      winningLine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final isDesktop = screenWidth > 1200;
          final gridSize = isDesktop
              ? min(screenWidth * 0.6, screenHeight * 0.7) // Larger for desktop
              : min(screenWidth * 0.8, screenHeight * 0.5); // Smaller for mobile/tablet
          final fontScale = isDesktop ? 1.2 : 1.0; // Slightly larger fonts on desktop

          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Tic Tac Toe',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: min(24, screenWidth * 0.05) * fontScale,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: min(56, screenHeight * 0.08),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo[800]!, Colors.cyan[600]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Game status
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: min(16, screenHeight * 0.02)),
                          child: Text(
                            winner != null
                                ? 'Player $winner Wins!'
                                : isDraw
                                ? 'Game Draw!'
                                : 'Player ${isXTurn ? 'X' : 'O'}\'s Turn',
                            style: TextStyle(
                              fontSize: min(24, screenWidth * 0.05) * fontScale,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontFamily: 'Roboto',
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 800.ms)
                              .scale(curve: Curves.easeOut),
                        ),
                        // 3x3 Grid (Glassmorphic)
                        Container(
                          width: gridSize,
                          height: gridSize,
                          margin: EdgeInsets.symmetric(horizontal: min(24, screenWidth * 0.05)),
                          padding: EdgeInsets.all(min(16, screenWidth * 0.03)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(min(15, screenWidth * 0.04)),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: min(15, screenWidth * 0.04),
                                spreadRadius: min(3, screenWidth * 0.01),
                              ),
                            ],
                          ),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: min(8, screenWidth * 0.015),
                              mainAxisSpacing: min(8, screenWidth * 0.015),
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              bool isWinningCell = winningLine?.contains(index) ?? false;
                              return GestureDetector(
                                onTap: () => _makeMove(index),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(min(8, screenWidth * 0.02)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: min(4, screenWidth * 0.01),
                                        offset: Offset(0, min(1, screenWidth * 0.002)),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      board[index] ?? '',
                                      style: TextStyle(
                                        fontSize: min(48, screenWidth * 0.1) * fontScale,
                                        fontWeight: FontWeight.w300,
                                        color: board[index] == 'X'
                                            ? Colors.red[400]
                                            : board[index] == 'O'
                                            ? Colors.blue[400]
                                            : Colors.transparent,
                                        fontFamily: 'RobotoMono',
                                      ),
                                    ),
                                  ),
                                ).animate().scale(
                                  duration: 300.ms,
                                  curve: Curves.easeOut,
                                  delay: board[index] != null ? 100.ms : 0.ms,
                                ).shimmer(
                                  color: isWinningCell
                                      ? (board[index] == 'X'
                                      ? Colors.red.withOpacity(0.4)
                                      : Colors.blue.withOpacity(0.4))
                                      : Colors.transparent,
                                  duration: 1000.ms,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: min(24, screenHeight * 0.03)),
                        // Reset button
                        ElevatedButton(
                          onPressed: _resetGame,
                          child: Text(
                            'Reset Game',
                            style: TextStyle(fontSize: min(18, screenWidth * 0.04) * fontScale),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan[700],
                            padding: EdgeInsets.symmetric(
                              horizontal: min(32, screenWidth * 0.06),
                              vertical: min(16, screenHeight * 0.015),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 800.ms)
                            .scale(duration: 1200.ms, curve: Curves.easeInOut, delay: 1000.ms),
                      ],
                    ),
                  ),
                ),
              ).animate().shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.2)),
            ),
          );
        });
  }
}