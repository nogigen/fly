all: y.tab.c lex.yy.c
	gcc -o p2 y.tab.c
	rm -f lex.yy.c y.tab.c y.output *~
	./p2 < CS315f20_team62.test
y.tab.c: CS315f20_team62.yacc lex.yy.c
	yacc CS315f20_team62.yacc
lex.yy.c: CS315f20_team62.lex
	lex CS315f20_team62.lex