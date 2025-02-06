%{

    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

%%

"const"   {yylval.str = strdup(yytext); return CONST;}
"signed"|"unsigned"  {yylval.str = strdup(yytext); return SIGN;}
"short"   {yylval.str = strdup(yytext); return SHORT;}
"long"   {yylval.str = strdup(yytext); return LONG;}
"int"  {yylval.str = strdup(yytext); return INT;}
"char"  {yylval.str = strdup(yytext); return CHAR;}
"double"|"float"  {yylval.str = strdup(yytext); return FD;}
"void"  {yylval.str = strdup(yytext); return VOID;}
"for"  {yylval.str = strdup(yytext); return FOR;}
"do"  {yylval.str = strdup(yytext); return DO;}
"while" {yylval.str = strdup(yytext); return WHILE;}
"break" {yylval.str = strdup(yytext); return BREAK;}
"continue" {yylval.str = strdup(yytext); return CONTINUE;}
"if" {yylval.str = strdup(yytext); return IF;}
"else" {yylval.str = strdup(yytext); return ELSE;}
"return" {yylval.str = strdup(yytext); return RETURN;}
"switch" {yylval.str = strdup(yytext); return SWITCH;}
"case" {yylval.str = strdup(yytext); return CASE;}
"default" {yylval.str = strdup(yytext); return DEFAULT;}


"NULL"     {yylval.intVal = 0; return NULL_;}

"\n"  {continue;}

" "|"\t"   {continue;}

[:;,.\[\]\(\)\{\}]    {yylval.str = strdup(yytext); return yytext[0];}


"&&"  {yylval.str = strdup(yytext); return AA;}
"||"  {yylval.str = strdup(yytext); return OO;}
"=="  {yylval.str = strdup(yytext); return EE;}
"!="  {yylval.str = strdup(yytext); return NE;}
"<="  {yylval.str = strdup(yytext); return LE;}
">="  {yylval.str = strdup(yytext); return GE;}
"<<"  {yylval.str = strdup(yytext); return LL;}
">>"  {yylval.str = strdup(yytext); return GG;}

"+"|"-"|"*"|"/"|"%"|"<"|">"|"="|"!"|"&"|"|"|"^"|"~"   {yylval.str = strdup(yytext); return yytext[0];}
"++"  {yylval.str = strdup(yytext); return PP;}
"--"  {yylval.str = strdup(yytext); return MM;}

\"([^\"\n\\]|\\a|\\b|\\t|\\n|\\e|\\f|\\r|\\v|\\\\|\\'|\\\"|\\"?"|\\0|\\x([[:digit:]]|[a-f]|[A-F])+|\\[0-7]{1,3}|\\u([[:digit:]]|[a-f]|[A-F]){4}|\\U([[:digit:]]|[a-f]|[A-F]){8})*\"  {yylval.str = strdup(yytext); return STRING;}
\'(.|\\a|\\b|\\t|\\n|\\e|\\f|\\r|\\v|\\\\|\\'|\\\"|\\"?"|\\0|\\x([[:digit:]]|[a-f]|[A-F])+|\\[0-7]{1,3}|\\u([[:digit:]]|[a-f]|[A-F]){4}|\\U([[:digit:]]|[a-f]|[A-F]){8})\'   {yylval.str = strdup(yytext); return CH;}

(_|[a-zA-Z])(_|[[:alnum:]])*    {yylval.str = strdup(yytext); return ID;}
([[:digit:]]+(".")[[:digit:]]*|[[:digit:]]*(".")[[:digit:]]+)  {yylval.dVal = atof(yytext); return FLOAT;}
[[:digit:]]+  {yylval.intVal = atoi(yytext); return NUM;}




%%

int yywrap(void){
    return 1;
}