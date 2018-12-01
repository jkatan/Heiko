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

void printsumarrays()
{
	printf("public static float[] sumarrays (float[] arr1, float[] arr2){\nfloat ret[] = new float[Math.max(arr1.length, arr2.length)];\nfor(int i = 0; i < Math.min(arr1.length, arr2.length); i++){\nret[i] = arr1[i] + arr2[i];\n}for(int i = Math.min(arr1.length, arr2.length); i < Math.max(arr1.length, arr2.length); i++){\nif(arr1.length < arr2.length){\nret[i] = arr2[i];\n}\nelse{\nret[i] = arr1[i];\n}\n}\nreturn ret;\n}\n");
}

void printsubarrays()
{
	printf("public static float[] subarrays(float[] arr1, float[] arr2){\nfloat ret[] = new float[Math.max(arr1.length, arr2.length)];\nfor(int i = 0; i < Math.min(arr1.length, arr2.length); i++){\nret[i] = arr1[i] - arr2[i];\n}\n	for(int i = Math.min(arr1.length, arr2.length); i < Math.max(arr1.length, arr2.length); i++){\nif(arr1.length < arr2.length){\nret[i] = -arr2[i];\n}\nelse{\nret[i] = arr1[i];\n}\n}\nreturn ret;\n}\n");
}

void printmultiarrays()
{
	printf("public static float multarrays(float[] arr1, float[] arr2){\nfloat ret = 0;\nfor(int i = 0; i < Math.min(arr1.length, arr2.length); i++){\nret += (arr1[i] * arr2[i]);\n}\nreturn ret;\n}\n");
}

void printsummatrix()
{
	printf("public static float[][] summatrix(float[][] m1, float[][] m2){\nfloat[][] ret = new float[Math.max(m1.length, m2.length)][Math.max(m1[0].length, m2[0].length)];\nfor(int i = 0; i < Math.max(m1.length, m2.length); i++){\nif(i < Math.min(m1.length, m2.length)){\nfor(int j = 0; j < Math.max(m1[0].length, m2[0].length); j++){\nif(j < Math.min(m1[0].length, m2[0].length)){\nret[i][j] = m1[i][j] + m2[i][j];\n}\nelse if(m1[0].length > m2[0].length){\nret[i][j] = m1[i][j];\n}\nelse{\nret[i][j] = m2[i][j];\n}\n}\n}\nelse if(m1.length > m2.length){\nfor(int j = 0; j < m1[0].length; j++){\nret[i][j] = m1[i][j];\n}\n}\nelse{\nfor(int j = 0; j < m2[0].length; j++){\nret[i][j] = m2[i][j];\n}\n}\n}\nreturn ret;\n}\n");
}

void printsubmatrix()
{
	printf("public static float[][] submatrix(float[][] m1, float[][] m2){\nfloat[][] ret = new float[Math.max(m1.length, m2.length)][Math.max(m1[0].length, m2[0].length)];\nfor(int i = 0; i < Math.max(m1.length, m2.length); i++){\nif(i < Math.min(m1.length, m2.length)){\nfor(int j = 0; j < Math.max(m1[0].length, m2[0].length); j++){\nif(j < Math.min(m1[0].length, m2[0].length)){\nret[i][j] = m1[i][j] - m2[i][j];\n}\nelse if(m1[0].length > m2[0].length){\nret[i][j] = m1[i][j];\n}\nelse{\nret[i][j] = -m2[i][j];\n}\n}\n}\nelse if(m1.length > m2.length){\nfor(int j = 0; j < m1[0].length; j++){\nret[i][j] = m1[i][j];\n}\n}\nelse{\nfor(int j = 0; j < m2[0].length; j++){\nret[i][j] = -m2[i][j];\n}\n}\n}\nreturn ret;\n}\n");
}

void printmultimatrix()
{
	printf("public static float[][] multmatrix(float[][] m1, float[][] m2){\nfloat[][] ret = new float[m1.length][m2[0].length];\nif(m1.length != m2[0].length){\nthrow new RuntimeErrorException(null);\n}\nfor(int i = 0; i < m1.length; i++){\nfor(int j = 0; j < m2[0].length; j++){\nfor(int k = 0; k < m2.length; k++){\nret[i][j] += m1[i][k] * m2[k][j];\n}\n}\n}\nreturn ret;\n}\n");
}

void printprintmatrix()
{
	printf("%s","public static void printmatrix(float[][] m){\nfor(int i = 0; i < m.length; i++){\nfor(int j = 0; j < m[0].length; j++){\nSystem.out.print(m[i][j]);\nif(j != m[0].length - 1){\nSystem.out.print(\", \");\n}\n}\nSystem.out.println(\"\");\n}\n}\n");
}

void printprintarray()
{

	printf("%s","public static void printarray(float[] arr){\nfor(int i = 0; i < arr.length; i++){\nSystem.out.print(arr[i]);\nif(i != arr.length - 1){\nSystem.out.print(\", \");\n}\n}\nSystem.out.println(\"\");\n}\n");

}

void printimportruntimeerror()
{
	printf("import javax.management.RuntimeErrorException;\n");
}

void printscan()
{
	printf("public static String scan(){\n Scanner s = new Scanner(System.in);\n return s.nextLine();\n}\n");
}

void printincludescanner()
{
	printf("import java.util.Scanner;\n");
}

void printgetelementmatrix()
{
	printf("public static float getelementmatrix(float[][] m, int i, int j){\nif(m.length <= i || m[0].length <= j){\nthrow new RuntimeErrorException(null);\n}\nreturn m[i][j];\n}\n");
}

void printgetelementarray()
{
	printf("public static float getelementarray(float[] a, int i){\nif(a.length <= i){\nthrow new RuntimeErrorException(null);\n}\nreturn a[i];\n}\n");
}

void printsetelementmatrix()
{
	printf("public static void setelementmatrix(float[][] m, int i, int j, float value){\nif(m.length <= i || m[0].length <= j){\nthrow new RuntimeErrorException(null);\n}\nm[i][j] = value;\n}\n");
}

void printsetelementarray()
{
	printf("public static void setelementarray(float[] a, int i, float value){\nif(a.length <= i){\nthrow new RuntimeErrorException(null);\n}\na[i] = value;\n}\n");
}

void printimportstringbuilder()
{
	printf("import java.lang.StringBuilder;\n");
}

void printsetstring()
{
	printf("public static String setstring(String stringToModify, int index, String subString)\n{\nStringBuilder stringToReturn = new StringBuilder(stringToModify);\nstringToReturn.replace(index, index + subString.length(), subString);\nreturn stringToReturn.toString();\n}\n");
}