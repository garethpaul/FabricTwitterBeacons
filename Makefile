ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
CHECK_SCRIPT := $(ROOT)/scripts/check-baseline.sh
SWIFTC ?= swiftc

.PHONY: build check lint test

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-tweet-permalink-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable tweet permalink policy tests skipped"; \
	fi
	"$(CHECK_SCRIPT)"

lint: check

test: check

build: check
