override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
CHECK_SCRIPT := $(ROOT)/scripts/check-baseline.sh
SWIFTC ?= swiftc

.PHONY: build check lint test

check:
	@if command -v "$(SWIFTC)" >/dev/null 2>&1; then \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-tweet-permalink-policy-tests.sh" && \
		SWIFTC="$(SWIFTC)" "$(ROOT)/scripts/run-twitter-search-policy-tests.sh"; \
	else \
		echo "swiftc unavailable; executable policy tests skipped"; \
	fi
	"$(CHECK_SCRIPT)"
	cd "$(ROOT)" && ./tests/test-secret-guard.sh
	cd "$(ROOT)" && ./tests/test-ci-wiring.sh

lint: check

test: check

build: check
