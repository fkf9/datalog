# where to install the command line?
BINDIR ?= /usr/bin/

# name of the library
NAME = datalog

CLI = datalog_cli.native
LIB = datalog.cmxa datalog.cma
DOC = datalog.docdir/index.html
TARGETS = $(DOC) $(LIB) $(CLI)
SUBMODULES = containers

INSTALL_LIB = datalog.cmxa datalog.cma datalog.a datalog.cmi datalog.mli

# compilation options
OPTIONS ?= -classic-display

all: prod

tests:
	ocamlbuild -use-ocamlfind -I datalog -package oUnit tests/run_tests.native

prod: $(SUBMODULES) 
	ocamlbuild $(OPTIONS) -tag noassert $(TARGETS)

debug: $(SUBMODULES) 
	ocamlbuild $(OPTIONS) -tag debug $(TARGETS)

profile: $(SUBMODULES) 
	ocamlbuild $(OPTIONS) -tag profile $(TARGETS)

clean:
	ocamlbuild -clean

install: prod
	ocamlfind install $(NAME) META $(addprefix _build/,$(INSTALL_LIB))
	cp _build/$(CLI) $(BINDIR)/datalog_cli

tags:
	otags **/*.ml{,i}

containers:
	make -C containers

.PHONY: all clean install tags tests submodules
