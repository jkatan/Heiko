#ifndef MAP_H
#define MAP_H

	typedef enum additionoptions
	{
		SUCCESS,
		FAILURE
	}additionoptions;

	typedef struct mapnode* mapnodepointer;

	typedef struct mapnode
	{
		int type;
		char* varname;
		mapnodepointer next;

	}mapnode;

	typedef struct  map
	{
		mapnodepointer first;

	}map;

	map* newmap();
	int addvariabletomap(map* m, int type, char* varname);
	mapnodepointer addvariable(mapnodepointer mp, int type, char* varname, int* ans);
	int checktype(map* m, char* varname);

#endif