%{
#include <stdio.h>
#include <string.h>
#include "map.h"

#define NUM_VAL 0
#define STRING_VAL 1
#define ARRAY_VAL 2
#define MATRIX_VAL 3

map* m;

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
main()
{
        yyparse();
} 

%}


%union
{
    char *str;
}


%token <str> VAR_NAME
%token <str> NUMBER_VALUE
%token <str> STRING
%token <str> ARRAY
%token <str> MATRIX
%token <str> STRING_VALUE
%type  <str> arithmetic 
%type  <str> term
%type  <str> ifblock
%type  <str> elseblock
%type  <str> condition
%type  <str> whileblock

%token TOKHEAT STATE TOKTARGET TOKTEMPERATURE STARTING_BLOCK_SYMBOL ENDING_BLOCK_SYMBOL DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACTION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER CONST STARTING_BRACKET ENDING_BRACKET ASSIGN_OPERATOR CONSTANT QUOTE TRUE FALSE

%start block

%%
block: 
        program_start instruction program_end
        ;

program_start:
        STARTING_BLOCK_SYMBOL 
        { 
        	printf("public static void main(int argc, String[] args) \n{\n"); 
        	m = newmap(); 
       		newblock(m);
       	}
        ;

program_end:
        ENDING_BLOCK_SYMBOL { printf("}\n"); quitlevel(m);}
        ;

instruction: 
        vardecl delimiter
        | vardecl delimiter instruction
        | ifblock instruction
        | ifblock
        | whileblock instruction
        | whileblock
        ;

delimiter:
        DELIMITER { printf(";\n"); }
        ;

vardecl: datatype initvar
        | constant_decl datatype initvar
        ;

constant_decl: 
        CONSTANT { printf("\tfinal "); }
        ;

datatype:
        NUMBER { printf("\tfloat "); }
        | STRING { printf("\tString "); }
        | ARRAY { printf("\tfloat[] "); }
        | MATRIX { printf("\tfloat[][] "); }
        ;

initvar: 
        VAR_NAME ASSIGN_OPERATOR arithmetic { printf("%s = %s", $1, $3); }
        | VAR_NAME { printf("%s", $1); }
        ;

arithmetic:
        arithmetic SUM_CARACHTER term 
        {
        	if(checktype(m, $1) == checktype(m, $3))
        	{
        		switch(checktype(m, $1))
        		{
        			case(NUM_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s + %s", $1, $3);
        				break;
        			case(STRING_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s + %s", $1, $3);
        				break;
        			case(ARRAY_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("sumarrays(, )") + 1);
        				sprintf($$, "sumarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("summatrix(, )") + 1);
        				sprintf($$, "summatrix(%s, %s)", $1, $3);
        				break;
        			default:
        				yyerror("Not a valid arithmetic operation");
        				break;
        		}
        	}
        	else
        	{
        		yyerror("Not a valid arithmetic operation");
        	} 
        }
        |  arithmetic MULTIPLY_CARACHTER term 
        { 
        	if(checktype(m, $1) == checktype(m, $3))
        	{
        		switch(checktype(m, $1))
        		{
        			case(NUM_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s * %s", $1, $3);
        				break;
        			case(ARRAY_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("multarrays(, )") + 1);
        				sprintf($$, "multarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("multmatrix(, )") + 1);
        				sprintf($$, "multmatrix(%s, %s)", $1, $3);
        				break;
        			default:
        				yyerror("Not a valid arithmetic operation");
        				break;
        		}
        	}
        	else
        	{
        		yyerror("Not a valid arithmetic operation");
        	}
        }
        |  arithmetic SUBSTRACTION_CARACHTER term 
        {
        	if(checktype(m, $1) == checktype(m, $3))
        	{
        		switch(checktype(m, $1))
        		{
        			case(NUM_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s - %s", $1, $3);
        				break;
        			case(ARRAY_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("subarrays(, )") + 1);
        				sprintf($$, "subarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_VAL):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("submatrix(, )") + 1);
        				sprintf($$, "submatrix(%s, %s)", $1, $3);
        				break;
        			default:
        				yyerror("Not a valid arithmetic operation");
        				break;
        		}
        	}
        	else
        	{
        		yyerror("Not a valid arithmetic operation");
        	} 
        }
        |  arithmetic DIVISION_CARACHTER term 
        {
        	if(checktype(m, $1) == checktype(m, $3) && checktype(m, $1) == NUM_VAL)
        	{
            	$$ = malloc(strlen($1) + strlen($3) + 4);
            	sprintf($$, "%s / %s", $1, $3);	
        	}
        	else
        	{
        		yyerror("Not a valid arithmetic operation");
        	}
        }
        | term { $$ = $1; }
        ;

term:   
    VAR_NAME { $$ = $1; }
    |  NUMBER_VALUE { $$ = $1; }
    |  STRING_VALUE { $$ = $1; }
    |  ARRAY { $$ = $1; }
    |  MATRIX { $$ = $1; }
    ;

condition:		TRUE  {printf("true");}
			|	FALSE {printf("false");}
			|	NOT_SYMBOL condition {printf("!");}
	;

ifblock:		IF_START condition block {printf("if");}
			|	IF_START condition block elseblock {printf("if");}
	;

elseblock:		ELSE_START block {printf("else");}
			|	ELSE_START ifblock {printf("else");}
	;

whileblock:		WHILE_START block {printf("while");}
	;		

%%
