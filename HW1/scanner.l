%{
#include <stdio.h>
#include <string.h>
#define true 1
#define false 0
int linecount = 1;
char line[300];
int source = true;
int token = true;
%}

%x COMMENT_MUL_LINE

%%
"for"|"do"|"while"|"break"|"continue"|"if"|"else"|"return"|"struct"|"switch"|"case"|"default"|"void"|"int"|"double"|"float"|"char"|"const"|"signed"|"unsigned"|"short"|"long"   {if(token)printf("#key:%s\n",yytext); strcat(line, yytext);}

"NULL"|"__COUNTER__"|"__LINE__"|"INT_MAX"|"INT_MIN"|"CHAR_MAX"|"CHAR_MIN"|"MAX"|"MIN"     {if(token)printf("#macro:%s\n",yytext); strcat(line, yytext);}

"\n"  {strcat(line, yytext); if(source)printf("%d:%s",linecount,line); line[0] = '\0'; linecount++;}

" "|"\t"   {strcat(line, yytext);}

[:;,.\[\]\(\)\{\}]    {if(token)printf("#punc:%s\n",yytext); strcat(line, yytext);}

"++"|"--"|"&&"|"||"|"=="|"!="|"<="|">="  {if(token)printf("#op:%s\n",yytext); strcat(line, yytext);}
"+"|"-"|"*"|"/"|"%"|"<"|">"|"="|"!"|"&"|"|"   {if(token)printf("#op:%s\n",yytext); strcat(line, yytext);}

\/\/.*\n    {strcat(line, yytext); if(source)printf("%d:%s",linecount,line); line[0] = '\0'; linecount++;}

\/"*"  {BEGIN COMMENT_MUL_LINE; strcat(line, yytext);}
<COMMENT_MUL_LINE>.  {strcat(line, yytext);}
<COMMENT_MUL_LINE>\n  {strcat(line, yytext); if(source)printf("%d:%s",linecount,line); line[0] = '\0'; linecount++;}
<COMMENT_MUL_LINE>"*"\/    {BEGIN 0; strcat(line, yytext);}

"#pragma"(\t|" ")*"source"(\t|" ")*"on"(\t|" ")*     {source=true; strcat(line, yytext);}
"#pragma"(\t|" ")*"source"(\t|" ")*"off"(\t|" ")*    {source=false; strcat(line, yytext);}
"#pragma"(\t|" ")*"token"(\t|" ")*"on"(\t|" ")*      {token=true; strcat(line, yytext);}
"#pragma"(\t|" ")*"token"(\t|" ")*"off"(\t|" ")*     {token=false; strcat(line, yytext);}

\"([^\"\n\\]|\\a|\\b|\\t|\\n|\\e|\\f|\\r|\\v|\\\\|\\'|\\\"|\\"?"|\\0|\\x([[:digit:]]|[a-f]|[A-F])+|\\[0-7]{1,3}|\\u([[:digit:]]|[a-f]|[A-F]){4}|\\U([[:digit:]]|[a-f]|[A-F]){8})*\"  {if(token)printf("#string:%s\n",yytext); strcat(line, yytext);}
\'(.|\\a|\\b|\\t|\\n|\\e|\\f|\\r|\\v|\\\\|\\'|\\\"|\\"?"|\\0|\\x([[:digit:]]|[a-f]|[A-F])+|\\[0-7]{1,3}|\\u([[:digit:]]|[a-f]|[A-F]){4}|\\U([[:digit:]]|[a-f]|[A-F]){8})\'   {if(token)printf("#char:%s\n",yytext); strcat(line, yytext);}

(_|[a-zA-Z])(_|[[:alnum:]])*    {if(token)printf("#id:%s\n",yytext); strcat(line, yytext);}
("-"|"+")?([[:digit:]]+(".")[[:digit:]]*|[[:digit:]]*(".")[[:digit:]]+)  {if(token)printf("#float:%s\n",yytext); strcat(line, yytext);}
("-"|"+")?[[:digit:]]+  {if(token)printf("#integer:%s\n",yytext); strcat(line, yytext);}

%%

int main(void){
    yylex();
    return 0;
}