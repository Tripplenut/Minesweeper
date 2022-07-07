public class Main{
    public static void main(String[] args) {
        Game game = new Game(15);
        game.check(1, 1);
        Field.printField(game.playerField);
    }
}