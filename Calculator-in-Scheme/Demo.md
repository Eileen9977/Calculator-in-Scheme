# Calculator-in-Scheme Demo

-> a calculator that allows arithmetic calculations and functions definitions with if statements and while loops

-> the result of calculation would be stored in a stack; as long as the program is running the data stored in the stack would not be erased 

-> operands implemented based on the concepts provided by gForth

-> operands include  
" + "       add
" - "       subtract  
" * "       multiply
" . "       pop up the last inserted element in the stack
" .s "      print out the stack size and the whole stack
" = "       compare whether the top two elements in the stack are equal
" < "       compare whether the second top element is smaller than the top element in the stack: if true replace these two                             elements with -1, otherwise replace them with 0; example: 2 3 1 1 =   -->   2 3 -1  
" > "       compare whether the second top element is bigger than the top element in the stack: if true replace these two                             elements with -1, otherwise replace them with 0;
" dup "     duplicate the top element in the stack; example: 1 2 3 dup   -->    1 2 3 3 
                     
