%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include "y.tab.h"
	#include "map.h"
%}

%option noyywrap

digit		[0-9]

%%

start										{return START_BLOCK;}
end											{return END_BLOCK;}
;											{return DELIMITER;}
\(											{return START_PARENTHESIS;}
true										{return TRUE;}
false										{return FALSE;}
\)											{return END_PARENTHESIS;}
\,											{return COMMA;}
eq											{return IS_EQUALS_SYMBOL;}
neq											{return IS_NOT_EQUALS_SYMBOL;}
gt											{return GREATER_THAN_SYMBOL;}
ge											{return GREATER_EQUALS_THAN_SYMBOL;}
lt											{return LESS_THAN_SYMBOL;}
le											{return LESS_EQUAL_THAN_SYMBOL;}
not											{return NOT_SYMBOL;}
and											{return AND_SYMBOL;}
or 											{return OR_SYMBOL;}
xor 										{return XOR_SYMBOL;}
" + "										{return SUM_CARACHTER;}
" * "											{return MULTIPLY_CARACHTER;}
" - "											{return SUBSTRACTION_CARACHTER;}
" / "											{return DIVISION_CARACHTER;}
while										{return WHILE_START;}
if											{return IF_START;}
else										{return ELSE_START;}
number										{return NUMBER;}
string										{return STRING;}
vector										{return VECTOR;}
matrix										{return MATRIX;}
constant									{return CONSTANT;}
print                                       {return PRINT;}
read										{return READ;}
[\[]										{return STARTING_BRACKET;}
[\]]										{return ENDING_BRACKET;}
[\.]										{return DOT;}
get 										{return GET;}
set 										{return SET;}
=											{return ASSIGN_OPERATOR;}
\{											{return OPEN_VECTOR;}
\}											{return CLOSE_VECTOR;}
\"(\\.|[^\\"])*\"							{yylval.str = strdup(yytext); return STRING_VALUE;}
[a-zA-Z_][a-zA-Z0-9_]* 						{yylval.str = strdup(yytext); return VAR_NAME;}
(-?([0-9]+)(\.[0-9]+)?)|(-?\.?[0-9]+)		{yylval.str = strdup(yytext); return NUMBER_VALUE;}
\t
\n
[ \n]+
[ \t]+
%%