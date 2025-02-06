all: scanner.l parser.y code.h code.c
	flex scanner.l
	byacc -d parser.y
	gcc -o codegen lex.yy.c y.tab.c code.c -lfl

clean:
	rm -f scanner
	rm -f lex.yy.c
	rm -f codegen
	rm -f y.tab.c
	rm -f y.tab.h
	rm -f a.out