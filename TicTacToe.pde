String[][] board = {
    {"", "", ""},
    {"", "", ""},
    {"", "", ""}
};

float boardw;
float boardh;

String player = "X";
String ai = "O";
String currentPlayer = player;
boolean foundEndGame = false;
int cnt = 0;


void setup()
{
    size(400, 500);
    boardw = width;
    boardh = height - 100;
}

void draw()
{
    background(127);
    
    drawInfo();
    
    float w = boardw / 3;
    float h = boardh / 3;
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
        {
            float x = w * i + w / 2;
            float y = h * j + h / 2;
            String spot = board[i][j];
            strokeWeight(4);
            if (spot == player) // if character is X
            {
                stroke(255, 0, 0);
                float len = w / 4;
                line(x - len, y - len, x + len, y + len);
                line(x + len, y - len, x - len, y + len);
            }
            else if (spot == ai) // if character is O
            {
                stroke(0, 255, 0);
                noFill();
                ellipse(x, y, w / 2, w / 2);
            }
        }
        
}

boolean isValidToWin(PVector a, PVector b, PVector c)
{
    return board[(int)a.x][(int)a.y] == board[(int)b.x][(int)b.y] &&
           board[(int)a.x][(int)a.y] == board[(int)c.x][(int)c.y] && 
           board[(int)a.x][(int)a.y] != "";
}

boolean isEndGame()
{
    return cnt == 9 || isValidToWin(new PVector(0, 0), new PVector(0, 1), new PVector(0, 2)) ||
        isValidToWin(new PVector(1, 0), new PVector(1, 1), new PVector(1, 2)) ||
        isValidToWin(new PVector(2, 0), new PVector(2, 1), new PVector(2, 2)) ||
        isValidToWin(new PVector(0, 0), new PVector(1, 0), new PVector(2, 0)) ||
        isValidToWin(new PVector(0, 1), new PVector(1, 1), new PVector(2, 1)) ||
        isValidToWin(new PVector(0, 2), new PVector(1, 2), new PVector(2, 2)) ||
        isValidToWin(new PVector(0, 0), new PVector(1, 1), new PVector(2, 2)) ||
        isValidToWin(new PVector(0, 2), new PVector(1, 1), new PVector(2, 0));
}

void mousePressed()
{
    if (foundEndGame) 
    {
        exit();
        return; // it's ridiculous but needed
    }
    int x = mouseX / ((int) boardw / 3);
    int y = mouseY / ((int) boardh / 3);
    if (board[x][y] != "") // if player clicks on an occupied cell
        return;
    
    board[x][y] = currentPlayer;
    
    currentPlayer = player;
    
    cnt++;
    
    foundEndGame = isEndGame();
    
    if (!foundEndGame)
    {
        ai_move();
        foundEndGame = isEndGame();
    }
}

void drawInfo()
{
    // draw glow of pointed cell in grid
    int cellx = mouseX / ((int) boardw / 3);
    int celly = mouseY / ((int) boardh / 3);
    if (cellx < 3 && celly < 3)
    {
        fill(200);
        strokeWeight(0);
        rect((boardw / 3) * cellx, (boardh / 3) * celly, boardw / 3, boardh / 3);
    }
    
    // drawGrid
    strokeWeight(4);
    stroke(0);
    line(boardw / 3, 0, boardw / 3, boardh); 
    line(2 * boardw / 3, 0, 2 * boardw / 3, boardh);
    line(0, boardh / 3, boardw, boardh / 3);
    line(0, 2 * boardh / 3, boardw, 2 * boardh / 3);
    line(0, boardh, boardw, boardh);
    
    //text 
    if (cnt != 9)
    {
        if (!foundEndGame)
        {
            fill(0);
            textSize(50);
            textAlign(CENTER);
            text(currentPlayer + "'s Turn", boardw / 2, height - (height - boardh) / 2);
        } 
        else
        {
            fill(0);
            textSize(50);
            textAlign(CENTER);
            text((currentPlayer == "X" ? "O" : "X") + " won", boardw / 2, height - (height - boardh) / 2);  
            textSize(20);
            textAlign(CENTER);
            text("Click anywhere to exit the game", boardw / 2, height - (height - boardh - 50) / 2);
        }
    }
    else
    {
        fill(0);
        textSize(50);
        text("TIE", boardw / 2, height - (height - boardh) / 2);
        textSize(20);
        textAlign(CENTER);
        text("Click anywhere to exit the game", boardw / 2, height - (height - boardh - 50) / 2);
    }
}

void ai_move()
{
    if (cnt == 9)
        return;
    int bestScore = -1000000007;
    PVector move = new PVector();
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            if (board[i][j] == "")
            {
                board[i][j] = ai;
                int score = minimax(false, cnt + 1);
                board[i][j] = "";
                if (score > bestScore) 
                {
                    bestScore = score;
                    move = new PVector(i, j);
                }
            }
     board[(int) move.x][(int) move.y] = ai;
     cnt++;
     currentPlayer = player;
    
}

int minimax(boolean isMax, int count)
{
    if (count == 9)
        return 0;
    if (isEndGame())
        return isMax ? -10 : 10;
        
    int bestScore = isMax ? -1000000007 : 1000000007;
    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            if (board[i][j] == "")
            {
                board[i][j] = isMax ? ai : player;
                int score = minimax(!isMax, count + 1);
                board[i][j] = "";
                bestScore = isMax ? max(score, bestScore) : min(score, bestScore);
            }
    return bestScore;   
}    
