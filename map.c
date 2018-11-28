#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "map.h"

map* newmap()
{
	map* m = malloc(sizeof(map));
	m->first = NULL;
	m->level = -1;
	return m;
}

int addvariabletomap(map* m, int type, char* varname)
{
	if(m->level < 0)
	{
		return FAILURE;
	}
	int ans;
	m->first = addvariable(m->first, type, varname, &ans, m->level);
	return ans;
}

mapnodepointer addvariable(mapnodepointer mp, int type, char* varname, int* ans, int level)
{
	if(mp == NULL)
	{
		*ans = SUCCESS;
		mapnodepointer node = malloc(sizeof(mapnode));
		node->type = type;
		node->varname = varname;
		node->next = NULL;
		node->level = level;
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

	mp->next = addvariable(mp->next, type, varname, ans, level);

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

void newblock(map* m)
{
	(m->level)++;
}

void quitlevel(map* m)
{
	if(m->level < 0)
	{
		return;
	}

	m->first = deletenodes(m->first, m->level);

	(m->level)--; 
}

mapnodepointer deletenodes(mapnodepointer mp, int level)
{
	if(mp == NULL)
	{
		return NULL;
	}

	if(mp->level == level)
	{
		return NULL;
	}

	mp->next = deletenodes(mp->next, level);

	return mp;
}

void printmap(map* m)
{
	printf("The map:\n");

	mapnodepointer mnp = m->first;

	while(m != NULL)
	{
		printf("%s: %d\n", mnp->varname, mnp->type);
	}
}