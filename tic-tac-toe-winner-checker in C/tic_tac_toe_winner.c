#include <stdlib.h>
#include <stdio.h>
#include "tic_tac_toe.h"

/* check_line function checks winners beginning from 'start', checks 'n' consecutive spots on the board,
   with 'step' number of spots between each, to see whether these n spots contains the same elements, 
   if so, return the elements, X or O;
   otherwise, return BLANK
*/

int check_line(int* start, int step, int n)
{
  int counterX = 0;
  int counterO = 0;
  int* i = start;
  for (int j = 0; j < n; j ++) {
    if (*i == BLANK) {
      return BLANK;
    } else if (*i == X) {
      counterX ++;
      if(counterX == n) {
        return X;
      }
    } else if (*i == O) {
      counterO ++;
      if(counterO == n) {
        return O;
      }
    }
    i += step;
  }
  return BLANK;
}

/* the variable 'board' points to an array contains at least n ^ 2 ints by default;
   return BLANK if there is no winners
   otherwise return the winner, X or O */
int tic_tac_toe_winner(int n, int* board)
{
  int result;
  //processing rows;
  for (int* i = board; i < board + n * n; i += n) {
    result = check_line(i, 1, n);
    if (result != BLANK) {
      return result;
    }
  }
  //processing columns
  for (int* i = &board[0]; i < &board[n]; i ++) {
    result = check_line(i, n, n);
    if (result != BLANK) {
      return result;
    }
  }
  //processing main diagonals 
  result = check_line(board, n + 1, n);
  if (result != BLANK) {
    return result;
  }
  result = check_line(&board[n - 1], n - 1,n); 
  return result;
}
