COQLIB=$(subst /,\/,$(shell coqc -where))

ifeq "$(COQBIN)" ""
  COQBIN=$(dir $(shell which coqtop))/
endif

all: Makefile.coq
	$(MAKE) -f Makefile.coq

install: Makefile.coq
	$(MAKE) -f Makefile.coq install

clean: Makefile.coq
	$(MAKE) -f Makefile.coq clean
	rm -f Makefile.coq

Makefile.coq: _CoqProject
	$(COQBIN)/coq_makefile -f _CoqProject -o Makefile.coq

.merlin:
	cp .tools/merlin .merlin
	sed -i s/COQLIB/"$(COQLIB)"/g .merlin

.PHONY: all clean
