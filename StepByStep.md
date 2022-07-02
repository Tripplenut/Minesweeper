
# Step By Step

This readme is where I detail my entire development process of making Minesweeper.


## Languages

### [Dart](https://dart.dev/) - [Docs](https://dart.dev/guides)

The language I need to use so I can develop this is [Flutter](#Flutter---Docs). I mean, I don’t have an option with what language I'm allowed to use since I decided to use Flutter. Flutter exclusively uses Dart, but the nice thing about that is its similarity to Java. Many things are more straightforward than Java, and most syntax remains the same. They even have some features I wish were in Java-like automatic casing where a variable is declared as a type on runtime given the input (c++ does this but worse) and optional parameters. Once you know one language in-depth, learning others is much easier, but since there is that similarity, it makes learning much more manageable. I assume most of my time will be spent trying to learn how to make minesweeper work. That brings me to [Concept](#Concept) where I discuss designing and developing minesweeper.


## Frameworks

### [Flutter](https://flutter.dev/) - [Docs](https://docs.flutter.dev/)

Flutter is an excellent frontend UI framework I can use to create and build the game on multiple platforms. If I write the code once, I can play the game on android phones, apple phones, mac machines, windows machines, and even linux. I will limit my builds to mobile devices only as it only seems fitting for a game like Minesweeper. Also, Flutter's performance on computers is questionable as it is built around mobile development, so the websites look like an android emulated app. For example, the google play store is made with flutter, so it looks nice on android but horrible on the [web](https://play.google.com/work).

Flutter wasn’t my first choice but instead, Ionic as I could have picked up html, css, and javascript while creating the game, which I wanted to do at first. I then realized that since the game will be on mobile devices, I needed to use the framework best for that sort of development. While learning specific programming languages is nice to throw on a resume or something like that, I find it more beneficial to work on projects of all sorts, so you never trap yourself in a box, both knowledge, and language-wise. When I eventually make a website, I can learn html, css, and javascript, but as of right now, Dart is where I’m at.


## Concept

### Java?

So when I initially began planning how I wanted to do this I realized that trying to code everything in only [dart](#Dart---Docs) would be horrible and inefficient. So I had this bright idea to instead stick to a language I’m good at like java so I could get the algorithm/code down for the game and then translate that over to Dart for when I start to implement the UI.


### Fields

Minesweeper requires two types of boards. A player board that showcases the player’s moves, then a real board that indicates where the bombs are. At first, I was going to just create these two and add functions that calculated the bombs surrounding a tile every time a tile is clicked. I realized that it would be more efficient than when I initialize the real field of mines, I would do a second iteration, and every time a bomb was found, increment the surrounding tiles by one if they were not a bomb. I also realized that corners would be a pain with the extra if statements, so I decided it would be better if the real minefield was two tiles larger (changed to 4 due to [first click](#First-Click)) than the players, so these extra statements could be avoided. Check the diagram below to understand what I’m saying.

This keeps the playing field the same, but now on the real board, I can check all adjacent tiles without having to worry about being on a corner or side. The only problem is that I need to adjust all real board arrays for this displacement; each row/col should start at one and end one before the length of the row/col.

![](https://lh6.googleusercontent.com/cV4M9KPwl-IhyQavcLgJAwZktcGBg5F-AWbj1xylYEQC81OzT7idYjWGMkRrv7EsORIRZajyCzBElnpMqg0kiBjoXeRV8InEy-VGmWRX1Dv0BVNeXHwj9WoAVhwmHpnbTDa3ZZEFJXBT5rGcnA)


### Blank Tiles

When you play minesweeper, there are plenty of times where the spot you click on has no bombs around it, and this is probably the same as the times around that one. I need an algorithm that can get rid of these extra tiles where no bomb is found and not mess up the game. That is where I bring in my worst enemy… Recursion. Here is some potential code.

![](https://lh4.googleusercontent.com/B1wwA1lJclz8Xgy188RcmCOI-NeuESAUNDk8EfaQlrlwS395cf7r7wAXJsTayPJ0Fi4yvu4UGn3xr6WRR37x3UfHgIAqovkuzt1ldKLUBahRTHawH5EO1p8xtZKxchAECAU9QAdGKQ7wvdpUBA) 

So if the current position of realField is 0, it makes the playerfield change it to blank and checks the surrounding tiles. When a non 0 is found, it automatically stops that recursive statement but still shows that number. I also need to make the function stop when it is at the border.

Update: Most of this was thought over and explained in [5/18/22](add-later). While the idea is still applied the same way, it is no longer “recursive” in a sense that the function is calling itself, but now blank tiles is a helper function to make [checking](#Checking) recursive.

 

### Fog Of War

Fog of war is a German concept about uncertainty in war and how you never know your opponent’s next move. It shows up a lot in 4x, grand, turn-based, and real-time strategy games. In games, the fog of war option essentially hides all things you don’t know for sure. So let’s say there is an enemy behind a wall. With the fog of war off, you would see the enemy, but with it on, that area may be gray, and you would not know what is behind the wall. To the game, there is an enemy behind it, but from your perspective, there is nothing. This is the same in minesweeper, and this even relates to [fields](#Fields) and how there is a player field and a real field. The importance of this is no code is being run each time the player checks a spot. That spot is not searched for surrounding bombs; it only checks if the spot is a bomb or not. If it is a bomb, the game will end, but if not, it just shows what the tile value is. So just like checking if an enemy is behind a wall, all the player is doing is revealing what they can not see.

### First Click

In minesweeper, the first click is never a bomb. Since the fields are made when the game is initialized, you never know where the person will click. If the player ends up clicking on a bomb, then you need to get rid of that bomb and move it to the [top left corner](https://web.archive.org/web/20180618103640/http://www.techuser.net/mineclick.html). There may be a bug if the bomb is in the top right corner, but the chances of that are low; worst comes to worst just guarantee a bomb never spawns there. Some games of minesweeper like the one by google or dustland design guarantee that the first click isn’t a bomb or next to a bomb. To make this the case, you would need to check the player square and all the adjacent ones as well.

  

### Checking

This is when you click a tile on the playerField. In theory, this is really simple as you are just showing what is on the screen (this is explained more in [Fog of war](#Fog-of-War)), but in reality, there are a bunch of cases that need to be accounted for. The list of these cases is: game-winning conditions, game-losing conditions, the spot is already selected, it’s a [blank space](#Blank-Tiles), or if it’s just a number. A plain number is the simplest as I just set that spot in the playerField to the realFields equivalent. Lose conditions are when the player clicks a bomb. Win conditions are when the total available tiles are less than or equal to the number of bombs. Spot already selected makes you choose another move. Then blank space is the hardest. For a full explanation of what it is and how I expect to implement it check [blank space](#Blank-Tiles).
