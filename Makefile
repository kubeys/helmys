SHELL := bash

YS_VERSION := 0.1.94
YS := ys-$(YS_VERSION)

CHART := a-chart
DEBUG := test/debug

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

.PHONY: test
test:
	bash test/test.sh

clean:
	$(RM) -r $(CHART) $(DEBUG)


install-helmys: $(PREFIX)/bin
ifeq (,$(PREFIX))
	$(error requires the 'PREFIX' variable to be set)
endif
	cp bin/helmys $</helmys

install-ys: $(PREFIX)/bin
ifeq (,$(PREFIX))
	$(error requires the 'PREFIX' variable to be set)
endif
	@[[ -f $$PREFIX/bin/$(YS) ]] || ( \
	  set -x; \
	  curl -s https://yamlscript.org/install | \
	  BIN=1 PREFIX="$$PREFIX" VERSION="$(YS_VERSION)" bash \
	)


# For developer testing:
helm-uninstall-all-charts:
ifneq (,$(HELMYS_DEV))
	for n in $$(helm list | tail -n+2 | cut -f1); do \
	  helm uninstall $$n; \
	done
else
	@echo 'Ignoring. Set HELMYS_DEV=1 to uninstall all charts.'
endif
