%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "util.h"
#include "map.h"

#define NUMBER_TYPE 0
#define STRING_TYPE 1
#define VECTOR_TYPE 2
#define MATRIX_TYPE 3

char **vector_initializator;
int vector_index;
int vector_max_size;
int vector_size;

int matrix_prev_vec_size;
int matrix_current_vec_size;

int variable_type;
int left_type;

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
%type  <str> term
%type  <str> vector_elem
%type  <str> vector_decl
%type  <str> matrix_decl
%type  <str> matrix_element
%type  <str> matrix_elements
%type <varname> initvar
%type <datatype> datatype;
%type  <str> ifblock
%type  <str> elseblock
%type  <str> condition
%type  <str> whileblock
%type  <str> varname_arithmetic
%type <str> assign_var_name
%type <str> assign_var_name_first_time
%type <str> varname_arithmetic_right_side
%type <str> value_arithmetic
%type <str> num_arithmetic
%type <str> string_arithmetic
%type <str> right_num

%token STARTING_BLOCK_SYMBOL ENDING_BLOCK_SYMBOL DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACTION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER CONST ASSIGN_OPERATOR CONSTANT QUOTE OPEN_VECTOR CLOSE_VECTOR TRUE FALSE

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
            newblock(var_types);
        }
        ;

program_end:
        ENDING_BLOCK_SYMBOL { printf("}\n"); quitlevel(var_types);}
        ;

instruction: 
        | vardecl delimiter instruction
        | reinitvar delimiter instruction
        | ifblock instruction
        | whileblock instruction
        ;

delimiter:
        DELIMITER { printf(";\n"); }
        ;

vardecl: datatype initvar { variable_type = -1; }
        | constant_decl datatype initvar { variable_type = -1; }
        ;

constant_decl: 
        CONSTANT { printf("\tfinal "); }
        ;

datatype:
        NUMBER { printf("\tfloat "); variable_type = NUMBER_TYPE; }
        | STRING { printf("\tString "); variable_type = STRING_TYPE; }
        | VECTOR { printf("\tfloat[] "); variable_type = VECTOR_TYPE; }
        | MATRIX { printf("\tfloat[][] "); variable_type = MATRIX_TYPE; }
        ;

initvar: 
        assign_var_name_first_time ASSIGN_OPERATOR varname_arithmetic 
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1); 
        }
        | assign_var_name_first_time ASSIGN_OPERATOR value_arithmetic
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1); 
        }
        | assign_var_name_first_time ASSIGN_OPERATOR term
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1); 
        }
        | assign_var_name_first_time 
        { 
            printf("%s", $1); 
            free($1); 
        }
        ;

reinitvar:
    assign_var_name ASSIGN_OPERATOR varname_arithmetic 
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1); 
        }
    |   assign_var_name ASSIGN_OPERATOR value_arithmetic
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1); 
        }
    |   assign_var_name ASSIGN_OPERATOR term
        {
            printf("%s = %s", $1, $3); 
            free($3); 
            free($1);
        }
    | assign_var_name 
        { 
            printf("%s", $1); 
            free($1); 
        }
        ;

assign_var_name_first_time:
        VAR_NAME 
        {   
            int left_var_type = checktype(var_types, $1);

            if(left_var_type == -1)
            {
                char* var = malloc(strlen($1));
                strcpy(var, $1);
                addvariabletomap(var_types, variable_type, var);
            }
            else
            {
                yyerror("variable already exists");
            } 
        }
        ;

assign_var_name:
        VAR_NAME 
        {   
            int left_var_type = checktype(var_types, $1);

            if(left_var_type == -1)
            {
                yyerror("variable does not exist");
            }
            else
            {
                variable_type = left_var_type;
            } 
        }
        ;

varname_arithmetic:
        varname_arithmetic SUM_CARACHTER varname_arithmetic_right_side 
        {
        	if(left_type == checktype(var_types, $3) && left_type == variable_type)
        	{
        		switch(left_type)
        		{
        			case(NUMBER_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s + %s", $1, $3);
        				break;
        			case(STRING_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s + %s", $1, $3);
        				break;
        			case(VECTOR_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("sumarrays(, )") + 1);
        				sprintf($$, "sumarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_TYPE):
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
        |  varname_arithmetic MULTIPLY_CARACHTER VAR_NAME 
        { 
        	if(left_type == checktype(var_types, $3) && left_type == variable_type)
        	{
        		switch(left_type)
        		{
        			case(NUMBER_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s * %s", $1, $3);
        				break;
        			case(VECTOR_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("multarrays(, )") + 1);
        				sprintf($$, "multarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_TYPE):
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
        |  varname_arithmetic SUBSTRACTION_CARACHTER VAR_NAME 
        {            
            if(left_type == checktype(var_types, $3) && left_type == variable_type)
        	{
        		switch(left_type)
        		{
        			case(NUMBER_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + 4);
            			sprintf($$, "%s - %s", $1, $3);
        				break;
        			case(VECTOR_TYPE):
        				$$ = malloc(strlen($1) + strlen($3) + strlen("subarrays(, )") + 1);
        				sprintf($$, "subarrays(%s, %s)", $1, $3);
        				break;
        			case(MATRIX_TYPE):
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
        |  varname_arithmetic DIVISION_CARACHTER VAR_NAME 
        {
        	if(left_type == checktype(var_types, $3) && left_type == NUMBER_TYPE && left_type == variable_type)
        	{
            	$$ = malloc(strlen($1) + strlen($3) + 4);
            	sprintf($$, "%s / %s", $1, $3);	
        	}
        	else
        	{
        		yyerror("Not a valid arithmetic operation");
        	}
        }
        | VAR_NAME 
        { 
            if(checktype(var_types, $1) == -1)
            {
                yyerror("variable does not exist");
            }

            $$ = malloc(strlen($1)); 
            strcpy($$, $1);
            left_type = checktype(var_types, $1);
            free($1);
        }
        ;

varname_arithmetic_right_side:
    VAR_NAME
    {
            if(checktype(var_types, $1) == -1)
            {
                yyerror("variable does not exist");
            }

            $$ = malloc(strlen($1)); 
            strcpy($$, $1);
            left_type = checktype(var_types, $1);
            free($1);
    }

value_arithmetic:
    num_arithmetic
    | string_arithmetic
    ;

num_arithmetic:
     num_arithmetic SUM_CARACHTER right_num 
        {     
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s + %s", $1, $3);
        }
     | num_arithmetic MULTIPLY_CARACHTER right_num 
        { 
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s * %s", $1, $3);
        }
     | num_arithmetic SUBSTRACTION_CARACHTER right_num 
        {
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s - %s", $1, $3);
        }
     | num_arithmetic DIVISION_CARACHTER right_num 
        {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s / %s", $1, $3);
        }
    |  NUMBER_VALUE
        {
            if(variable_type != NUMBER_TYPE)
            {
                yyerror("incompatible variable type");
            }
            $$ = malloc(strlen($1) + 2); 
            strcpy($$, $1);
            strcat($$, "f");
        }
    ;

right_num:
    NUMBER_VALUE
    {
        if(variable_type != NUMBER_TYPE)
        {
            yyerror("incompatible variable type");
        }

        $$ = malloc(strlen($1) + 2); 
        strcpy($$, $1);
        strcat($$, "f");
    }
    ;

string_arithmetic:
        string_arithmetic SUM_CARACHTER STRING_VALUE 
            {     
             $$ = malloc(strlen($1) + strlen($3) + 4);
             sprintf($$, "%s + %s", $1, $3);
            }
        | STRING_VALUE
            {
                if(variable_type != STRING_TYPE)
                {
                    yyerror("incompatible variable type");
                }
                $$ = $1;
            }
            ;

term:   
    vector_decl 
    { 
        if(variable_type != VECTOR_TYPE)
        {
            yyerror("invalid type");
        }

        $$ = malloc(strlen($1) + strlen("new float[] ")); 
        strcpy($$, "new float[] "); 
        strcat($$, $1);
        free($1);
        free_vector(&vector_index, &vector_max_size, &vector_size, &vector_initializator);
    }
    |  matrix_decl 
    { 
        if(variable_type != MATRIX_TYPE)
        {
            yyerror("invalid type");
        }

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

condition:      TRUE  {printf("true");}
            |   FALSE {printf("false");}
            |   NOT_SYMBOL condition {printf("!");}
    ;

ifblock:        IF_START condition block {printf("if");}
            |   IF_START condition block elseblock {printf("if");}
    ;

elseblock:      ELSE_START block {printf("else");}
            |   ELSE_START ifblock {printf("else");}
    ;

whileblock:     WHILE_START block {printf("while");}
    ;       