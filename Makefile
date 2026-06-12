ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
CHECK_SCRIPT := $(ROOT)/scripts/check-baseline.sh

.PHONY: build check lint test

check:
	"$(CHECK_SCRIPT)"

lint: check

test: check

build: check
