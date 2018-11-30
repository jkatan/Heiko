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
		int level;
		int type;
		int initialized;
		int final;
		char* varname;
		mapnodepointer next;

	}mapnode;

	typedef struct  map
	{
		int level;
		mapnodepointer first;

	}map;

	map* newmap();
	int addvariabletomap(map* m, int type, char* varname, int final);
	mapnodepointer addvariable(mapnodepointer mp, int type, char* varname, int* ans, int level, int final);
	int checktype(map* m, char* varname);
	void newblock(map* m);
	void quitlevel(map* m);
	mapnodepointer deletenodes(mapnodepointer mp, int level);
	int isinitialized(map* m, char* varname);
	int initializevariable(map* m, char* varname);
	int isconst(map* m, char* varname);
	void printmap(map* m);

#endif