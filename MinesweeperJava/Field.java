/**
 * This is a class that holds all the static methods for both real fields and player fields
 * It is split up accordingly, with real field methods then the player field equivalent(if there is one) below it
*/
public class Field {

    /**
     * Initialized Real field matrix 
     * @param realField Real mine field matrix in the game
     */
    public static void realFieldInit(int[][] realField, double difficulty){
        // Randomizes bombs on the real field
        for(int r=2; r<realField.length-2; r++){
            for(int c=2; c<realField[r].length-2; c++){
                realField[r][c] = (Math.random()<difficulty)?-1:0;
            }
        }
    }

    /**
     * Initializes Player field matrix
     * @param playerField Player mine field matrix in the game
     */
    public static void playerFieldInit(char[][] playerField){
        for(int r=0; r<playerField.length ;r++){
            for(int c=0; c<playerField[r].length; c++){
                playerField[r][c] = '#';
            }
        }
    }


    /**
     * Print Field Method for the realField
     * @param realField Real mine field matrix in the game
     */
    public static void printField(int[][] realField){
        for(int r=2; r<realField.length-2; r++){
            for(int c=2; c<realField[r].length-2; c++){
                //System.out.print(realField[r][c]+" ");
                System.out.printf("%-4s ", realField[r][c]);
            }
            System.out.println("\n");
        }
    }

    /**
     * Prints Field Method for the playerField
     * @param playerField Player field matrix in the game
     */
    public static void printField(char[][] playerField){
        for(int r=0; r<playerField.length; r++){
            for(int c=0; c<playerField[r].length; c++){
                System.out.printf("%-4s ",playerField[r][c]);
            }
            System.out.println("\n");
        }
    }

    /**
     * Increases the numerical value for tiles adjacent to bombs
     * @param realField Real field matrix in the game
     * @return Total amount of bombs for {@link Game#totalBombs total bombs} in game
     */
    public static int checkForBombs(int[][] realField){
        int total = 0;
        // Marks non bomb spots with the surrounding
        for(int r=2; r<realField.length-2; r++){
            for(int c=2; c<realField[r].length-2; c++){
                if(realField[r][c]==-1){
                    total++;
                    if(realField[r-1][c-1]!=-1) //Top Left
                        realField[r-1][c-1]++;
                    
                    if(realField[r-1][c]!=-1) //Top Middle
                        realField[r-1][c]++;
                    
                    if(realField[r-1][c+1]!=-1) //Top Right
                        realField[r-1][c+1]++;
                    
                    if(realField[r][c-1]!=-1) //Middle Left
                        realField[r][c-1]++;
                    
                    if(realField[r][c+1]!=-1) //Middle Right
                        realField[r][c+1]++;
                    
                    if(realField[r+1][c-1]!=-1) //Bottom Left
                        realField[r+1][c-1]++;
                    
                    if(realField[r+1][c]!=-1) //Bottom Middle
                        realField[r+1][c]++;
                    
                    if(realField[r+1][c+1]!=-1) //Bottom Right
                        realField[r+1][c+1]++;
                }
            }
        }
        return total;
    }
    
    //* This works but not really, In some cases Game.firstClick will won't be a blank space
    /**
     * Adds extra bombs after {@link Game#firstClick(int r, int c) first click} is run
     * @param realField Real field matrix in the game
     * @param num Number of excess surrounding bombs.
     */
    public static void extraBombs(int[][] realField, int num, int row, int col){
        for(int i=0; i<num; i++){
            for(int r=2; r<realField.length-2; r++){
                for(int c=2; c<realField[r].length-2; c++){
                    if(Math.random()<.1 && realField[r][c]!=0){
                        realField[r][c] = -1; 
                        num--;
                    }
                    if(num==0)
                        continue;
                }
                if(num==0)
                    continue;
            }
        }
    }

}
