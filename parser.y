%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "util.h"
#include "map.h"

#define NUMBER_TYPE 1
#define STRING_TYPE 2
#define VECTOR_TYPE 3
#define MATRIX_TYPE 4

char **vector_initializator;
int vector_index;
int vector_max_size;
int vector_size;

int matrix_prev_vec_size;
int matrix_current_vec_size;

map *var_types;

struct vector {
    char **elements;
    int current_index;
    int size;
    int max_size;
};

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
    char *varname;
    int datatype;
}

%token <str> VAR_NAME
%token <str> NUMBER_VALUE
%token <str> STRING
%token <str> VECTOR
%token <str> MATRIX
%token <str> STRING_VALUE
%token <str> STARTING_BRACKET
%token <str> ENDING_BRACKET
%type  <str> arithmetic 
%type  <str> term
%type  <str> vector_elem
%type  <str> vector_decl
%type  <str> matrix_decl
%type  <str> matrix_element
%type  <str> matrix_elements
%type <varname> initvar
%type <datatype> datatype;

%token TOKHEAT STATE TOKTARGET TOKTEMPERATURE STARTING_BLOCK_SYMBOL ENDING_BLOCK_SYMBOL DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACTION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER CONST   ASSIGN_OPERATOR CONSTANT QUOTE OPEN_VECTOR CLOSE_VECTOR

%start block

%%
block: 
        program_start instruction program_end
        ;

program_start:
        STARTING_BLOCK_SYMBOL 
        { 
            printf("public static void main(int argc, String[] args) \n{\n"); 
            var_types = newmap();
            var_types->level = 0;
        }
        ;

program_end:
        ENDING_BLOCK_SYMBOL { printf("}\n"); }
        ;

instruction: 
        | vardecl delimiter instruction
        | initvar delimiter instruction
        ;

delimiter:
        DELIMITER { printf(";\n"); }
        ;

vardecl: datatype initvar
        {
            addvariabletomap(var_types, $1, $2);   
        }
        | constant_decl datatype initvar
        ;

constant_decl: 
        CONSTANT { printf("\tfinal "); }
        ;

datatype:
        NUMBER { printf("\tfloat "); $$ = NUMBER_TYPE; }
        | STRING { printf("\tString "); $$ = STRING_TYPE; }
        | VECTOR { printf("\tfloat[] "); $$ = VECTOR_TYPE; }
        | MATRIX { printf("\tfloat[][] "); $$ = MATRIX_TYPE; }
        ;

initvar: 
        VAR_NAME ASSIGN_OPERATOR arithmetic 
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            $$ = malloc(strlen($1));
            strcpy($$, $1);
            free($1); 
        }
        | VAR_NAME 
        { 
            printf("%s", $1); 
            $$ = malloc(strlen($1));
            strcpy($$, $1);
            free($1); 
        }
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
        | term { $$ = $1;}
        ;

term:   
    VAR_NAME { $$ = $1; }
    |  NUMBER_VALUE 
    { 
        $$ = malloc(strlen($1) + 2); 
        strcpy($$, $1);
        strcat($$, "f");
    }
    |  STRING_VALUE { $$ = $1; }
    |  vector_decl 
    { 
        $$ = malloc(strlen($1) + strlen("new float[] ")); 
        strcpy($$, "new float[] "); 
        strcat($$, $1);
        free($1);
        free_vector(&vector_index, &vector_max_size, &vector_size, &vector_initializator);
    }
    |  matrix_decl 
    { 
        $$ = malloc(strlen($1) + strlen("new float[][] {}"));
        strcpy($$, "new float[][] {");
        strcat($$, $1);
        strcat($$, "}");
        free($1); 
    }
    ;

matrix_decl:
    STARTING_BRACKET matrix_elements ENDING_BRACKET
    {
        $$ = malloc(strlen($2));
        strcpy($$, $2);
        free($2);
        matrix_current_vec_size = 0;
    }
    ;

matrix_elements:
    matrix_element
    {
        $$ = malloc(strlen($1));
        strcpy($$, $1);
        free($1);
    }
    ;

matrix_element:
    vector_decl
    {
        $$ = malloc(strlen($1));
        strcpy($$, $1);
        free($1);

        if(!validate_matrix_column_size(matrix_current_vec_size, vector_size))
        {
            yyerror("syntax error, matrix columns must be of equal size");
        }

        matrix_current_vec_size = vector_size;

        free_vector(&vector_index, &vector_max_size, &vector_size, &vector_initializator);
    }
    | matrix_element COMMA vector_decl
    {
        $$ = malloc(strlen($1) + strlen(",") + strlen($3));
        strcpy($$, $1);
        strcat($$, ",");
        strcat($$, $3);
        free($1);
        free($3);

        if(!validate_matrix_column_size(matrix_current_vec_size, vector_size))
        {
           yyerror("syntax error, matrix columns must be of equal size");
        }

        matrix_current_vec_size = vector_size;

        free_vector(&vector_index, &vector_max_size, &vector_size, &vector_initializator);
    }
    ;

vector_decl:
    OPEN_VECTOR vector_elements CLOSE_VECTOR
    {
         if(vector_size > 0)
        {
            int strlength = calculate_vector_length(vector_index, vector_initializator);

            $$ = malloc(strlength);
            strcpy($$, "{");

            int i;
            for(i=0; i<vector_index-1; i++)
            {
                strcat($$, vector_initializator[i]);
                strcat($$, ",");
            }
            strcat($$, vector_initializator[i]);
            strcat($$, "}");
        } else
        {
            $$ = malloc(strlen("{}"));
            strcpy($$, "{}");
        }
    }
    ;

vector_elements:
    | vector_elem  
    ;

vector_elem:
    NUMBER_VALUE
    {
        resize(&vector_max_size, vector_index, &vector_initializator);

        vector_initializator[vector_index] = malloc(strlen($1)+2);
        vector_initializator[vector_index] = $1;
        strcat(vector_initializator[vector_index], "f");
        vector_size++;
        vector_index++;
    }
    | vector_elem COMMA NUMBER_VALUE 
    {
        resize(&vector_max_size, vector_index, &vector_initializator);

        vector_initializator[vector_index] = malloc(strlen($3));
        vector_initializator[vector_index] = $3;
        strcat(vector_initializator[vector_index], "f");
        vector_size++;
        vector_index++;
    }
    ;
%%