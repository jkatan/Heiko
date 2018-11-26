#include <stdlib.h>
#include <string.h>
#include "map.h"

map* newmap()
{
	map* m = malloc(sizeof(map));
	m->first = NULL;
	return m;
}

int addvariabletomap(map* m, int type, char* varname)
{
	int ans;
	m->first = addvariable(m->first, type, varname, &ans);
	return ans;
}

mapnodepointer addvariable(mapnodepointer mp, int type, char* varname, int* ans)
{
	if(mp == NULL)
	{
		*ans = SUCCESS;
		mapnodepointer node = malloc(sizeof(mapnode));
		node->type = type;
		node->varname = varname;
		node->next = NULL;
		return node;
	}

	if(strcmp((const char*) varname, (const char*) mp->varname) == 0)
	{
		if(mp->type != type)
		{
			*ans = FAILURE;
			return mp;
		}
		else
		{
			*ans = SUCCESS;
			return mp;
		}
	}

	mp->next = addvariable(mp->next, type, varname, ans);

	return mp;
}

int checktype(map* m, char* varname)
{

	mapnodepointer mp = m->first;

	while(mp != NULL)
	{
		if(strcmp((const char*) varname, (const char*)mp->varname) == 0)
		{
			return mp->type;
		}

		mp = mp->next;
	}

	return -1;
}