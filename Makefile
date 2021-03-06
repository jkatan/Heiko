include Makefile.inc
	
fromzero: clean all

clean: 
	rm -rf *.o y.tab.c y.tab.h compiler lex.yy.c heikoc *.java *.class

all:
	flex scanner.l
	yacc -d parser.y
	$(GCC) -o compiler lex.yy.c y.tab.c map.c map.h util.c util.h -ly $(GCCFLAGS)
	$(GCC) -o heikoc heikoc.c heikoc.h $(GCCFLAGS)