%{
    #include <stdio.h>
    #include <string.h>
    int yylex();
%}

%union{
    int intVal;
    double dVal;
    char* str;
}

%token<intVal> NUM NULL_
%token<dVal> FLOAT
%token<str> CH STRING ID

%token<str> ':' ';' '.' '[' ']' '(' ')' '{' '}' '!' '~' ',' '=' '|' '^' '&' '<' '>' '+' '-' '*' '/' '%'
%token<str> CONST SIGN LONG SHORT INT CHAR FD VOID FOR DO WHILE BREAK CONTINUE IF ELSE RETURN SWITCH CASE DEFAULT
%token<str> PP MM EE NE LE GE LL GG OO AA PRE_EXPR POS_EXPR

%left ','
%right '='
%left OO
%left AA
%left '|'
%left '^'
%left '&'
%left EE NE
%left LE GE '<' '>'
%left LL GG
%left '+' '-'
%left '*' '/' '%'
%nonassoc PRE_EXPR
%nonassoc POS_EXPR
%nonassoc PP MM
%nonassoc '(' ')' '[' ']'

%type<str> scalar_decl array_decl func_decl func_def expr stmt START ROOT MORE_ROOT SCALAR_DECL ARRAY_DECL FUNC_DECL FUNC_DEF
%type<str> TYPE AFTER_CONST SUFDV AFTER_SIGN LS LONG_OR_NOT AFTER_CONST_OR_NOT SIGN_OR_NOT LS_OR_NOT
%type<str> MORE_IDENT E_EXPR_OR_NOT IDENT_INIT
%type<str> ARRAY MORE_ARRAY ARRAY_INIT E_ARRAY_CON_OR_NOT ARRAY_CON AFTER_ARRAY_EX EXPR_OR_ARRAY_CON MORE_EXPR_OR_ARRAY_CON MORE_EXPR
%type<str> FUNC PARAMETERS PARAMETER MORE_PARAMETER
%type<str> EXPR VAR EXPR_OP_EXPR PREFIX_EXPR POSTFIX_EXPR TYPE_WITH_PA FUN_CALL EXPR_WITH_PA EXPRS
%type<str> STMT COMPOUND_STMT EXPR_STMT IF_STMT IFELSE SWITCH_STMT SWITCH_CLAUSES SWITCH_CLAUSE STMTS WHILE_STMT FOR_STMT EXPR_OR_NOT RETURN_STMT BREAK_STMT CONTINUE_STMT STMT_OR_DECLS STMT_OR_DECL


%%


START : MORE_ROOT{ char*s = malloc(sizeof(char)*(strlen($1)+1));strcpy(s,$1); $$=s; free($1); printf("%s",$$);}
    ;
ROOT : scalar_decl{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |array_decl{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |func_decl{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |func_def{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
MORE_ROOT : ROOT MORE_ROOT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;

TYPE : CONST AFTER_CONST_OR_NOT { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | AFTER_CONST{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
AFTER_CONST_OR_NOT : AFTER_CONST{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
AFTER_CONST : SUFDV{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | SIGN_OR_NOT AFTER_SIGN{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
SIGN_OR_NOT : SIGN{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
SUFDV : SIGN{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | FD{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | VOID{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
AFTER_SIGN : LS{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | CHAR{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | LS_OR_NOT INT { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
LS : SHORT { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | LONG LONG_OR_NOT { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
LONG_OR_NOT : LONG { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
LS_OR_NOT : LS { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;


scalar_decl : SCALAR_DECL { char c1[20] = "<scalar_decl>";char c2[20] = "</scalar_decl>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
SCALAR_DECL : TYPE IDENT_INIT MORE_IDENT ';'{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
   ;

MORE_IDENT : ',' IDENT_INIT  MORE_IDENT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
IDENT_INIT : '*' ID E_EXPR_OR_NOT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | ID E_EXPR_OR_NOT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
E_EXPR_OR_NOT : '=' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;


array_decl : ARRAY_DECL { char c1[20] = "<array_decl>";char c2[20] = "</array_decl>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
ARRAY_DECL : TYPE ARRAY_INIT MORE_ARRAY ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
   ;

MORE_ARRAY : ',' ARRAY_INIT MORE_ARRAY{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
ARRAY_INIT : ARRAY E_ARRAY_CON_OR_NOT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;

ARRAY : ID '[' expr ']' AFTER_ARRAY_EX { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5); $$=s; free($1); free($2);free($3);free($4);free($5);}
    ;

AFTER_ARRAY_EX : '[' expr ']' AFTER_ARRAY_EX{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
E_ARRAY_CON_OR_NOT : '=' ARRAY_CON { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
ARRAY_CON : '{' EXPR_OR_ARRAY_CON MORE_EXPR_OR_ARRAY_CON '}' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
    ;
EXPR_OR_ARRAY_CON : expr { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | ARRAY_CON  { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
MORE_EXPR_OR_ARRAY_CON :  ',' EXPR_OR_ARRAY_CON MORE_EXPR_OR_ARRAY_CON{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;


func_decl : FUNC_DECL { char c1[20] = "<func_decl>";char c2[20] = "</func_decl>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
FUNC_DECL : FUNC ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
FUNC : TYPE '*' ID '(' PARAMETERS ')' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5);strcat(s,$6); $$=s; free($1); free($2);free($3);free($4);free($5);free($6);}

    | TYPE ID '(' PARAMETERS ')' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5); $$=s; free($1); free($2);free($3);free($4);free($5);}
    ;
PARAMETER : TYPE '*' ID { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | TYPE ID { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
PARAMETERS : PARAMETER MORE_PARAMETER { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
MORE_PARAMETER : ',' PARAMETER MORE_PARAMETER{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;

func_def : FUNC_DEF { char c1[20] = "<func_def>";char c2[20] = "</func_def>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
FUNC_DEF : FUNC COMPOUND_STMT { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;

expr : EXPR { char c1[20] = "<expr>";char c2[20] = "</expr>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
EXPR : VAR{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |NULL_{char *s = malloc(sizeof(char)*(2));
 sprintf(s,"%d",$1); $$ = s;}
    |STRING{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |CH{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |NUM{char *s = malloc(sizeof(char)*(100));
 sprintf(s,"%d",$1); $$ = s;}
    |FLOAT{char *s = malloc(sizeof(char)*(100));
 sprintf(s,"%f",$1); $$ = s;}
    |EXPR_OP_EXPR { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |PREFIX_EXPR { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |POSTFIX_EXPR { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |EXPR_WITH_PA { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
VAR : ID{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | ARRAY{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
EXPR_OP_EXPR : expr '*' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '/' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '%' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '+' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '-' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '<' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '>' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '&' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '^' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '|' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr '=' expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr LL expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr GG expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr LE expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr GE expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr EE expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr NE expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr OO expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    |expr AA expr { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;
PREFIX_EXPR : PP expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | MM expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '!' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '~' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '*' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '&' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '+' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | '-' expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | TYPE_WITH_PA expr %prec PRE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;

TYPE_WITH_PA : '(' TYPE '*' ')' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
    | '(' TYPE ')'{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;

POSTFIX_EXPR : expr PP %prec POS_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    |expr MM %prec POS_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    |expr FUN_CALL %prec POS_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;

FUN_CALL : '(' EXPRS ')' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;
EXPRS : expr MORE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
MORE_EXPR : ',' expr MORE_EXPR{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;

stmt : STMT { char c1[20] = "<stmt>";char c2[20] = "</stmt>";char*s = malloc(sizeof(char)*(strlen(c1)+strlen($1)+strlen(c2)+1));
 strcpy(s,c1);strcat(s,$1);strcat(s,c2); $$=s; free($1);}
    ;
STMT : EXPR_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |IF_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |SWITCH_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |WHILE_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |FOR_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |RETURN_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |BREAK_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |CONTINUE_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    |COMPOUND_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;
EXPR_STMT : expr ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
EXPR_WITH_PA : '(' expr ')' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
IF_STMT : IF EXPR_WITH_PA COMPOUND_STMT IFELSE{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
    ;
IFELSE : ELSE COMPOUND_STMT{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
SWITCH_STMT : SWITCH EXPR_WITH_PA '{' SWITCH_CLAUSES '}' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5); $$=s; free($1); free($2);free($3);free($4);free($5);}
    ;
SWITCH_CLAUSES : SWITCH_CLAUSE SWITCH_CLAUSES{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
SWITCH_CLAUSE : CASE expr ':' STMTS{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4); $$=s; free($1); free($2);free($3);free($4);}
    |DEFAULT ':' STMTS{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;
STMTS : stmt STMTS{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
WHILE_STMT : WHILE EXPR_WITH_PA stmt{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    | DO stmt WHILE EXPR_WITH_PA ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5); $$=s; free($1); free($2);free($3);free($4);free($5);}
    ;
EXPR_OR_NOT : expr{ char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
FOR_STMT : FOR '(' EXPR_OR_NOT  ';' EXPR_OR_NOT ';' EXPR_OR_NOT ')' stmt{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+strlen($4)+strlen($5)+strlen($6)+strlen($7)+strlen($8)+strlen($9)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); strcat(s,$4);strcat(s,$5);strcat(s,$6);strcat(s,$7);strcat(s,$8);strcat(s,$9); $$=s; free($1); free($2);free($3);free($4);free($5);free($6);free($7);free($8);free($9);}
    ;
RETURN_STMT:RETURN EXPR_OR_NOT ';'{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;
BREAK_STMT:BREAK ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
CONTINUE_STMT:CONTINUE ';' { char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    ;
COMPOUND_STMT : '{' STMT_OR_DECLS '}'{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+strlen($3)+1));
 strcpy(s,$1);strcat(s,$2);strcat(s,$3); $$=s; free($1); free($2);free($3);}
    ;
STMT_OR_DECLS : STMT_OR_DECL STMT_OR_DECLS{ char*s = malloc(sizeof(char)*(strlen($1)+strlen($2)+1));
 strcpy(s,$1);strcat(s,$2); $$=s; free($1); free($2);}
    | {char *s = malloc(sizeof(char)*(2));; strcpy(s,"");$$ = s;}
    ;
STMT_OR_DECL : stmt { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | scalar_decl { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    | array_decl { char*s = malloc(sizeof(char)*(strlen($1)+1));
 strcpy(s,$1); $$=s; free($1);}
    ;

%%
int main(void) {
    yyparse();
    return 0;
}

int yyerror(char* s) {
    fprintf(stderr, "%s\n", s);
    return 0;
}
