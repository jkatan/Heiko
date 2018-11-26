include Makefile.inc
	
fromzero: clean all

clean: 
	rm -rf *.o y.tab.c y.tab.h compiler lex.yy.c

all:
	yacc -d parser.y
	flex scanner.l
	$(GCC) -o compiler lex.yy.c y.tab.c map.c map.h -ly $(GCCFLAGS)