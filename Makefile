SHELL := bash

CHART := a-chart
OUT := helmys-install-output.yaml


default:

.PHONY: test
test:
	bash test/test.sh

uninstall-all:
ifneq (,$(HELMYS_DEV))
	for n in $$(helm list | tail -n+2 | cut -f1); do \
	  helm uninstall $$n; \
	done
endif

clean:
	$(RM) -r $(CHART)
	$(RM) $(OUT)
