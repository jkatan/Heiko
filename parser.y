%{
#include <stdio.h>
#include <string.h>

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
%type  <str> arithmetic 

%token TOKHEAT STATE TOKTARGET TOKTEMPERATURE STARTING_BLOCK_SYMBOL ENDING_BLOCK_SYMBOL DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER STRING ARRAY MATRIX CONST STARTING_BRACKET ENDING_BRACKET ASSIGN_OPERATOR

%start block

%%
block: 
        program_start instruction program_end
        ;

program_start:
        STARTING_BLOCK_SYMBOL { printf("public static void main(int argc, String[] args) \n{\n"); }
        ;

program_end:
        ENDING_BLOCK_SYMBOL { printf("}"); }
        ;

instruction:
        |
        vardecl DELIMITER { printf(";\n"); }
        ;

vardecl: datatype initvar
        ;

datatype:
        NUMBER { printf("float "); }
        | STRING { printf("String "); }
        | ARRAY { printf("float[] "); }
        | MATRIX { printf("float[][] "); }
        ;

initvar: 
        VAR_NAME ASSIGN_OPERATOR arithmetic { printf("%s = %s", $1, $3); }
        ;

arithmetic:
        NUMBER_VALUE { $$ = $1; }
        ;
%%