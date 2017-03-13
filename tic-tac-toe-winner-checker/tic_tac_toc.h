#include <stdbool.h>

// define BLANK as empty spots, X as player 1, O as player 2
#define BLANK 0
#define X     1
#define O     2

/* check_line is a helper function for the tic_tac_toe_winner function */
int check_line(int* start, int step, int n);

/* check if there is a winner for tic_tac_toe game */
int tic_tac_toe_winner(int n, int* board);

