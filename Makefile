.PHONY: build check lint test

check:
	./scripts/check-baseline.sh
	./tests/test-secret-guard.sh
	./tests/test-ci-wiring.sh

lint: check

test: check

build: check
