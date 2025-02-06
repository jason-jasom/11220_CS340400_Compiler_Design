%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "code.h"
    int yylex();
    int arg_num = 0;
    int end_num = 0;
    int end_counter = 0;
    enum END_TYPE{T_LOOP,T_IFELSE};
    int end_list[100];
    int end_type[100];
%}

%union{
    int intVal;
    char* str;
}

%token<intVal> NUM 
%token<str>ID

%token<str> ':' ';' '.' '[' ']' '(' ')' '{' '}' '!' '~' ',' '=' '|' '^' '&' '<' '>' '+' '-' '*' '/' 
%token<str> CONST INT VOID BREAK RETURN FOR DO WHILE IF ELSE UNADD UNSUB CMPEQ UCMPLT
%token<str> EE NE PRE_EXPR POS_EXPR LE GE

%left ','
%right '='
%left '|'
%left '^'
%left '&'
%left EE NE
%left LE GE '<' '>'
%left '+' '-'
%left '*' '/' '%'
%nonassoc PRE_EXPR
%nonassoc POS_EXPR
%nonassoc '(' ')' '[' ']'

%type<intVal> WHILE_NUM FOR_NUM IF_NUM DO_NUM IFELSE EXPRS MORE_EXPR
%type<str> SCALAR_DECL ARRAY_DECL FUNC_DECL FUNC_DEF EXPR STMT START ROOT MORE_ROOT
%type<str> TYPE
%type<str> MORE_IDENT IDENT_INIT
%type<str> ARRAY  
%type<str> FUNC PARAMETERS PARAMETER MORE_PARAMETER
%type<str> VAR EXPR_OP_EXPR PREFIX_EXPR POSTFIX_EXPR FUN_CALL EXPR_WITH_PA POINTER ADDRESS
%type<str> COMPOUND_STMT EXPR_STMT IF_STMT WHILE_STMT FOR_STMT EXPR_OR_NOT RETURN_STMT BREAK_STMT STMT_OR_DECLS STMT_OR_DECL

%%


START : MORE_ROOT{}
    ;
ROOT : SCALAR_DECL{}
    |ARRAY_DECL{}
    |FUNC_DECL{}
    |FUNC_DEF{}
    ;
MORE_ROOT : ROOT MORE_ROOT{}
    | {}
    ;

TYPE : CONST INT {}
    | INT{}
    |VOID{}
    ;




SCALAR_DECL : TYPE IDENT_INIT MORE_IDENT ';'{}
   ;

MORE_IDENT : ',' IDENT_INIT  MORE_IDENT{}
    | {}
    ;
IDENT_INIT : '*' ID{local_num++;set_local_vars($2);fprintf(f_asm," addi sp, sp, -4\n");}
                    '=' EXPR {
                    char *s; int index;
                    s= $2;
                    index = look_up_symbols(s);
                    //pop expr2 
                    fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
                    switch(table[index].mode) {
                    case LOCAL_MODE:
                        //store expr1
                        fprintf(f_asm," sw t0, %d(s0) \n", table[table[index].functor_index].total_args*(-4)-8 +table[index].offset*(-4));
                        break;
                    case ARGUMENT_MODE:
                        //store expr1
                        fprintf(f_asm," sw t0, %d(s0) \n", table[index].offset*4*(-1)-8);
                        break;
                    default: /* Global Vars */
                    break;}
                    }
    | ID{local_num++;set_local_vars($1);fprintf(f_asm," addi sp, sp, -4\n");} 
        '=' EXPR {
                    char *s; int index;
                    s= $1;
                    index = look_up_symbols(s);
                    //pop expr2 
                    fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
                    switch(table[index].mode) {
                    case LOCAL_MODE:
                        //store expr1
                        fprintf(f_asm," sw t0, %d(s0) \n", table[table[index].functor_index].total_args*(-4)-8 +table[index].offset*(-4));
                        break;
                    case ARGUMENT_MODE:
                        //store expr1
                        fprintf(f_asm," sw t0, %d(s0) \n", table[index].offset*4*(-1)-8);
                        break;
                    default: /* Global Vars */
                    break;}
                    }
    |'*' ID{local_num++;set_local_vars($2);fprintf(f_asm," addi sp, sp, -4\n");}
    | ID{local_num++;set_local_vars($1);fprintf(f_asm," addi sp, sp, -4\n");}
    ;


ARRAY_DECL : TYPE ID '[' NUM ']' ';' {
            local_num++;set_local_array($2,$4);fprintf(f_asm," addi sp, sp, -4\n");
            fprintf(f_asm," addi t0, sp ,-4\n");
            fprintf(f_asm," sw t0, 0(sp) \n");
            local_num+=($4);
            fprintf(f_asm," addi sp, sp, %d\n",-4*($4));
    }
   ;

ARRAY : ID '[' EXPR ']'{char *s; int index;
        s= $1;
        index = look_up_symbols(s);
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");// pop EXPR
        switch(table[index].mode) {
            case LOCAL_MODE:
                fprintf(f_asm," li t1, -4\n");
                fprintf(f_asm," mul t0, t0, t1\n");
                fprintf(f_asm," lw t1, %d(s0)\n",table[table[index].functor_index].total_args*(-4)-8+table[index].offset*(-4));
                fprintf(f_asm," add t0, t0, t1\n");
                break;
            case ARGUMENT_MODE:
                fprintf(f_asm," li t1, -4\n");
                fprintf(f_asm," mul t0, t0, t1\n");
                fprintf(f_asm," lw t1, %d(s0)\n",table[index].offset*4*(-1)-8);
                fprintf(f_asm," add t0, t0, t1\n");
                break;
            default: /* Global Vars */
                break;
        }
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=NULL;}
    ;



FUNC_DECL : FUNC ';' {cur_counter-=arg_num;arg_num=0;}
    ;
FUNC : TYPE '*' ID { if(look_up_symbols($3)==-1)set_global_vars($3);} 
    '(' PARAMETERS ')' { $$ = $3 ;}
    | TYPE ID {if(look_up_symbols($2)==-1)set_global_vars($2);} 
    '(' PARAMETERS ')' { $$ = $2 ;}
    ;
PARAMETER : TYPE '*' ID {arg_num+=1; set_parameters($3,T_ARRAY);}
    | TYPE ID {arg_num+=1; set_parameters($2,T_INT);}
    ;
PARAMETERS : PARAMETER MORE_PARAMETER {}
    | {}
    ;
MORE_PARAMETER : ',' PARAMETER MORE_PARAMETER{}
    | {}
    ;

FUNC_DEF : FUNC {
                fprintf(f_asm,".global %s\n",$1); 
                fprintf(f_asm,"%s:\n",$1);
                fprintf(f_asm," addi sp,sp,-%d\n",4*(2+arg_num));
                fprintf(f_asm," sw ra,%d(sp)\n",4*(1+arg_num));
                fprintf(f_asm," sw s0,%d(sp)\n",4*(arg_num));
                fprintf(f_asm," addi s0,sp,%d\n",4*(2+arg_num));
                for (int i=0;i<arg_num;i++){
                    fprintf(f_asm," sw a%d,%d(sp)\n",i,4*(arg_num-1-i));
                }
                function_idx = look_up_symbols($1);
                } '{'{cur_scope++; 
                    set_scope_and_offset_of_param($1,arg_num);} 
                    STMT_OR_DECLS '}' {
                    pop_up_symbol(cur_scope);
                    cur_scope--;
                    fprintf(f_asm," lw ra,4(sp)\n");
                    fprintf(f_asm," lw s0,0(sp)\n");
                    fprintf(f_asm," addi sp,sp,8\n");
                    fprintf(f_asm," jr ra\n");
                    arg_num=0;}
    ;


EXPR : VAR{$$=$1;}
    |NUM{fprintf(f_asm," li t0, %d\n",$1);
            fprintf(f_asm," addi sp, sp, -4\n");
            fprintf(f_asm," sw t0, 0(sp)\n");
            $$=NULL;
            }
    |EXPR_OP_EXPR {}
    |PREFIX_EXPR {}
    |POSTFIX_EXPR {}
    |EXPR_WITH_PA {}
    ;
VAR : ID{int index; index =look_up_symbols($1);
            if(index!=-1){
                switch(table[index].mode) {
                case LOCAL_MODE:
                    fprintf(f_asm," lw t0, %d(s0) \n",table[table[index].functor_index].total_args*(-4)-8+table[index].offset*(-4));
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    break;
                case ARGUMENT_MODE:
                    fprintf(f_asm," lw t0, %d(s0) \n",table[index].offset*4*(-1)-8);
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    break;
                default: /* Global Vars */
                    break;
                }
            }
            $$=$1;
            }
    | ARRAY{
        fprintf(f_asm," lw t0, 0(sp)\n"); fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t0, 0(t0)\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    ;
EXPR_OP_EXPR : EXPR '*' EXPR{fprintf(f_asm," lw t0, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," lw t1, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," mul t0, t1, t0\n");
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    $$=$1;
                    }
    |EXPR '/' EXPR {fprintf(f_asm," lw t0, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," lw t1, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," div t0, t1, t0\n");
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    $$=$1;
                    }
    |EXPR '+' EXPR {int index = -1;
                    if($1){
                        index = look_up_symbols($1);
                    }
                    if(index!=-1&&table[index].type==T_ARRAY){
                        fprintf(f_asm," lw t0, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," li t1, -4\n");
                        fprintf(f_asm," mul t0, t0, t1\n");
                        fprintf(f_asm," lw t1, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," add t0, t1, t0\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n");
                    }
                    else{
                        fprintf(f_asm," lw t0, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," lw t1, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," add t0, t1, t0\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n");
                    }
                    $$=$1;
                    }
    |EXPR '-' EXPR {int index = -1;
                    if($1){
                        index = look_up_symbols($1);
                    }
                    if(index!=-1&&table[index].type==T_ARRAY){
                        fprintf(f_asm," lw t0, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," li t1, -4\n");
                        fprintf(f_asm," mul t0, t0, t1\n");
                        fprintf(f_asm," lw t1, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," sub t0, t1, t0\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n");
                    }
                    else{
                        fprintf(f_asm," lw t0, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," lw t1, 0(sp)\n");
                        fprintf(f_asm," addi sp, sp, 4\n");
                        fprintf(f_asm," sub t0, t1, t0\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n");
                    }
                    $$=$1;
                    }
    |EXPR '<' EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");//EXPR2
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");//EXPR1
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t0, t0, t1\n");
        fprintf(f_asm," slt t0, zero, t0\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |EXPR '>' EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t0, t1, t0\n");
        fprintf(f_asm," slt t0, zero, t0\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |ID '=' EXPR {char *s; int index;
                    s= $1;
                    index = look_up_symbols(s); 
                    fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
                    switch(table[index].mode) {
                    case LOCAL_MODE:
                        fprintf(f_asm," sw t0, %d(s0) \n", table[table[index].functor_index].total_args*(-4)-8 +table[index].offset*(-4));
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n"); break;
                    case ARGUMENT_MODE:
                        fprintf(f_asm," sw t0, %d(s0) \n", table[index].offset*4*(-1)-8);
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n"); break;
                    default: /* Global Vars */
                    break;}
                    $$=$1;
    }
    |'*' ID '=' EXPR{
                    char *s; int index;
                    s= $2;
                    index = look_up_symbols(s); 
                    fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
                    switch(table[index].mode) {
                    case LOCAL_MODE:
                        fprintf(f_asm," lw t1, %d(s0) \n", table[table[index].functor_index].total_args*(-4)-8 +table[index].offset*(-4));
                        fprintf(f_asm," sw t0, 0(t1)\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n"); break;
                    case ARGUMENT_MODE:
                        fprintf(f_asm," lw t1, %d(s0) \n", table[index].offset*4*(-1)-8);
                        fprintf(f_asm," sw t0, 0(t1)\n");
                        fprintf(f_asm," addi sp, sp, -4\n");
                        fprintf(f_asm," sw t0, 0(sp)\n"); break;
                    default: /* Global Vars */
                    break;}
                    $$=$2;
    }
    |'*' EXPR_WITH_PA '=' EXPR{
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sw t0, 0(t1) \n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$2;
    }
    |ARRAY '=' EXPR{
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sw t0, 0(t1) \n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |EXPR EE EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");//EXPR2
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");//EXPR1
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t0, t1, t0\n");
        fprintf(f_asm," li t1, 1\n");
        fprintf(f_asm," sltu t0, t0, t1\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |EXPR NE EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");//EXPR2
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");//EXPR1
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t2, t1, t0\n");
        fprintf(f_asm," sub t3, t0, t1\n");
        fprintf(f_asm," or t0, t2, t3\n");
        fprintf(f_asm," sltu t0, zero, t0\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |EXPR LE EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");//EXPR2
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");//EXPR1
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t0, t0, t1\n");
        fprintf(f_asm," li t1, -1\n");
        fprintf(f_asm," slt t0, t1, t0\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    |EXPR GE EXPR {
        fprintf(f_asm," lw t0, 0(sp)\n");
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t1, 0(sp)\n");
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," sub t0, t1, t0\n");
        fprintf(f_asm," li t1, -1\n");
        fprintf(f_asm," slt t0, t1, t0\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=$1;
    }
    ;

POINTER : '*' VAR %prec PRE_EXPR{
        char *s; int index;
        s= $2;
        index = look_up_symbols(s);
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t0, 0(t0) \n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=NULL;
    }
    | '*' EXPR_WITH_PA %prec PRE_EXPR{
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw t0, 0(t0) \n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$=NULL;
    }
    ;

ADDRESS : '&' EXPR %prec PRE_EXPR{
        char *s; int index;
        s= $2;
        index = look_up_symbols(s);
        fprintf(f_asm," lw t0, 0(sp) \n");fprintf(f_asm," addi sp, sp, 4\n");
        switch(table[index].mode) {
            case LOCAL_MODE:
                fprintf(f_asm," addi t0, s0, %d\n",table[table[index].functor_index].total_args*(-4)-8+table[index].offset*(-4));
                fprintf(f_asm," addi sp, sp, -4\n");
                fprintf(f_asm," sw t0, 0(sp)\n");
                break;
            case ARGUMENT_MODE:
                fprintf(f_asm," addi t0, s0, %d\n",table[index].offset*4*(-1)-8);
                fprintf(f_asm," addi sp, sp, -4\n");
                fprintf(f_asm," sw t0, 0(sp)\n");
                break;
            default: /* Global Vars */
                break;
            }
        $$=$2;
    }
    ;

PREFIX_EXPR : POINTER{$$=$1;}
    | ADDRESS{$$=$1;}
    |'+' EXPR %prec PRE_EXPR{fprintf(f_asm," lw t0, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," li t1, 0\n");
                    fprintf(f_asm," add t0, t1, t0\n");
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    $$ = $2;}
    |'-' EXPR %prec PRE_EXPR{fprintf(f_asm," lw t0, 0(sp)\n");
                    fprintf(f_asm," addi sp, sp, 4\n");
                    fprintf(f_asm," li t1, 0\n");
                    fprintf(f_asm," sub t0, t1, t0\n");
                    fprintf(f_asm," addi sp, sp, -4\n");
                    fprintf(f_asm," sw t0, 0(sp)\n");
                    $$ = $2;}
    ;

POSTFIX_EXPR : EXPR FUN_CALL %prec POS_EXPR{ fprintf(f_asm," jal ra,%s\n",$1);
                                            fprintf(f_asm," addi sp, sp, -4\n");
                                            fprintf(f_asm," sw a0, 0(sp)\n");
                                            $$ = $1;
                                            }
    |UNADD FUN_CALL %prec POS_EXPR{
        fprintf(f_asm," ukadd8 t0, a0, a1\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$ = NULL;
    }
    |UNSUB FUN_CALL %prec POS_EXPR{
        fprintf(f_asm," uksub8 t0, a0, a1\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$ = NULL;
    }
    |CMPEQ FUN_CALL %prec POS_EXPR{
        fprintf(f_asm," cmpeq8 t0, a0, a1\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$ = NULL;
    }
    |UCMPLT FUN_CALL %prec POS_EXPR{
        fprintf(f_asm," ucmplt8 t0, a0, a1\n");
        fprintf(f_asm," addi sp, sp, -4\n");
        fprintf(f_asm," sw t0, 0(sp)\n");
        $$ = NULL;
    }
    ;

FUN_CALL : '(' EXPRS ')' {
    for(int i=0;i<$2;i++){
        fprintf(f_asm," lw a%d,0(sp)\n",$2-1-i); 
        fprintf(f_asm," addi sp, sp, 4\n");
    }
}
    ;
EXPRS : EXPR MORE_EXPR{$$ = 1 + $2;}
    | {$$=0;}
    ;
MORE_EXPR : ',' EXPR MORE_EXPR{$$ = 1 + $3;}
    | {$$=0;}
    ;


STMT : EXPR_STMT{fprintf(f_asm," addi sp, sp, 4\n");}
    |IF_STMT{}
    |WHILE_STMT{}
    |FOR_STMT{}
    |RETURN_STMT{}
    |BREAK_STMT{}
    |COMPOUND_STMT{}
    ;
EXPR_STMT : EXPR ';' {}
    ;
EXPR_WITH_PA : '(' EXPR ')' {

}

IF_NUM:IF{$$ = end_num;end_num++;fprintf(f_asm,"//if start:\n");}

IF_STMT : IF_NUM '(' EXPR ')'{
        end_list[end_counter] = $1;
        end_type[end_counter] = T_IFELSE;
        end_counter++;
        fprintf(f_asm," lw t0,0(sp)\n"); 
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," li t1,1\n"); 
        fprintf(f_asm," blt t0,t1,else%d\n",$1);
    } COMPOUND_STMT {
        fprintf(f_asm," j end%d\n",$1);
        fprintf(f_asm,"else%d:\n",$1);
    }IFELSE{
        fprintf(f_asm,"end%d:\n",$1);
        end_counter--;fprintf(f_asm,"//if end:\n");}
    ;

IFELSE: ELSE COMPOUND_STMT{}
    |{};

WHILE_NUM : WHILE{$$ = end_num;end_num++;fprintf(f_asm,"//while start:\n");}
DO_NUM : DO{$$ = end_num;end_num++;fprintf(f_asm,"//while start:\n");}
WHILE_STMT : WHILE_NUM{
        fprintf(f_asm,"while%d:\n",$1);
        end_list[end_counter] = $1;
        end_type[end_counter] = T_LOOP;
        end_counter++;
    } '(' EXPR ')'{
        fprintf(f_asm," lw t0,0(sp)\n"); 
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," li t1,1\n"); 
        fprintf(f_asm," blt t0,t1,end%d\n",$1);
    } STMT{
        fprintf(f_asm," j while%d\n",$1);
        fprintf(f_asm,"end%d:\n",$1);
        end_counter--;
        fprintf(f_asm,"//while end:\n");
    }
    | DO_NUM{
        fprintf(f_asm,"while%d:\n",$1);
        end_list[end_counter] = $1;
        end_type[end_counter] = T_LOOP;
        end_counter++;
    } COMPOUND_STMT WHILE '(' EXPR ')' ';' {
        fprintf(f_asm," lw t0,0(sp)\n"); 
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," li t1,1\n"); 
        fprintf(f_asm," bge t0,t1,while%d\n",$1);
        fprintf(f_asm,"end%d:\n",$1);
        end_counter--;
        fprintf(f_asm,"//while end:\n");
    }
    ;
EXPR_OR_NOT : EXPR{}
    | {}
    ;

FOR_NUM : FOR{$$ = end_num;end_num++;fprintf(f_asm,"//for start:\n");}
FOR_STMT : FOR_NUM '(' EXPR_OR_NOT  ';' {
        fprintf(f_asm," addi sp, sp, 4\n");
        end_list[end_counter] = $1;
        end_type[end_counter] = T_LOOP;
        end_counter++;
        fprintf(f_asm,"for%d:\n",$1);
    }EXPR_OR_NOT ';'{
        fprintf(f_asm," lw t0,0(sp)\n"); 
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," li t1,1\n"); 
        fprintf(f_asm," blt t0,t1,end%d\n",$1);
        fprintf(f_asm," j content%d\n",$1);
        fprintf(f_asm,"step%d:\n",$1);
    } EXPR_OR_NOT ')'{
        fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," j for%d\n",$1);
        fprintf(f_asm,"content%d:\n",$1);
    } COMPOUND_STMT{
        fprintf(f_asm," j step%d\n",$1);
        fprintf(f_asm,"end%d:\n",$1);fprintf(f_asm,"//for end:\n");
        end_counter--;
    }
    ;
RETURN_STMT:RETURN  ';'{
        fprintf(f_asm," lw ra,%d(sp)\n",4*(1+arg_num+local_num));
        fprintf(f_asm," lw s0,%d(sp)\n",4*(arg_num+local_num));
        fprintf(f_asm," addi sp,sp,%d\n",4*(2+arg_num+local_num));
        fprintf(f_asm," jr ra\n");
    }
    | RETURN EXPR ';'{
        fprintf(f_asm," lw a0,0(sp)\n");fprintf(f_asm," addi sp, sp, 4\n");
        fprintf(f_asm," lw ra,%d(sp)\n",4*(1+arg_num+local_num));
        fprintf(f_asm," lw s0,%d(sp)\n",4*(arg_num+local_num));
        fprintf(f_asm," addi sp,sp,%d\n",4*(2+arg_num+local_num));
        fprintf(f_asm," jr ra\n");
    }
    ;
BREAK_STMT:BREAK ';' {
        int goal = end_counter-1;
        int i = cur_scope;
        while(end_type[goal]!=T_LOOP){
            goal--;
            break_loop(i);
            i--;
        }
        fprintf(f_asm,"j end%d\n",end_list[goal]);
    }
    ;

COMPOUND_STMT : '{'{
        cur_scope++; 
        } STMT_OR_DECLS '}'{
        pop_up_symbol(cur_scope);
        cur_scope--;}
    ;
STMT_OR_DECLS : STMT_OR_DECL STMT_OR_DECLS{}
    | {}
    ;
STMT_OR_DECL : STMT {}
    | SCALAR_DECL {}
    | ARRAY_DECL {}
    ;

%%
int main(void) {
    start();
    f_asm = fopen("codegen.S", "w");
    yyparse();
    fclose(f_asm);
    return 0;
}

int yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
