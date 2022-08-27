import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MainApp()); //Runs the program

// Image Enums
enum Images {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  bomb,
  facingdown,
  flagged,
}

//Creates the app
class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Where the app is built
    return MaterialApp(
      title: 'Main',
      theme: ThemeData(primaryColor: Colors.blueGrey),
      home: const GamePage(),
    );
  }
}

//Creates the game state
class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Game();
}

// Where the game is run
class Game extends State<GamePage> {
  Game(); // Goofy ahh constructor

  /*
  * The different demensions for different screens 
  * Phone (Google Pixel 3): RowSize = 20, ColSize = 12 (At least for mine)
  * Windows App: RowSize = 12, ColSize = 25
  */
  static int rowSize = 20;
  static int colSize = 12;
  static bool started = false;
  double difficulty = .2;
  List<List<int>>? realField;
  List<bool>? openSquares;
  List<bool>? flaggedSquares;
  int bombCount = 0;
  int squaresLeft = 0;

  //Gui Initialization
  @override
  void initState() {
    super.initState();
    initGame();
  }

  //Creates the game gui
  @override
  Widget build(BuildContext context) {
    //Builds the game state
    return Scaffold(
      appBar: AppBar(
          title: const Text("Minesweeper"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey),
      body: GridView.builder(
        shrinkWrap: false,
        //physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: colSize),
        itemBuilder: (BuildContext context, int position) {
          int rowNumber = (position / colSize).floor();
          int columnNumber = (position % colSize);

          Image image;

          //Sets the images of the tiles
          if (openSquares![position] == false) {
            if (flaggedSquares![position] == true) {
              image = getImage(Images.flagged);
            } else {
              image = getImage(Images.facingdown);
            }
          } else {
            if (realField![rowNumber][columnNumber] == -1) {
              image = getImage(Images.bomb);
            } else {
              image = getImage(
                getImageByNumber(realField![rowNumber][columnNumber]),
              );
            }
          }

          return InkWell(
            // Checks square
            onTap: () {
              check(rowNumber, columnNumber);
            },

            // Flags square
            onLongPress: () {
              if (openSquares![position] == false) {
                if (flaggedSquares![position] == false) {
                  setState(() {
                    flaggedSquares![position] = true;
                  });
                } else {
                  setState(() {
                    flaggedSquares![position] = false;
                  });
                }
              }
            },

            splashColor: Colors.grey,
            child: Container(
              color: Colors.grey,
              child: image,
            ),
          );
        },
        itemCount: rowSize * colSize,
      ),
    );
  }

  // First click of the game mechanics
  void firstClick(int r, int c) {
    started = true;
    if (realField![r][c] == 0) {
      check(r, c);
    } else {
      int tbc = 0; // Temp Bomb Count (Im running out of variable names)

      if (realField![r][c] == -1) realField![r][c] = 0;

      //Top
      if (r > 0) {
        if (realField![r - 1][c] == -1) {
          realField![r - 1][c] = 0;
          tbc++;
        }
      }

      //Bottom
      if (r < rowSize - 1) {
        if (realField![r + 1][c] == -1) {
          realField![r + 1][c] = 0;
          tbc++;
        }
      }

      //Left
      if (c > 0) {
        if (realField![r][c - 1] == -1) {
          realField![r][c - 1] = 0;
          tbc++;
        }
      }

      //Right
      if (c < colSize - 1) {
        if (realField![r][c + 1] == -1) {
          realField![r][c + 1] = 0;
          tbc++;
        }
      }

      //Top Left
      if (r > 0 && c > 0) {
        if (realField![r - 1][c - 1] == -1) {
          realField![r - 1][c - 1] = 0;
          tbc++;
        }
      }

      //Top Right
      if (r > 0 && c < colSize - 1) {
        if (realField![r - 1][c + 1] == -1) {
          realField![r - 1][c + 1] = 0;
          tbc++;
        }
      }

      //Bottom Left
      if (r < rowSize - 1 && c > 0) {
        if (realField![r + 1][c - 1] == -1) {
          realField![r + 1][c - 1] = 0;
          tbc++;
        }
      }

      //Bottom Right
      if (r < rowSize - 1 && c < colSize - 1) {
        if (realField![r + 1][c + 1] == -1) {
          realField![r + 1][c + 1] = 0;
          tbc++;
        }
      }
      extraBombs(tbc, r, c);
      //Resets Surrouding Bombs
      for (int i = 0; i < rowSize; i++) {
        for (int j = 0; j < colSize; j++) {
          if (realField![i][j] != -1) realField![i][j] = 0;
        }
      }
      surroudingBombs();
      check(r, c);
    }
  }

  // Adds the surrounding bombs from firstClick() back into the game
  void extraBombs(int n, int row, int col) {
    while (n > 0) {
      for (int r = 1; r < rowSize - 1; r++) {
        for (int c = 1; c < colSize - 1; c++) {
          if (realField![r][c] != -1 && realField![r][c] != 0) {
            if (Random().nextDouble() <= difficulty) {
              realField![r][c] = -1;
              n--;
            }
            if (n == 0) break;
          }
        }
        if (n == 0) break;
      }
    }
  }

  //Opens the selected tile
  void check(int row, int col) {
    int position = (row * colSize) + col;

    if (!started) {
      firstClick(row, col);
      return;
    }

    //Cancels the check is the tile is opened or flagged
    if (openSquares![((row) * colSize) + col] ||
        flaggedSquares![position] == true) {
      return;
    }

    // When tile is a bomb
    if (realField![row][col] == -1) {
      LoseCon();
    }

    //When tile is an empty tile
    if (realField![row][col] == 0) {
      blankTiles(row, col);
    } else {
      setState(() {
        openSquares![position] = true;
        squaresLeft = squaresLeft - 1;
      });
    }

    // Game win condition
    if (squaresLeft <= bombCount) {
      winCon();
    }
  }

  // When a tile is blank
  void blankTiles(int r, int c) {
    int position = (r * colSize) + c;
    openSquares![position] = true;
    squaresLeft = squaresLeft - 1;

    //Top
    if (r > 0) {
      check(r - 1, c);
    }

    //Bottom
    if (r < rowSize - 1) {
      check(r + 1, c);
    }

    //Left
    if (c > 0) {
      check(r, c - 1);
    }

    //Right
    if (c < colSize - 1) {
      check(r, c + 1);
    }

    //Top Left
    if (r > 0 && c > 0) {
      check(r - 1, c - 1);
    }

    //Top Right
    if (r > 0 && c < colSize - 1) {
      check(r - 1, c + 1);
    }

    //Bottom Left
    if (r < rowSize - 1 && c > 0) {
      check(r + 1, c - 1);
    }

    //Bottom Right
    if (r < rowSize - 1 && c < colSize - 1) {
      check(r + 1, c + 1);
    }

    setState(() {});
  }

  // Initializes the games and all boards/lists
  void initGame() {
    started = false;
    realField = List<List<int>>.generate(
        rowSize, (i) => List<int>.generate(colSize, (k) => 0));
    openSquares = List<bool>.generate(rowSize * colSize, (i) => false);
    flaggedSquares = List<bool>.generate(rowSize * colSize, (i) => false);
    bombCount = 0;
    squaresLeft = rowSize * colSize;
    initBombs();
    surroudingBombs();
    setState(() {});
  }

  // Initalized bombs for the realField
  void initBombs() {
    for (int r = 1; r < rowSize - 1; r++) {
      for (int c = 1; c < colSize - 1; c++) {
        if (Random().nextDouble() <= difficulty) {
          realField![r][c] = -1;
          bombCount++;
        }
      }
    }
  }

  // Increments the value of a tile depending on surrounding bombs
  void surroudingBombs() {
    for (int r = 1; r < rowSize - 1; r++) {
      for (int c = 1; c < colSize - 1; c++) {
        if (realField![r][c] == -1) {
          if (realField![r - 1][c - 1] != -1) {
            realField![r - 1][c - 1]++;
          }

          if (realField![r - 1][c] != -1) {
            realField![r - 1][c]++;
          }

          if (realField![r - 1][c + 1] != -1) {
            realField![r - 1][c + 1]++;
          }

          if (realField![r][c - 1] != -1) {
            realField![r][c - 1]++;
          }

          if (realField![r][c + 1] != -1) {
            realField![r][c + 1]++;
          }

          if (realField![r + 1][c - 1] != -1) {
            realField![r + 1][c - 1]++;
          }

          if (realField![r + 1][c] != -1) {
            realField![r + 1][c]++;
          }

          if (realField![r + 1][c + 1] != -1) {
            realField![r + 1][c + 1]++;
          }
        }
      }
    }
  }

  //Win Condition
  void winCon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content: const Text("Suprisingly you won!!!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                initGame();
                Navigator.pop(context);
              },
              child: const Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  //Lose Condition
  void LoseCon() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("L Bozo"),
          content: const Text("You stepped on a mine :("),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                initGame();
                Navigator.pop(context);
              },
              child: const Text("Play again"),
            ),
          ],
        );
      },
    );
  }
}

// Images by enum
Image getImage(Images type) {
  switch (type) {
    case Images.zero:
      return Image.asset('images/0.png');
    case Images.one:
      return Image.asset('images/1.png');
    case Images.two:
      return Image.asset('images/2.png');
    case Images.three:
      return Image.asset('images/3.png');
    case Images.four:
      return Image.asset('images/4.png');
    case Images.five:
      return Image.asset('images/5.png');
    case Images.six:
      return Image.asset('images/6.png');
    case Images.seven:
      return Image.asset('images/7.png');
    case Images.eight:
      return Image.asset('images/8.png');
    case Images.bomb:
      return Image.asset('images/bomb.png');
    case Images.facingdown:
      return Image.asset('images/facingdown.png');
    case Images.flagged:
      return Image.asset('images/flagged.png');
  }
}

Images getImageByNumber(int n) {
  switch (n) {
    case -1:
      return Images.bomb;
    case 0:
      return Images.zero;
    case 1:
      return Images.one;
    case 2:
      return Images.two;
    case 3:
      return Images.three;
    case 4:
      return Images.four;
    case 5:
      return Images.five;
    case 6:
      return Images.six;
    case 7:
      return Images.seven;
    case 8:
      return Images.eight;
  }
  return Images.eight; //Placeholder cause my code hates me.
}
