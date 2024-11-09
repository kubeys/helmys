SHELL := bash
CHART := a-chart
OUT := helmys-install-output.yaml

default:

.PHONY: test
test:
	bash test/test.sh

helm-uninstall-all:
	for n in $$(helm list | tail -n+2 | cut -f1); do \
	  helm uninstall $$n; \
	done

clean:
	$(RM) -r $(CHART)
	$(RM) $(OUT)
