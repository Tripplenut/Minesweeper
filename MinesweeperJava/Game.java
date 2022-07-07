/**
 * Where the game is run
 */
public class Game {
    private int rowSize = 16;
    private int colSize = 9;
    private double difficulty = .15;

    /** The field the game is being played on */
    int[][] realField = new int[rowSize+4][colSize+4];
    /** The field the player can see*/
    char[][] playerField = new char[rowSize][colSize];

    private int totalTiles = rowSize*colSize; //Used for win condition
    int totalBombs = 0; //Set from Field.


    /**
     * Creates a new game of minesweeper
     * @param difficulty A whole number input between 10 and 25. 15 is set to default if param is not met.
     */
    public Game(int difficulty){//Use default params when transitioning to dart
        if(25>=difficulty&& difficulty>=10)
            this.difficulty = (double) difficulty/100;
        start();
        Field.printField(realField);
        Field.printField(playerField);
    }

    /**
     * Initializes reaField and playerField when the Game is first created
     */
    public void start(){
        Field.realFieldInit(realField, difficulty);
        Field.playerFieldInit(playerField);
        firstClick(8,4);// test
        totalBombs = Field.checkForBombs(realField);
        check(8,4);// test
    }

    /**
     * The special first click mechanics of the game.
     * @Description It can branch off 2 ways. It plays out regularly as the spot selected is neither a bomb or near one.
     * The other being the spot is a bomb or near one so all the bombs get moved to the top left corner.
     * @param x The row of the first click
     * @param y The column of the first click
     */
    public void firstClick(int r, int c){
        int surroundingBombs = 0;
        if(realField[r+1][c+1]==-1){ // Top left
            surroundingBombs++;
            realField[r+1][c+2] = 0;
        }
        if(realField[r+1][c+2]==-1){ // Top middle
            surroundingBombs++;
            realField[r+1][c+2] = 0;
        }
        if(realField[r+1][c+3]==-1){ // Top right
            surroundingBombs++;
            realField[r+1][c+3] = 0;
        }
        if(realField[r+2][c+1]==-1){ // Left middle
            surroundingBombs++;
            realField[r+2][c+1] = 0;
        }
        if(realField[r+2][c+2]==-1){ // Click pos (middle)
            surroundingBombs++;
            realField[r+2][c+2] = 0;
        }
        if(realField[r+2][c+3]==-1){ // Right middle
            surroundingBombs++;
            realField[r+2][c+3] = 0;
        }
        if(realField[r+3][c+1]==-1){ // Bottom left
            surroundingBombs++;
            realField[r+3][c+1] = 0;
        }
        if(realField[r+3][c+2]==-1){ // Bottom middle
            surroundingBombs++;
            realField[r+3][c+2] = 0;
        }
        if(realField[r+3][c+3]==-1){ // Bottom right
            surroundingBombs++;
            realField[r+3][c+3] = 0;
        }
        Field.extraBombs(realField,surroundingBombs,r,c);
    }

    /**
     * Checks the indicated spot of the playerField
     * @param row row of playeField board being checked
     * @param col column of playerField board being checked
     * @return Sometimes returns a valuable string
     */
    public String check(int row, int col){
        //Already Selected
        if(playerField[row][col]!='#')
            return "Already Selected";//TODO: Call function to make user select again or do this in an outside function

        // Bomb
        if(realField[row+2][col+2]==-1){
            playerField[row][col] = '@';
            return "You lose!"; //TODO: Make a function so game ends
        }
        
        // Numbers or blank
        playerField[row][col] = (char)(realField[row+2][col+2]+48); // the 48 is to get the int value to its char equivalent
        totalTiles--; //this works
        if(playerField[row][col]=='0')
            blankTiles(row, col);

        // If statement for game win condition
        if(totalTiles<=totalBombs)
            return "You win!"; //TODO: Make a function so it stops the game
        return "";
    }

    /**
     * A helper method for the {@link #check(int row, int col) check} function
     * @param row row of the blank spot on the playerField
     * @param col column of the blank spot on the playerField
     * @return An integer just so it stops if the first condition is false.
     */
    public int blankTiles(int row, int col){
        if(row+2>playerField.length||row+1<2
            ||col+2>playerField[0].length||col+1<2)
            return 0;
        if(playerField[row-1][col-1]=='#') // Top left
            check(row-1, col-1);
        if(playerField[row-1][col]=='#') // Top middle
            check(row-1,col);
        if(playerField[row-1][col+1]=='#') // Top right
            check(row-1, col+1);
        if(playerField[row][col-1]=='#') // Left
            check(row,col-1);
        if(playerField[row][col+1]=='#') // Right
            check(row,col+1);
        if(playerField[row+1][col-1]=='#') // Bottom left
            check(row+1,col-1);
        if(playerField[row+1][col]=='#') // Bottom middle
            check(row+1,col);
        if(playerField[row+1][col+1]=='#') // Bottom right 
            check(row+1,col+1);
        return 0;
    }
}
