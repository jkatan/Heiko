#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "util.h"

void resize(int *vector_max_size, int vector_index, char ***vector_initializator)
{
	if(*vector_max_size == vector_index)
    {
	    *vector_max_size += 10;
	    *vector_initializator = (char**) realloc(*vector_initializator, (*vector_max_size)*sizeof(char**));
    }
}

int calculate_vector_length(int vector_index, char **vector_initializator)
{
	int i;
	int strlength = strlen("{");
	int comma_length = strlen(",");
	
	for(i=0; i<vector_index; i++)
	{
	    strlength += strlen(vector_initializator[i]) + comma_length;
	}

	strlength += 2;

	return strlength;
}

void free_vector(int *vector_index, int *vector_max_size, int *vector_size, char ***vector_initializator)
{
	int i;

	for(i=0; i<*vector_index; i++)
	{
	    free((*vector_initializator)[i]);
	}

	free(*vector_initializator);
	*vector_index = 0;
	*vector_max_size = 0;
	*vector_size = 0;
}

int validate_matrix_column_size(int matrix_current_vec_size, int vector_size)
{
	if(matrix_current_vec_size != 0)
    {
	    if(vector_size != matrix_current_vec_size)
	    {
	        return 0;
	    }
    }

    return 1;
}