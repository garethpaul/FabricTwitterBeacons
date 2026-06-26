#!/usr/bin/env python3
import pathlib
import sys


source = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")
helper_start = "func resetBeaconTweetPresentation()"
handler_start = "func locationManager(manager: CLLocationManager!, didRangeBeacons"
handler_end = "func refreshInvoked()"
hide_start = "override func viewWillDisappear(animated: Bool)"
hide_end = "override func viewWillAppear(animated: Bool)"

if source.count(helper_start) != 1:
    raise SystemExit("Beacon presentation reset helper must remain unique.")
if source.count(handler_start) != 1 or source.count(handler_end) != 1:
    raise SystemExit("Beacon ranging callback boundaries must remain unique.")

helper = source.split(helper_start, 1)[1].split(
    "func hasActiveBeaconTweetContext", 1
)[0]
handler = source.split(handler_start, 1)[1].split(handler_end, 1)[0]
hide = source.split(hide_start, 1)[1].split(hide_end, 1)[0]

if "resetBeaconTweetPresentation()" not in hide or "invalidateBeaconTweetContext()" in hide:
    raise SystemExit("Hiding the beacon screen must clear stale tweets through the reset helper.")

helper_contracts = (
    "invalidateBeaconTweetContext()",
    "self.tweets = []",
    "if label.superview == nil",
    "self.view.addSubview(label)",
    "if activityIndicator.superview == nil",
    "activityIndicator.startAnimating()",
    "self.view.addSubview(activityIndicator)",
)
for contract in helper_contracts:
    if helper.count(contract) != 1:
        raise SystemExit(f"Reset helper must contain exactly one {contract!r} contract.")

positions = [helper.index(contract) for contract in helper_contracts]
if positions != sorted(positions):
    raise SystemExit("Reset helper must invalidate, clear, and restore waiting UI in order.")

if source.count("resetBeaconTweetPresentation()") != 6:
    raise SystemExit("Screen hide and all four active-context loss paths must use the reset helper.")

if "setupView()" in handler:
    raise SystemExit("Beacon ranging callbacks must not rerun full view setup.")

if handler.count("resetBeaconTweetPresentation()") != 3:
    raise SystemExit("Nil, proximity-transition, and no-known-beacon paths must reset presentation.")
