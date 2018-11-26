%{

	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include "y.tab.h"
	#include "map.h"

%}

%option noyywrap

alpha		[A-Za-z]
digit		[0-9]
boolean		[true|false]

%%

"start"		{return STARTING_BLOCK_SYMBOL;}
"end"		{return ENDING_BLOCK_SYMBOL;}
";"			{return DELIMITER;}
"("			{return START_PARENTHESIS;}
")"			{return END_PARENTHESIS;}
","			{return COMMA;}
"eq"		{return IS_EQUALS_SYMBOL;}
"neq"		{return IS_NOT_EQUALS_SYMBOL;}
"gt"		{return GREATER_THAN_SYMBOL;}
"ge"		{return GREATER_EQUALS_THAN_SYMBOL;}
"lt"		{return LESS_THAN_SYMBOL;}
"le"		{return LESS_EQUAL_THAN_SYMBOL;}
"not"		{return NOT_SYMBOL;}
"+"			{return SUM_CARACHTER;}
"*"			{return MULTIPLY_CARACHTER;}
"-"			{return SUBSTRACION_CARACHTER;}
"/"			{return DIVISION_CARACHTER;}
"while"		{return WHILE_START;}
"if"		{return IF_START;}
"else"		{return ELSE_START;}
"number"	{return NUMBER;}
"string"	{return STRING;}
"array"		{return ARRAY;}
"matrix"	{return MATRIX;}
"constant"	{return CONST;}
"["			{return STARTING_BRACKET;}
"]"			{return ENDING_BRACKET;}
"\t"		
"\n"

%%