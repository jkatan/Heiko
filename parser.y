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
%token <str> STRING
%token <str> ARRAY
%token <str> MATRIX
%token <str> STRING_VALUE
%type  <str> arithmetic 
%type  <str> term

%token TOKHEAT STATE TOKTARGET TOKTEMPERATURE STARTING_BLOCK_SYMBOL ENDING_BLOCK_SYMBOL DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACTION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER CONST STARTING_BRACKET ENDING_BRACKET ASSIGN_OPERATOR CONSTANT QUOTE

%start block

%%
block: 
        program_start instruction program_end
        ;

program_start:
        STARTING_BLOCK_SYMBOL { printf("public static void main(int argc, String[] args) \n{\n"); }
        ;

program_end:
        ENDING_BLOCK_SYMBOL { printf("}\n"); }
        ;

instruction: 
        vardecl delimiter
        | vardecl delimiter instruction
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
            $$ = malloc(strlen($1) + strlen($3) + 4);
            sprintf($$, "%s + %s", $1, $3);
        }
        |  arithmetic MULTIPLY_CARACHTER term 
        { 
            $$ = malloc(strlen($1) + strlen($3) + 4);
            sprintf($$, "%s * %s", $1, $3);
        }
        |  arithmetic SUBSTRACTION_CARACHTER term 
        {
            $$ = malloc(strlen($1) + strlen($3) + 4);
            sprintf($$, "%s - %s", $1, $3);
        }
        |  arithmetic DIVISION_CARACHTER term 
        {
            $$ = malloc(strlen($1) + strlen($3) + 4);
            sprintf($$, "%s / %s", $1, $3);
        }
        | term { $$ = $1; }
        ;

term:   
    VAR_NAME { $$ = $1; }
    |  NUMBER_VALUE { $$ = $1; }
    |  STRING_VALUE { $$ = $1; }
    |  ARRAY { $$ = $1; }
    |  MATRIX { $$ = $1; }

%%