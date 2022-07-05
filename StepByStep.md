
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

Update: Most of this was thought over and explained in [5/18/22](#51822). While the idea is still applied the same way, it is no longer “recursive” in a sense that the function is calling itself, but now blank tiles is a helper function to make [checking](#Checking) recursive.

 

### Fog Of War

Fog of war is a German concept about uncertainty in war and how you never know your opponent’s next move. It shows up a lot in 4x, grand, turn-based, and real-time strategy games. In games, the fog of war option essentially hides all things you don’t know for sure. So let’s say there is an enemy behind a wall. With the fog of war off, you would see the enemy, but with it on, that area may be gray, and you would not know what is behind the wall. To the game, there is an enemy behind it, but from your perspective, there is nothing. This is the same in minesweeper, and this even relates to [fields](#Fields) and how there is a player field and a real field. The importance of this is no code is being run each time the player checks a spot. That spot is not searched for surrounding bombs; it only checks if the spot is a bomb or not. If it is a bomb, the game will end, but if not, it just shows what the tile value is. So just like checking if an enemy is behind a wall, all the player is doing is revealing what they can not see.

### First Click

In minesweeper, the first click is never a bomb. Since the fields are made when the game is initialized, you never know where the person will click. If the player ends up clicking on a bomb, then you need to get rid of that bomb and move it to the [top left corner](https://web.archive.org/web/20180618103640/http://www.techuser.net/mineclick.html). There may be a bug if the bomb is in the top right corner, but the chances of that are low; worst comes to worst just guarantee a bomb never spawns there. Some games of minesweeper like the one by google or dustland design guarantee that the first click isn’t a bomb or next to a bomb. To make this the case, you would need to check the player square and all the adjacent ones as well.

  

### Checking

This is when you click a tile on the playerField. In theory, this is really simple as you are just showing what is on the screen (this is explained more in [Fog of war](#Fog-of-War)), but in reality, there are a bunch of cases that need to be accounted for. The list of these cases is: game-winning conditions, game-losing conditions, the spot is already selected, it’s a [blank space](#Blank-Tiles), or if it’s just a number. A plain number is the simplest as I just set that spot in the playerField to the realFields equivalent. Lose conditions are when the player clicks a bomb. Win conditions are when the total available tiles are less than or equal to the number of bombs. Spot already selected makes you choose another move. Then blank space is the hardest. For a full explanation of what it is and how I expect to implement it check [blank space](#Blank-Tiles).



## Day to Day

This is where I go over what I contribute to the project daily.

### 5/9/22

Making minesweeper is a lot harder than I expected, but by following this [implementation guide](https://www.geeksforgeeks.org/cpp-implementation-minesweeper-game/) from the great [Geeks4Geeks](https://www.geeksforgeeks.org/) (aka the best online resource for learning anything programming related) and using my logic to figure out how the game works, I realized that it wasn’t half bad. I could whip up some starting code in half an hour that randomized the mines (although it wasn’t consistent with the amount) and printed both a playerfield and a minefield. I need to get down the input, checking and marking mines and the win and lose cases, and it’s done. So essentially, I have to actually write the game, translate it to dart, add a UI using flutter, then figure out how to port that to apple and android devices. Even better, throw it on the play store and add experienced Flutter, Dart, and Java Developer to my resume. This is my gateway to a MAANG position where I’ll be making 300k a year copy and pasting StackOverflow responses into the company codebase.

  

### 5/10/22

Today I refactored my code into multiple files, so I don’t just have one big code dump in one file. I also decided to create a separate file just for static methods that will be used by the fields, as it would be easy to see all the functions relating to the fields. Aside from the tedious code I wrote, I also realized the fog of war style of the game minesweeper and how it makes it so much easier to make the game play out. I go over this concept in [Fog Of War](#Fog-Of-War).

  

### 5/11/22

Worked on [first click mechanics](#First-Click). I also decided that having a border length of 2 on each side instead of 1 would be more beneficial as the first click could guarantee that it is not a bomb or next to a bomb.

  

### 5/16/22

Finished up the first click mechanics. It was a lot harder to pull off than it was to write. The problem was that I had to check all the surrounding tiles around the click. Then I had to write a separate function to put the bombs taken out back into the game. Then I ran into a bug where the point you would click would be filled with bombs again because of the way I made the function that puts them back into the game. Instead of trying to block off that 3x3 area (the click and adjacent), I instead made it so bombs would only be added to the adjacent tiles of existing bombs.


### 5/17/22

Started working on [checking](#Checking) for the playerfield. It was pretty simple as the test cases for checking are like five things. Still need to do one more case, but it involves calling multiple other checks like in [blank tiles](Blank-Tiles).

  

### 5/18/22

Worked on [blank tiles](#Blank-Tiles) today, but I realized It doesn’t even need to be recursive. Instead, I will use the [check function](#Checking) and have a specific case (when the realField equivalent is equal to zero) and have it call another “check” but at all the adjacent positions. This makes sense as if the selected tile is a “0,” meaning it has no bombs around it; it just checks all the adjacent tiles. In the sample code I had in blank tiles, I failed to realize this as I only checked left, right, top, and bottom. The final code I ended up with for blank tiles is on the right. I had to put if statements to make sure I was not returning back to a previously checked tile because I was not in the mood for stack overflow errors. The first if statement is to make sure the calls don’t expand out to the border.

![](https://lh6.googleusercontent.com/8wNeYuw2t3zTBwiwhfTn64pVnwABhW8hWrhlSrubpv0CsIYamqgBtX3LDPRbBjX6yFnHAA7jl3SkfYM5HYsUUP-jF8rFIBdRHWoVCDpzColgSvUtYR6m5Nwe1UMvC7J6N_xys7FTAo9twFuL_w)


### 5/19/22

I spent my time bug fixing and implementing yesterday's ideas. I think I am done doing all I can in java, so tomorrow, I will begin developing the app using [flutter](#Flutter---Docs) and [dart](#Dart---Docs). Learning how to make the game look nice using flutter won't be too much of a hassle, but I am just scared about implementing the tiles and making them all functioning buttons. I believe that once I get past that point, it will be smooth sailing for the rest of the project.


### 5/25/22

I spent the 5/20-5/23 setting up flutter for three days cause I can't read docs. I spent 5/24 mentally preparing for the pain I had to endure today. So to begin, I watched some videos on the [official flutter youtube](https://www.youtube.com/c/flutterdev). It was informative since I had no clue what a widget is or how even to get the app running. Found this sick online tutorial on grids so I could make the board. Using these two resources, I was able to make the app title bar and a grid that wasn't the correct size. Yeah, I know, simply a programming prodigy.


### 6/2/22

For the past week, I haven't touched a dart, let alone a compiler. I was getting back into the project as I wanted it to be done by next Friday. Trying to understand the code I have already written is a pain. The grid is still the incorrect size, and I have no idea how to fix it; praying it will fix itself, but other than that, I just "translated" my java code over to dart for the game initialization. I don't even need a playerField grid as it is just where the person clicks, but I needed to add a list booleans to keep track of open squares and another list for what's flagged and what isn't.


### 6/3/22 - 6/7/22

I forgot how painful it is to update the docs on this process. I'm starting to see why the first docs of a project are always super in-depth, but by the time you get to the newer features, they end up being a sentence long that no one but the person who wrote the code could understand. Anyways I made a lot of progress. I was able to get images to appear so when you click a tile, it can be blank, show numbers 1-8, or be flagged or untouched. It is also linked to the realField along with two arrays of opened and flagged squares. I'm running into a problem with the [blank tiles](#Blank-Tiles) which is a pain.


### 6/8/22 - 6/9/22

I was able to fix the blank tiles after realizing I named one of my variables incorrectly. It doesn't completely work as it either opens all the 0 tiles only or opens every single tile that isn't a bomb (made it easy to check to win conditions :3 ). I've been thinking of how to fix that, and I realized the best way to get it done is by making the tile click a separate function as I did in the java version.


### 6/12/22

I implemented what I said on 6/8/22 for checking, and it worked. I turned the tap function of the game into a check function much like [check](#Checking). I don't know why I didn't do this to begin with, but now the blank tiles works as expected. I have completed the majority of the game at this point. I have the win and lose conditions down. The blank tiles and checking functions are down. I really just have to make first-click mechanics, which should be simple, and I also need to port this onto the google play store. I definitely won't log any of that because it was already a pain to convince myself to log this.


## Post Project Thoughts

I realized I should have used a vcs, to begin with, to keep track of all my progress to go along with this massive file instead of just committing it all together at once. I also left out a lot of information as I was going, as it felt like even more of a burden to type all this out as I completed the project. I think using GitHub and describing what I was doing with each commit and then pasting the descriptions with the commit numbers would have been better. Well, now I know for the future. When it comes to this project, I learned a lot of valuable lessons. Time management, breaking down problems to the point where kindergarteners can understand them, and most importantly, writing clean, efficient, and commented code. I don't know if what I did is even close to commercial grade or what works as an actual software developer is like I enjoyed, so hopefully, it is.
