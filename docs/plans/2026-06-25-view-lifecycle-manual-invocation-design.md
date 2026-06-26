# View Lifecycle Manual Invocation Design

## Status: Accepted

## Problem

`ViewController.refreshView()` directly calls `viewDidLoad()` and
`viewWillAppear(true)`. UIKit owns those callbacks. Calling them as ordinary
refresh functions can duplicate controller setup, location authorization,
subviews, navigation-logo installation, ranging, and animation. The method has
no callers, but leaving it available creates a misleading and unsafe refresh
path.

## Constraints

- Preserve the existing visible-screen ranging behavior.
- Preserve `resetBeaconTweetPresentation()` as the explicit presentation reset.
- Do not rerun `setupView()` outside UIKit's normal controller lifecycle.
- Keep the legacy Swift and Xcode project surface unchanged beyond the removal.

## Options Considered

1. **Remove the unused method and prohibit manual lifecycle invocation.** This
   is the smallest change and removes the unsafe API without changing behavior.
2. Rewrite `refreshView()` to call explicit reset helpers. Rejected because the
   method has no callers and `resetBeaconTweetPresentation()` already owns that
   responsibility.
3. Retain the method. Rejected because it encodes an invalid UIKit lifecycle
   model and can duplicate setup if called later.

## Decision

Remove `refreshView()` and add a static regression contract that rejects its
reintroduction and the exact manual calls `self.viewDidLoad()` and
`self.viewWillAppear(true)`. Synchronize maintainer and verification guidance so
future refresh behavior uses explicit helpers instead of UIKit callbacks.

## Validation

- Observe `make check` fail while the unsafe method remains.
- Remove the method and run every Make verification alias.
- Confirm the source still has exactly one framework-owned `viewWillAppear`
  override and the existing presentation reset helper remains intact.
