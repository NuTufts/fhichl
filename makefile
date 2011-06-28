all: grammar_new.pdf parser

grammar.pdf: grammar.tex memarticle.cls
	pdflatex grammar
	rail grammar
	latexmk --pdf grammar

createId.pdf: createId.tex
	pdflatex createId
	latexmk --pdf createId

grammar_draft1.pdf: grammar_draft1.tex memarticle.cls
	pdflatex $<
	rail grammar_draft1
	latexmk --pdf grammar_draft1

grammar_new.pdf: grammar_new.tex memarticle.cls
	latexmk --pdf grammar_new

bnf.y: bnf.y.inc bnf.y.template
	(m4 bnf.y.template > bnf.y)

bnf.tab.h bnf.tab.c: bnf.y
	bison -g -v -d $<

lex.yy.c: bnf.l bnf.tab.h
	flex $<

parser: bnf.tab.c lex.yy.c
	c++ -o parser bnf.tab.c lex.yy.c -lfl -ly

test:   parser
	preprocess tests/pass/test1.fcl
	parser < temp.txt
	preprocess tests/pass/test2.fcl
	parser < temp.txt
	preprocess tests/pass/test3.fcl
	parser < temp.txt
	preprocess tests/pass/test4.fcl
	parser < temp.txt
	preprocess tests/pass/test5.fcl
	parser < temp.txt

preprocess: preprocess.cc
	g++ -o preprocess preprocess.cc
clean:
	rm -f *.rai *.rao *.log *.dvi *.aux *.log *.lof *.out *.qst *.toc *~ *.idx *.ilg *.ind
	rm -f bnf.tab.c bnf.tab.h lex.backup lex.yy.c lex.yy.c 
	rm -f bnf.output bnf.dot bnf.y

clobber: clean
	rm -f grammar.pdf grammar.fdb_latexmk parser

