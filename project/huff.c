#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include "forest.h"
#include "forest_node.h"
#include "huff_tree_node.h"
#include "llist_node.h"
#include "llist.h"
// get the frequency for each char in the input file
int* make_freq_table(char* filename){
  FILE* file = fopen(filename,"r");
  if(!file){
    printf("Cannot open file.\n");
    return NULL;
  }
  int* freq_table = malloc(sizeof(int) * 256);
  for (int i = 0; i < 256; i ++) {
    freq_table[i] = 0;
  }
  while(!feof(file)) {
    int c = fgetc(file);
    if(c > 0) {
      freq_table[c]++;
    }
  }
  return freq_table;
}

// get the maximum frequency in the frequency table
int getMaxFreq (int* freqtable) {
  int max = 0;
  for (int i = 0; i < 256; i ++) {
    if (freqtable[i] > max) {
      max = freqtable[i];
    }
  }
  return max;
}

// make the forest
forest* makeForest(forest* f, int* ftable) {
  int freq = 1;
  int max = getMaxFreq(ftable);
  while(freq < max + 1) {
    for (int i = 0; i < 256; i ++){
      if (ftable[i] == freq) {
        huff_tree_node* hnew = new_node(i, freq);
        forest_node* fnew = new_fnode(hnew);
        insert_after(f, fnew);
      }
    }
    freq ++;
  }
  return f;
}

huff_tree_node* makeTree(forest* f) {
  huff_tree_node* head = new_node(0, 0);
  int count = -1;
  while(f->size > 1) {
    int f1 = f->head->val->freq;
    int f2 = f->head->next->val->freq;
    head = new_node(count, f1 + f2);
    head->left = f->head->val;
    head->right = f->head->next->val;
    count --;
    forest_node* result = new_fnode(head);
    f = ordInsert(f, result);
    pop(f);
    pop(f);
  }
  return head;
}


// get the code for each char
llist* get_code(llist* l, huff_tree_node* root, int c){
  if(root){
    if(c == root->left->ch || c == root->right->ch){
      if(c == root->left->ch){
        l = llist_add(l,0);
      }else{
        l = llist_add(l,1);
      }
    }else{
      if(root->left->ch < 0){
        l = llist_add(l,0);
        l = get_code(l, root->left, c);
      }else{
        l = llist_add(l,1);
        l = get_code(l, root->right, c);
      }
    }
  }
  return l;
}

// put the ecode for each char in the array
llist* make_huff_table(int* freqtable, huff_tree_node* ht){
  llist* l = malloc(sizeof(llist)*256);
  for(int i=0; i<256; i++){
    llist* temp = new_llist();
    if(freqtable[i] == 0){
      l[i] = *temp;
    }else{
      l[i] = *(get_code(temp, ht, i));
    }
    free(temp);
  }
  return l;
}

int main(int argc, char** argv) {
  if(argc < 3) {
    printf("Expecting more arguments!\n");
  }
  int* freqTable;
  freqTable = make_freq_table(argv[1]);

  if(!freqTable) {
    printf("read file failed! :( \n");
    exit(0);
  }
  forest* forest = makeForest(new_forest(NULL), freqTable);
  huff_tree_node* htree = makeTree(forest);
  llist* huffTable = make_huff_table(freqTable, htree);
  FILE* orifile = fopen(argv[1],"r");
  FILE* newfile = fopen(argv[2], "w");
  if(!orifile){
    printf("cannot open file \n");
    exit(0);
  }
  int c = 1;
  int count = 0;
  llist* result = new_llist();
  while((c = fgetc(orifile)) > 0){
    llist* temp = &huffTable[c];
    result = llist_append(result,temp);
  }
  int bit_number = 0;
  if(result->size % 4 ==0){
    bit_number = result->size/4;
  }else{
    bit_number = result->size/4+1;
    for(int i =0; i <bit_number*4-result->size;i++){
      result = llist_add(result,0);
    }
  }
  char encode [bit_number];
  llist_node* temp = result->head;
  int i = 0;
  while(temp){
    int hexsum = 0;
    for(int j = 0; j < 4; j++){
      hexsum = hexsum * 2 + temp->data;
      temp = temp->next;
    }
    if(hexsum == 10)  {
      encode[i] = 'A';
    } else if (hexsum ==11) {
      encode[i] = 'B';
    } else if (hexsum == 12) {
      encode[i] = 'C';
    } else if (hexsum == 13) {
      encode[i] = 'D';
    } else if (hexsum == 14) {
      encode[i] = 'E';
    } else if (hexsum == 15) {
      encode[i] = 'F';
    }else {
      encode[i] = hexsum + 48;
    }
    i ++;
  }
  for(int i = 0; i < 256; i++) {
    fprintf(newfile, "%d", *(freqTable+i));
  }
  for(int i = 0; i<bit_number; i++){
    fprintf(newfile,"%c",*(encode+i));
  }
  fclose(newfile);
  // free all the stuff
  for (int i = 0; i < 256; i++) {
    llist_node_free(huffTable[i].head);
  }
  free(huffTable);
  free_huff_tree(htree);
  forest_node_free(forest->head);
  free(forest);
  free(freqTable);
  llist_node_free(result->head);
  free(result);
  return 0;
}
