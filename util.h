#ifndef UTIL_H
#define UTIL_H

void resize(int *vector_max_size, int vector_index, char ***vector_initializator);
int calculate_vector_length(int vector_index, char **vector_initializator);
void free_vector(int *vector_index, int *vector_max_size, int *vector_size, char ***vector_initializator);
int validate_matrix_column_size(int matrix_current_vec_size, int vector_size);
void printsumarrays();
void printsubarrays();
void printmultiarrays();
void printsummatrix();
void printsubmatrix();
void printmultimatrix();
void printprintmatrix();
void printprintarray();
void printimportruntimeerror();
void printscan();
void printincludescanner();

#endif