#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "code.h"

int cur_counter = 0;
int cur_scope = 0;
int local_num = 0;
int function_idx = -1;
FILE *f_asm;

void start(){
   for (int i=0;i<MAX_TABLE_SIZE;i++){
      table[i].name = NULL;
   }
}

int look_up_symbols(char *s){
   int i;
   if (cur_counter==0) return(-1);
   for (i = cur_counter-1;i>=0; i--){
      if (!strcmp(s,table[i].name))
      return(i);
   }
   return(-1);
}

void set_global_vars(char *s){
   if(look_up_symbols(s)!=-1){
      return;
   }
   table[cur_counter].scope = cur_scope;
   table[cur_counter].name = malloc(sizeof(char)*(strlen(s)+1));
   strcpy(table[cur_counter].name,s);
   table[cur_counter].mode = GLOBAL_MODE;
   cur_counter++;
}

void set_parameters(char *s,int type){
   table[cur_counter].name = malloc(sizeof(char)*(strlen(s)+1));
   strcpy(table[cur_counter].name,s);
   table[cur_counter].type = type;
   cur_counter++;
}

void set_local_vars(char *s){
   table[cur_counter].scope = cur_scope;
   table[cur_counter].name = malloc(sizeof(char)*(strlen(s)+1));
   strcpy(table[cur_counter].name,s);
   table[cur_counter].mode = LOCAL_MODE;
   table[cur_counter].offset = local_num;
   table[cur_counter].functor_index = function_idx;
   cur_counter++;
}

void set_local_array(char *s,int size){
   table[cur_counter].scope = cur_scope;
   table[cur_counter].name = malloc(sizeof(char)*(strlen(s)+1));
   strcpy(table[cur_counter].name,s);
   table[cur_counter].mode = LOCAL_MODE;
   table[cur_counter].offset = local_num;
   table[cur_counter].functor_index = function_idx;
   table[cur_counter].type = T_ARRAY;
   cur_counter++;
   for(int i=0;i<size;i++){
      table[cur_counter].scope = cur_scope;
      table[cur_counter].mode = LOCAL_MODE;
      table[cur_counter].name = malloc(sizeof(char)*(4+1));
      strcpy(table[cur_counter].name,"NULL");
      table[cur_counter].offset = local_num+i+1;
      table[cur_counter].functor_index = function_idx;
      cur_counter++;
   }
}

void pop_up_symbol(int scope){
   int i;
   if (cur_counter==0) return;
   for (i=cur_counter-1;i>=0; i--){
      if (table[i].scope !=scope) break;
      fprintf(f_asm," addi sp,sp,4\n");
      if(local_num>0)local_num--;
   }
   if (i<0) cur_counter = 0;
   cur_counter = i+1;
}

void break_loop(int scope){
   int i;
   if (cur_counter==0) return;
   for (i=cur_counter-1;i>=0; i--){
      if (table[i].scope !=scope) break;
      fprintf(f_asm," addi sp,sp,4\n");
   }
}

void set_scope_and_offset_of_param(char *s,int arg_num){
   int i,j,index;
   int total_args;
   index = look_up_symbols(s);
   //if (index<0) err("Error in function header");
   //else {
   table[index].type = T_FUNCTION;
   total_args = arg_num;
   table[index].total_args=total_args;
   for (j=total_args, i=cur_counter-1;j>0; i--,j--){
      table[i].scope= cur_scope;
      table[i].offset= j;
      table[i].mode = ARGUMENT_MODE;
      table[i].functor_index = function_idx;
   }
   //}
}

void free_table(){
   for (int i=0;i<MAX_TABLE_SIZE;i++){
      if(table[i].name!=NULL){
         free(table[i].name);
      }
   }
}

