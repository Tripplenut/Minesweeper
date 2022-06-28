
# Step By Step

This readme is where I detail my entire development process of making Minesweeper.

## Languages

### [Dart](https://dart.dev/) - [Docs](https://dart.dev/guides)

The language I need to use so I can develop this is [Flutter](#Flutter). I mean I don’t have an option with what language I'm allowed to use since I decided to use Flutter. Flutter exclusively uses Dart, but the nice thing about that is its similarity to Java. Many things are more straightforward than Java, and most syntax remains the same. They even have some features I wish were in Java-like automatic casing where a variable is declared as a type on runtime given the input (c++ does this but worse) and optional parameters. Once you know one language in-depth, learning others is much easier, but since there is that similarity, it makes learning much more manageable. I assume most of my time will be spent trying to learn how to make minesweeper work. That brings me to [Concept](#Concept) where I discuss designing and developing minesweeper.

  

## Frameworks

### [Flutter](https://flutter.dev/) - [Docs](https://docs.flutter.dev/)

Flutter is an excellent frontend UI framework I can use to create and build the game on multiple platforms. If I write the code once, I can play the game on android phones, apple phones, mac machines, windows machines, and even linux. I will limit my builds to mobile devices only as it only seems fitting for a game like Minesweeper. Also, Flutter's performance on computers is questionable as it is built around mobile development, so the websites look like an android emulated app. For example, the google play store is made with flutter, so it looks nice on android but horrible on the [web](https://play.google.com/work).

Flutter wasn’t my first choice but instead, Ionic as I could have picked up html, css, and javascript while creating the game, which I wanted to do at first. I then realized that since the game will be on mobile devices, I needed to use the framework best for that sort of development. While learning specific programming languages is nice to throw on a resume or something like that, I find it more beneficial to work on projects of all sorts, so you never trap yourself in a box, both knowledge, and language-wise. When I eventually make a website, I can learn html, css, and javascript, but as of right now, Dart is where I’m at.

## Concept

### Java?

So when I initially began planning how I wanted to do this I realized that trying to code everything in only [dart](#Dart) would be horrible and inefficient. So I had this bright idea to instead stick to a language I’m good at like java so I could get the algorithm/code down for the game and then translate that over to Dart for when I start to implement the UI.
