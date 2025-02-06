all: scanner.l parser.y
	flex scanner.l
	byacc -d parser.y
	gcc -o parser lex.yy.c y.tab.c -lfl

clean:
	rm -f scanner
	rm -f lex.yy.c
	rm -f parser
	rm -f y.tab.c
	rm -f y.tab.h