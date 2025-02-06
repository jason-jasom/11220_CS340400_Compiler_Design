%{

    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

%x COMMENT_MUL_LINE

%%

"const"   {return CONST;}
"int"  {return INT;}
"void"  {return VOID;}
"for"  {return FOR;}
"do"  {return DO;}
"while" {return WHILE;}
"break" {return BREAK;}
"if" {return IF;}
"else" {return ELSE;}
"return" {return RETURN;}
"HIGH" {yylval.intVal = 1; return NUM;}
"LOW" {yylval.intVal = 0; return NUM;}
"uint32_t" {return INT;}
"__rv__ukadd8" {return UNADD;}
"__rv__uksub8" {return UNSUB;}
"__rv__cmpeq8" {return CMPEQ;}
"__rv__ucmplt8" {return UCMPLT;}


\/\/.*\n    {continue;}

\/"*"  {BEGIN COMMENT_MUL_LINE;}
<COMMENT_MUL_LINE>.  {continue;}
<COMMENT_MUL_LINE>\n  {continue;}
<COMMENT_MUL_LINE>"*"\/    {BEGIN 0;}


"\n"  {continue;}

" "|"\t"   {continue;}

[:;,.\[\]\(\)\{\}]    {return yytext[0];}


"=="  {return EE;}
"!="  {return NE;}
"<="  {return LE;}
">="  {return GE;}

"+"|"-"|"*"|"/"|"<"|">"|"="|"!"|"&"  {return yytext[0];}

(_|[a-zA-Z])(_|[[:alnum:]])*    {yylval.str = strdup(yytext); return ID;}
[[:digit:]]+  {yylval.intVal = atoi(yytext); return NUM;}




%%

int yywrap(void){
    return 1;
}