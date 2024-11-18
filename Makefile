SHELL := bash

CHART := a-chart
IN := helmys-install-input.yaml
THRU := helmys-install-thruput.yaml
OUT := helmys-install-output.yaml

ifneq (,$(PREFIX))
ifneq (/$(shell cut -c2- <<<"$(PREFIX)"),$(PREFIX))
$(error $(PREFIX) is not an absolute path)
endif
ifeq (,$(findstring $(PREFIX)/bin,$(PATH)))
$(error $(PREFIX)/bin not in PATH)
endif
endif


default:

install: install-helmys install-ys

install-helmys: $(PREFIX)/bin
ifeq (,$(PREFIX))
	$(error requires the 'PREFIX' variable to be set)
endif
	cp bin/helmys $</helmys

install-ys: $(PREFIX)/bin
ifeq (,$(PREFIX))
	$(error requires the 'PREFIX' variable to be set)
endif
	[[ -f $$PREFIX/bin/ys ]] || \
	  curl -s https://yamlscript.org/install | \
	  BIN=1 PREFIX="$$PREFIX" bash

.PHONY: test
test:
	bash test/test.sh

hel-uninstall-all:
ifneq (,$(HELMYS_DEV))
	for n in $$(helm list | tail -n+2 | cut -f1); do \
	  helm uninstall $$n; \
	done
endif

clean:
	$(RM) -r $(CHART)
	$(RM) $(IN) $(THRU) $(OUT)
