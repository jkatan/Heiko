#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "map.h"


int main(int argc, char const *argv[])
{

	map* m = newmap();
	
	while(1)
	{
		char* action = malloc(10);
		scanf("%s", action);
		if(strcmp(action, "end") == 0)
		{
			break;
		}
		else if(strcmp(action, "check") == 0)
		{
			char* var = malloc(10);
			scanf("%s", var);
			printf("%d\n", checktype(m, var));
		}
		else if(strcmp(action, "add") == 0)
		{
			char* var = malloc(10);
			scanf("%s", var);
			int type;
			scanf("%d", &type);
			printf("%d\n", addvariabletomap(m, type, var));
		}
		else if(strcmp(action, "up") == 0)
		{
			newblock(m);
		}
		else if(strcmp(action, "down") == 0)
		{
			quitlevel(m);
		}
		else
		{
			printf("Wrong!\n");
		}
	}


	return 0;
}