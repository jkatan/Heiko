#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "heikoc.h"

int main(int argc, char **argv)
{
	if(argc <= 1)
	{
		printf("Provide a file to compile\n");
		return 0;
	}

	executeHeikoCompiler(argv[1]);
}

void executeHeikoCompiler(char* filename)
{
	char *command = malloc(strlen(filename) + strlen("cat  | ./compiler > Heiko.java && javac Heiko.java && java Heiko"));

	sprintf(command, "cat %s | ./compiler > Heiko.java && javac Heiko.java && java Heiko", filename);
	execl("/bin/sh", "sh", "-c", command, NULL);
}