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
int prev_variable_type;
int left_type;
int right_type;

int get_number_operation;
int get_string_operation;

int num_flag;
int get_set_op_flag;
int set_string;
int print_string;

map *var_types;

char* var_init;

struct vector {
    char **elements;
    int current_index;
    int size;
    int max_size;
};

int start_blocks;
int end_blocks;

int yylex();
int yyparse();

void yyerror(const char *str)
{
        fprintf(stderr,"error: %s\n",str);
} 
  
int main()
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
%token <str> PRINT
%type  <str> term
%type  <str> vector_elem
%type  <str> vector_decl
%type  <str> matrix_decl
%type  <str> matrix_element
%type  <str> matrix_elements
%type <varname> initvar
%type <varname> initvarconst
%type  <str> whileblock
%type  <str> varname_arithmetic
%type <str> assign_var_name
%type <str> assign_var_name_first_time
%type <str> assign_var_name_first_time_const
%type <str> varname_arithmetic_right_side
%type <str> value_arithmetic
%type <str> num_arithmetic
%type <str> string_arithmetic
%type <str> right_num
%type <str> op_parenthesis
%type <str> cl_parenthesis
%type <str> num_var_arithmetic
%type <str> right_num_var
%type <str> start_num_arithmetic
%type <str> start_while
%type <str> var_print
%type <str> printvar
%type <str> array_get_operation
%type <str> array_set_operation
%type <str> num_and_num_var_arithmetic
%type <str> value
%type <str> right_side_string_arithmetic
%type <str> set_string_arithmetic
%type <str> vector_set_operation
%type <str> string_set_operation
%type <str> matrix_get_operation

%token START_BLOCK END_BLOCK DELIMITER START_PARENTHESIS END_PARENTHESIS COMMA IS_EQUALS_SYMBOL IS_NOT_EQUALS_SYMBOL GREATER_THAN_SYMBOL GREATER_EQUALS_THAN_SYMBOL LESS_THAN_SYMBOL LESS_EQUAL_THAN_SYMBOL NOT_SYMBOL SUM_CARACHTER MULTIPLY_CARACHTER SUBSTRACTION_CARACHTER DIVISION_CARACHTER WHILE_START IF_START ELSE_START NUMBER ASSIGN_OPERATOR CONSTANT QUOTE OPEN_VECTOR CLOSE_VECTOR TRUE FALSE OR_SYMBOL AND_SYMBOL XOR_SYMBOL READ DOT GET SET

%start starting_block

%%
starting_block: 
        program_start instruction program_end
        ;

program_start:
        START_BLOCK 
        { 
            start_blocks++;
            printimportruntimeerror();
            printincludescanner();
            printimportstringbuilder();
            printf("public class Heiko{\n");
            var_types = newmap();
            newblock(var_types);
            printsumarrays();
            printsubarrays();
            printmultiarrays();
            printsummatrix();
            printsubmatrix();
            printmultimatrix();
            printprintmatrix();
            printprintarray();
            printscan();
            printgetelementmatrix();
            printgetelementarray();
            printsetelementmatrix();
            printsetelementarray();
            printsetstring();
            printf("public static void main(String[] args) \n{\n"); 
        }
        ;

program_end:
        END_BLOCK 
        { 
            end_blocks++; 
            printf("}\n");
            printf("}\n"); 
            quitlevel(var_types); 

            if(start_blocks != end_blocks)
            {
                yyerror("block indentation error");
            }
        }
        ;

block:
    start_block instruction end_block
    ;

start_block: 
    START_BLOCK { start_blocks++; newblock(var_types); printf("\n{\n"); }
    ;

end_block: 
    END_BLOCK { end_blocks++; quitlevel(var_types); printf("}\n"); }
    ;

instruction: 
        | vardecl delimiter instruction
        | reinitvar delimiter instruction
        | ifblock instruction
        | whileblock instruction
        | printvar delimiter instruction
        | array_set_operation delimiter instruction
        | matrix_set_operation delimiter instruction
        ;

delimiter:
        DELIMITER { printf(";\n"); if(var_init != NULL) {initializevariable(var_types, var_init);} var_init = NULL;}
        ;

vardecl: datatype initvar { variable_type = -1;}
        | constant_decl datatype initvarconst { variable_type = -1;}
        ;

constant_decl: 
        CONSTANT { printf("\tfinal "); }
        ;

datatype:
        NUMBER { printf("\tfloat "); variable_type = NUMBER_TYPE; }
        | STRING { printf("\tString "); variable_type = STRING_TYPE;}
        | VECTOR { printf("\tfloat[] "); variable_type = VECTOR_TYPE; }
        | MATRIX { printf("\tfloat[][] "); variable_type = MATRIX_TYPE; }
        ;

initvarconst:  assign_var_name_first_time_const ASSIGN_OPERATOR varname_arithmetic
                {
                    var_init = malloc(strlen($1) + 1);
                    strcpy(var_init, $1);   
                    printf("%s = %s", $1, $3); 
                    free($3); 
                    free($1); 
                }
              | assign_var_name_first_time_const ASSIGN_OPERATOR value_arithmetic
                {
                    var_init = malloc(strlen($1) + 1);
                    strcpy(var_init, $1);
                    printf("%s = %s", $1, $3); 
                    free($3); 
                    free($1); 
                }
              | assign_var_name_first_time_const ASSIGN_OPERATOR term
                {
                    var_init = malloc(strlen($1) + 1);
                    strcpy(var_init, $1);
                    printf("%s = %s", $1, $3); 
                    free($3); 
                    free($1); 
                }
             |  assign_var_name_first_time_const ASSIGN_OPERATOR READ
                {
                    if(checktype(var_types, $1) != STRING_TYPE)
                    {
                        yyerror("Must be String type to read from stdin");
                    }
                    var_init = malloc(strlen($1) + 1);
                    strcpy(var_init, $1);
                    printf("%s = scan()", $1);                
                }

        ;

initvar: 
        assign_var_name_first_time ASSIGN_OPERATOR varname_arithmetic 
        {
            if(!isconst(var_types, $1))
            {
                initializevariable(var_types, $1);
                printf("%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }
        }
        | assign_var_name_first_time ASSIGN_OPERATOR value_arithmetic
        {
            if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }
        }
        | assign_var_name_first_time ASSIGN_OPERATOR term
        {
            if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }
        }
        |  assign_var_name_first_time ASSIGN_OPERATOR READ
            {
                if(checktype(var_types, $1) != STRING_TYPE)
                {
                    yyerror("Must be String type to read from stdin");
                }
                else if(!isconst(var_types, $1))
                {
                    var_init = malloc(strlen($1) + 1);
                    strcpy(var_init, $1);
                    printf("%s = scan()", $1);                
                }
                else
                {
                    yyerror("Can't reinitialize constant variable");
                }

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
            if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("\t%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }

        }
    |   assign_var_name ASSIGN_OPERATOR value_arithmetic
        {
            if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("\t%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }
        }
    |   assign_var_name ASSIGN_OPERATOR term
        {
            if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("\t%s = %s", $1, $3); 
                free($3); 
                free($1); 
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }
        }
    |   assign_var_name ASSIGN_OPERATOR READ
        {
            if(checktype(var_types, $1) != STRING_TYPE)
            {
                yyerror("Must be String type to read from stdin");
            }
            else if(!isconst(var_types, $1))
            {
                var_init = malloc(strlen($1) + 1);
                strcpy(var_init, $1);
                printf("%s = scan()", $1);
            }
            else
            {
                yyerror("Can't reinitialize constant variable");
            }

        }
    | assign_var_name 
        { 
            printf("\t%s", $1); 
            free($1); 
        }
        ;
assign_var_name_first_time_const:
        VAR_NAME 
        {   
            int left_var_type = checktype(var_types, $1);

            if(left_var_type == -1)
            {
                char* var = malloc(strlen($1));
                strcpy(var, $1);
                addvariabletomap(var_types, variable_type, var, 1);
            }
            else
            {
                yyerror("variable already exists");
            } 
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
                addvariabletomap(var_types, variable_type, var, 0);
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
        	if(left_type == right_type && left_type == variable_type && isinitialized(var_types, $1) && isinitialized(var_types, $3))
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
        |  varname_arithmetic MULTIPLY_CARACHTER varname_arithmetic_right_side 
        { 
            if(variable_type == NUMBER_TYPE && left_type == VECTOR_TYPE && left_type == right_type)
            {
                $$ = malloc(strlen($1) + strlen($3) + strlen("multarrays(, )") + 1);
                sprintf($$, "multarrays(%s, %s)", $1, $3);
            }

        	else if(left_type == right_type && left_type == variable_type && isinitialized(var_types, $1) && isinitialized(var_types, $3))
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
        |  varname_arithmetic SUBSTRACTION_CARACHTER varname_arithmetic_right_side 
        {            
            if(left_type == right_type && left_type == variable_type && isinitialized(var_types, $1) && isinitialized(var_types, $3))
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
        |  varname_arithmetic DIVISION_CARACHTER varname_arithmetic_right_side 
        {
        	if(left_type == right_type && left_type == NUMBER_TYPE && left_type == variable_type && isinitialized(var_types, $1) && isinitialized(var_types, $3))
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
            if(checktype(var_types, $1) == -1 || !isinitialized(var_types, $1))
            {
                yyerror("variable does not exist or is not initialized");
            }

            $$ = malloc(strlen($1)); 
            strcpy($$, $1);
            left_type = checktype(var_types, $1);
            free($1);
        }
        | array_get_operation
        {
            if(get_number_operation == 1 && variable_type == NUMBER_TYPE)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                left_type = NUMBER_TYPE;
                free($1);
            }
            else if(get_string_operation == 1 && variable_type == STRING_TYPE)
            {
                get_string_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                left_type = STRING_TYPE;
                free($1);
            }
            else
            {
                yyerror("incompatible variable type");
            }
        }
        | matrix_get_operation
        {
            if(get_number_operation == 1 && variable_type == NUMBER_TYPE)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                left_type = NUMBER_TYPE;
                free($1);
            }
        }
        ;

varname_arithmetic_right_side:
    VAR_NAME
    {
            if(checktype(var_types, $1) == -1 || !isinitialized(var_types, $1))
            {
                yyerror("variable does not exist or is not initialized");
            }
            else
            {
                right_type = checktype(var_types, $1);
                $$ = malloc(strlen($1)); 
                strcpy($$, $1);
            }
            free($1);
    }
    | NUMBER_VALUE
    {
        if(left_type == NUMBER_TYPE)
        {
            $$ = malloc(strlen($1) + 2); 
            strcpy($$, $1);
            strcat($$, "f");
            right_type = NUMBER_TYPE;
        }
        else
            free($1);
    } 
    | STRING_VALUE
    {
        if(left_type == STRING_TYPE)
        {
            $$ = malloc(strlen($1)); 
            strcpy($$, $1);
            right_type = STRING_TYPE;
        }
        else
            free($1);
    }
    | array_get_operation
        {
            if(get_number_operation == 1 && variable_type == NUMBER_TYPE)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                right_type = NUMBER_TYPE;
                free($1);
            }
            else if(get_string_operation == 1 && variable_type == STRING_TYPE)
            {
                get_string_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                right_type = STRING_TYPE;
                free($1);
            }
            else
            {
                yyerror("incompatible variable type");
            }
        }
    | matrix_get_operation
    {
        if(get_number_operation == 1 && variable_type == NUMBER_TYPE)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                right_type = NUMBER_TYPE;
                free($1);
            }
    }
    ;

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
            if(variable_type != NUMBER_TYPE && num_flag != NUMBER_TYPE)
            {
                yyerror("incompatible variable type");
            }
            else 
            {
                $$ = malloc(strlen($1) + 2); 
                strcpy($$, $1);
                strcat($$, "f");
            }
        }
    ;

right_num:
    NUMBER_VALUE
    {
        if(variable_type != NUMBER_TYPE && get_set_op_flag != 1)
        {
            yyerror("incompatible variable type");
        }
        else
        {
            $$ = malloc(strlen($1) + 2); 
            strcpy($$, $1);
            strcat($$, "f");
        }
    }
    | VAR_NAME
    {
            if(checktype(var_types, $1) != NUMBER_TYPE)
            {
                yyerror("type error");
            }
            else
            {
                $$ = malloc(strlen($1)); 
                strcpy($$, $1);
            }
            free($1);
    }
    | array_get_operation
        {
            get_set_op_flag = 1;

            if(get_number_operation == 1)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
            else
            {
                yyerror("incompatible variable type");
            }
        }
    | matrix_get_operation
    {
        get_set_op_flag = 1;

            if(get_number_operation == 1)
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
            else
            {
                yyerror("incompatible variable type");
            }
    }
    ;

string_arithmetic:
        string_arithmetic SUM_CARACHTER right_side_string_arithmetic 
            {   
             $$ = malloc(strlen($1) + strlen($3) + 4);
             sprintf($$, "%s + %s", $1, $3);
            }
        | STRING_VALUE
            {
                if(variable_type != STRING_TYPE && set_string != 1 && print_string != 1)
                {
                    yyerror("incompatible variable");
                }
                $$ = $1;
            }
            ;

right_side_string_arithmetic:
    STRING_VALUE
        {
            if(variable_type != STRING_TYPE && set_string != 1 && print_string != 1)
                {
                    yyerror("incompatible variable type");
                }
                $$ = $1;
        }
    | array_get_operation
            {
                if(get_string_operation == 1)
                {
                    get_string_operation = 0;
                    $$ = malloc(strlen($1));
                    strcpy($$, $1);
                    free($1);
                }
                else
                {
                    yyerror("incompatible variable type");
                }
            }

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

condition:      true_statement 
            |   false_statement  
            |   not_statement condition
            |   op_parenthesis condition or_statement condition cl_parenthesis 
            |   op_parenthesis condition and_statement condition cl_parenthesis 
            |   op_parenthesis condition xor_statement condition cl_parenthesis 
            |   op_parenthesis num_arithmetic_statement is_equals_statement num_arithmetic_statement cl_parenthesis
            |   op_parenthesis num_arithmetic_statement is_not_equals_statement num_arithmetic_statement cl_parenthesis
            |   op_parenthesis num_arithmetic_statement is_greater_statement num_arithmetic_statement cl_parenthesis
            |   op_parenthesis num_arithmetic_statement is_greater_equals_statement num_arithmetic_statement cl_parenthesis 
            |   op_parenthesis num_arithmetic_statement is_less_statement num_arithmetic_statement cl_parenthesis
            |   op_parenthesis num_arithmetic_statement is_less_equals_statement num_arithmetic_statement cl_parenthesis
    ;

num_arithmetic_statement:
    num_and_num_var_arithmetic { printf("%s", $1);}
    ;

num_and_num_var_arithmetic:
    start_num_arithmetic num_arithmetic 
        { 
            num_flag = -1;
            get_set_op_flag = 0;
            $$ = malloc(strlen($2));
            strcpy($$, $2);
            free($2); 
        }
    | num_var_arithmetic 
        { 
            $$ = malloc(strlen($1)); 
            strcpy($$, $1);
            free($1);
        }
    ;

start_num_arithmetic:
    { num_flag = NUMBER_TYPE; }
    ;

num_var_arithmetic:
     num_var_arithmetic SUM_CARACHTER right_num_var 
        {     
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s + %s", $1, $3);
        }
     | num_var_arithmetic MULTIPLY_CARACHTER right_num_var 
        { 
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s * %s", $1, $3);
        }
     | num_var_arithmetic SUBSTRACTION_CARACHTER right_num_var 
        {
         $$ = malloc(strlen($1) + strlen($3) + 4);
         sprintf($$, "%s - %s", $1, $3);
        }
     | num_var_arithmetic DIVISION_CARACHTER right_num_var 
        {
        $$ = malloc(strlen($1) + strlen($3) + 4);
        sprintf($$, "%s / %s", $1, $3);
        }
    |  VAR_NAME
        {
            if(checktype(var_types, $1) != NUMBER_TYPE)
            {
                yyerror("incompatible variable type");
            }
            else
            {
                $$ = malloc(strlen($1) + 2); 
                strcpy($$, $1);
            }
        }
    | array_get_operation
        {
            if(get_number_operation != 1)
            {
                yyerror("incompatible variable type");
            }
            else
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
        }
    | matrix_get_operation
    {
        if(get_number_operation != 1)
            {
                yyerror("incompatible variable type");
            }
            else
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
    }
    ;

right_num_var:
    VAR_NAME
    {
        if(checktype(var_types, $1) != NUMBER_TYPE)
        {
            yyerror("incompatible variable type");
        }
        else
        {
            $$ = malloc(strlen($1) + 1); 
            strcpy($$, $1);
        }
    }
    | NUMBER_VALUE
    {
        $$ = malloc(strlen($1) + 2); 
        strcpy($$, $1);
        strcat($$, "f");
        free($1);
    }
    | array_get_operation
        {
            if(get_number_operation != 1)
            {
                yyerror("incompatible variable type");
            }
            else
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
        }
    | matrix_get_operation
    {
        if(get_number_operation != 1)
            {
                yyerror("incompatible variable type");
            }
            else
            {
                get_number_operation = 0;
                $$ = malloc(strlen($1));
                strcpy($$, $1);
                free($1);
            }
    }
    ;


true_statement:
    TRUE { printf(" true "); }
    ;

false_statement:
    FALSE { printf(" false "); }
    ;

not_statement:
    NOT_SYMBOL { printf(" ! "); }
    ;

or_statement:
    OR_SYMBOL { printf(" || "); }
    ;

and_statement:
    AND_SYMBOL { printf(" && "); }
    ;

xor_statement:
    XOR_SYMBOL { printf(" ^ "); }
    ;

is_equals_statement:
    IS_EQUALS_SYMBOL { printf(" == "); }
    ;

is_not_equals_statement:
    IS_NOT_EQUALS_SYMBOL { printf(" != "); }
    ; 

is_greater_statement:
    GREATER_THAN_SYMBOL { printf(" > "); }
    ;

is_greater_equals_statement:
    GREATER_EQUALS_THAN_SYMBOL { printf(" >= "); }
    ;

is_less_statement:
    LESS_THAN_SYMBOL { printf(" < "); }
    ;

is_less_equals_statement:
    LESS_EQUAL_THAN_SYMBOL { printf(" <= "); }
    ;

op_parenthesis: START_PARENTHESIS {printf("(");}

cl_parenthesis: END_PARENTHESIS {printf(")");}

ifblock:        start_if condition block
            |   start_if condition block elseblock
    ;

start_if:
    IF_START { printf("if"); }
    ;

elseblock:      start_else block 
            |   start_else ifblock
    ;

start_else:
    ELSE_START { printf("else"); }
    ;

whileblock:     start_while condition block
    ;       

start_while:
    WHILE_START { printf("while"); }
    ;

printvar:   var_print
    ;

var_print:  PRINT VAR_NAME {
                            if(!isinitialized(var_types, $2))
                            {
                                yyerror("Variable is not initialized");
                            } 
                            else
                            {
                                switch(checktype(var_types, $2))
                                {
    
                                    case(NUMBER_TYPE):
                                        printf("System.out.println(%s)", $2);
                                        break;
    
                                    case(STRING_TYPE):
                                        printf("System.out.println(%s)", $2);
                                        break;
                                    case(VECTOR_TYPE):
                                        printf("printarray(%s)", $2);
                                        break;
                                    case(MATRIX_TYPE):
                                        printf("printmatrix(%s)", $2);
                                        break;
                                    default:
                                        yyerror("Variable doesn't exist");
                                        break;
                            }


                        } 
                    }
            | start_print string_arithmetic
                {
                    printf("System.out.println(%s)", $2);
                    print_string = 0;
                }
    ;

start_print:
    PRINT { print_string = 1; }

array_get_operation: VAR_NAME DOT GET START_PARENTHESIS value END_PARENTHESIS
    {
        if(!isinitialized(var_types, $1))
        {
            yyerror("Variable is not initialized");
            $$ = "error";
        }
        else
        {
            switch(checktype(var_types, $1))
            {
                case(VECTOR_TYPE):
                    $$ = malloc(strlen($5) + strlen($1) + strlen("getelementarray(,(int)())"));
                    sprintf($$, "getelementarray(%s,(int)(%s))", $1, $5);
                    get_number_operation = 1;
                    free($1);
                    free($5);
                    break;

                case(STRING_TYPE):
                    $$ = malloc(strlen($1) + strlen($5) + strlen("Character.toString(.charAt((int)()))"));
                    sprintf($$, "Character.toString(%s.charAt((int)(%s)))", $1, $5);
                    get_string_operation = 1;
                    free($1);
                    free($5);
                    break;

                default:
                    yyerror("Variable doesn't exist");
                    $$ = "error";
                    break;
            }
        }
    }
    ;

matrix_get_operation: VAR_NAME DOT GET START_PARENTHESIS value COMMA value END_PARENTHESIS
    {
        if(!isinitialized(var_types, $1))
        {
            yyerror("Variable is not initialized");
            $$ = "error";
        }
        else if(checktype(var_types, $1) == MATRIX_TYPE)
        {
                    $$ = malloc(strlen($1) + strlen($5) + strlen($7) + strlen("getelementmatrix(,(int)(),(int)())"));
                    sprintf($$, "getelementmatrix(%s,(int)(%s),(int)(%s))", $1, $5, $7);
                    get_number_operation = 1;
                    free($1);
                    free($5);
                    break;   
        }
        else
        {
            yyerror("incompatible type");
        }
    }
    ;

matrix_set_operation:
    VAR_NAME DOT SET START_PARENTHESIS value COMMA value COMMA value END_PARENTHESIS
    {
        if(!isinitialized(var_types, $1))
        {
            yyerror("Variable is not initialized");
        }
        else if(checktype(var_types, $1) == MATRIX_TYPE)
        {
            printf("setelementmatrix(%s, (int)(%s), (int)(%s), (int)(%s))", $1, $5, $7, $9);
            get_number_operation = 1;
            free($5);
            free($1);
        }
        else
        {
            yyerror("incompatible type");
        }
    }
    ;

array_set_operation:
    vector_set_operation
    | string_set_operation
    ;

vector_set_operation: VAR_NAME DOT SET START_PARENTHESIS value COMMA value END_PARENTHESIS
    {
        if(!isinitialized(var_types, $1))
        {
            yyerror("Variable is not initialized");
        }
        else if(checktype(var_types, $1) == VECTOR_TYPE)
        {
            printf("setelementarray(%s, (int)(%s), (int)(%s))", $1, $5, $7);
            get_number_operation = 1;
            free($5);
            free($1);
        }
        else
        {
            yyerror("incompatible type");
        }
    }

string_set_operation: VAR_NAME DOT SET START_PARENTHESIS value COMMA set_string_arithmetic END_PARENTHESIS
    {
        if(!isinitialized(var_types, $1))
        {
            yyerror("Variable is not initialized");
            free($5);
            free($1);
        }
        else if(checktype(var_types, $1) == STRING_TYPE)
        {
            printf("%s = setstring(%s, (int)(%s), %s)",$1, $1, $5, $7);
            get_string_operation = 1;
            free($5);
            free($1);
        }
        else
        {
            yyerror("incompatible type");
            free($5);
            free($1);
        }
    }
    ;

set_string_arithmetic:
    start_string_arithmetic string_arithmetic 
    { 
        set_string = 0;
        $$ = $2; 
    }

start_string_arithmetic:
    { set_string = 1; }

value: num_and_num_var_arithmetic 
    { 
        $$ = malloc(strlen($1));
        strcpy($$, $1);
        free($1); 
    }
    ;
