#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
PROJECT="$ROOT_DIR/settee.xcodeproj/project.pbxproj"
PLAN="$ROOT_DIR/docs/plans/2026-06-08-fabric-twitter-beacons-maintenance-baseline.md"
TWEET_LIMIT_PLAN="$ROOT_DIR/docs/plans/2026-06-08-twitter-search-result-limit.md"
TWITTER_LOG_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-log-boundary.md"
LOCATION_PRIVACY_PLAN="$ROOT_DIR/docs/plans/2026-06-09-location-usage-plist.md"
TWEET_LOAD_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-load-inflight-guard.md"
TWITTER_JSON_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-search-json-guard.md"
TWITTER_REST_JSON_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-rest-json-guard.md"
TWITTER_SEARCH_FAILURE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-search-failure-completion.md"
TWITTER_TWEET_TYPE_PLAN="$ROOT_DIR/docs/plans/2026-06-09-twitter-loaded-tweet-type-guard.md"
BEACON_AUTHORIZATION_PLAN="$ROOT_DIR/docs/plans/2026-06-10-beacon-authorization-boundary.md"
CI_PLAN="$ROOT_DIR/docs/plans/2026-06-10-ci-baseline.md"
STALE_TWEET_PLAN="$ROOT_DIR/docs/plans/2026-06-12-stale-beacon-tweet-results.md"
ROOT_INDEPENDENT_MAKE_PLAN="$ROOT_DIR/docs/plans/2026-06-12-root-independent-makefile.md"
TWEET_PERMALINK_PLAN="$ROOT_DIR/docs/plans/2026-06-13-tweet-permalink-validation.md"
DEVICE_VERIFICATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-device-beacon-twitter-verification.md"
TWITTER_MAIN_QUEUE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-twitter-main-queue-publication.md"
VIEW_APPEARANCE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-view-appearance-lifecycle-consolidation.md"
HIDDEN_RANGING_PLAN="$ROOT_DIR/docs/plans/2026-06-13-hidden-ranging-callback-guard.md"
DEVICE_VERIFICATION="$ROOT_DIR/docs/manual-beacon-twitter-verification.md"
CI_WORKFLOW="$ROOT_DIR/.github/workflows/check.yml"
MAKEFILE="$ROOT_DIR/Makefile"

require_file() {
  path=$1
  if [ ! -f "$ROOT_DIR/$path" ]; then
    printf '%s\n' "Required file missing: $path" >&2
    exit 1
  fi
}

for path in \
  ".gitignore" \
  ".github/workflows/check.yml" \
  "CHANGES.md" \
  "Makefile" \
  "README.md" \
  "SECURITY.md" \
  "VISION.md" \
  "settee.xcodeproj/project.pbxproj" \
  "settee/AppDelegate.swift" \
  "settee/Info.plist" \
  "settee/RateLimit.swift" \
  "settee/ViewController.swift" \
  "settee/TVSearchAPI.swift" \
  "settee/RESTApi.swift" \
  "setteeTests/setteeTests.swift" \
  "docs/manual-beacon-twitter-verification.md" \
  "docs/plans/2026-06-09-location-usage-plist.md" \
  "docs/plans/2026-06-09-twitter-load-inflight-guard.md" \
  "docs/plans/2026-06-09-twitter-search-json-guard.md" \
  "docs/plans/2026-06-09-twitter-rest-json-guard.md" \
  "docs/plans/2026-06-09-twitter-search-failure-completion.md" \
  "docs/plans/2026-06-09-twitter-loaded-tweet-type-guard.md" \
  "docs/plans/2026-06-10-beacon-authorization-boundary.md" \
  "docs/plans/2026-06-10-ci-baseline.md" \
  "docs/plans/2026-06-12-stale-beacon-tweet-results.md" \
  "docs/plans/2026-06-12-root-independent-makefile.md" \
  "docs/plans/2026-06-13-tweet-permalink-validation.md" \
  "docs/plans/2026-06-13-device-beacon-twitter-verification.md" \
  "docs/plans/2026-06-13-twitter-main-queue-publication.md" \
  "docs/plans/2026-06-13-view-appearance-lifecycle-consolidation.md" \
  "docs/plans/2026-06-13-hidden-ranging-callback-guard.md" \
  "docs/plans/2026-06-09-twitter-log-boundary.md" \
  "docs/plans/2026-06-08-twitter-search-result-limit.md" \
  "docs/plans/2026-06-08-fabric-twitter-beacons-maintenance-baseline.md"; do
  require_file "$path"
done

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
start = source.find("func locationManager(manager: CLLocationManager!, didRangeBeacons")
end = source.find("func refreshInvoked()", start)
callback = source[start:end]
guard = callback.find("if !isBeaconScreenVisible")
beacon_access = callback.find("if beacons == nil")
search = callback.find("Search() { (result: [String]) in")
if -1 in (start, end, guard, beacon_access, search) or not (guard < beacon_access < search):
    raise SystemExit("Hidden-screen ranging callbacks must return before beacon access and Twitter search.")
PY

if ! grep -Fq "status: completed" "$HIDDEN_RANGING_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$HIDDEN_RANGING_PLAN"; then
  printf '%s\n' "Hidden ranging callback plan must record completed mutation verification." >&2
  exit 1
fi

if ! grep -Fq "Queued ranging callbacks return before Twitter search" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Hidden-screen ranging callbacks must not start Twitter search" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Queued hidden-screen ranging callbacks return before search" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Ignored queued ranging callbacks after the beacon screen hides" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "Ignore queued ranging callbacks after the beacon screen hides" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve hidden-ranging callback suppression." >&2
  exit 1
fi

if ! grep -Fq 'ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$MAKEFILE" ||
  ! grep -Fq 'CHECK_SCRIPT := $(ROOT)/scripts/check-baseline.sh' "$MAKEFILE" ||
  ! grep -Fq '"$(CHECK_SCRIPT)"' "$MAKEFILE"; then
  printf '%s\n' "Makefile must resolve and run the baseline independently of the caller directory." >&2
  exit 1
fi

if ! grep -Fqi "## Status: Completed" "$ROOT_INDEPENDENT_MAKE_PLAN" ||
  ! grep -Fq "make check" "$ROOT_INDEPENDENT_MAKE_PLAN"; then
  printf '%s\n' "Root-independent Makefile plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "INFOPLIST_FILE = settee/Info.plist;" "$PROJECT" ||
  ! grep -Fq "NSLocationWhenInUseUsageDescription" "$ROOT_DIR/settee/Info.plist" ||
  grep -Fq "NSLocationAlwaysUsageDescription" "$ROOT_DIR/settee/Info.plist" ||
  grep -Fq "NSLocationAlwaysAndWhenInUseUsageDescription" "$ROOT_DIR/settee/Info.plist" ||
  ! grep -Fq "beacon proximity" "$ROOT_DIR/settee/Info.plist"; then
  printf '%s\n' "App Info.plist must document only when-in-use location access for beacon ranging." >&2
  exit 1
fi

if ! grep -Fq "locationManager.requestWhenInUseAuthorization()" "$ROOT_DIR/settee/ViewController.swift" ||
  grep -Fq "requestAlwaysAuthorization" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "didChangeAuthorizationStatus" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "manager.startRangingBeaconsInRegion(region)" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "locationManager.stopRangingBeaconsInRegion(region)" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "override func viewWillAppear" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "status == CLAuthorizationStatus.Authorized && isBeaconScreenVisible" "$ROOT_DIR/settee/ViewController.swift"; then
  printf '%s\n' "Beacon ranging must require foreground authorization and follow view visibility." >&2
  exit 1
fi

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
signature = "override func viewWillAppear(animated: Bool)"
if source.count(signature) != 1:
    raise SystemExit("ViewController must declare exactly one viewWillAppear override.")

body = source.split(signature, 1)[1].split("    func locationManager", 1)[0]
contracts = (
    "super.viewWillAppear(animated)",
    "isBeaconScreenVisible = true",
    "locationManager.startRangingBeaconsInRegion(region)",
    "UIView.animateWithDuration(0.6",
    "self.lView.frame.origin.y = 22",
)
if any(body.count(contract) != 1 for contract in contracts):
    raise SystemExit("View appearance lifecycle contracts must remain unique.")
positions = [body.index(contract) for contract in contracts]
if positions != sorted(positions):
    raise SystemExit("View appearance must publish visibility and ranging before logo animation.")
PY

if grep -Fq "abb870ac2c6cd77fc0a3ee166f786a86748f4eb9" "$PROJECT" ||
  grep -Fq "47d331d25396fd56e08c5c5891c16a003ba5647e584bf8fc07feb0e8ae92ab92" "$PROJECT" ||
  grep -Eq './Fabric\.framework/run [0-9a-f]{32,}' "$PROJECT"; then
  printf '%s\n' "Fabric run script must not contain committed Fabric credentials." >&2
  exit 1
fi

if ! grep -Fq "FABRIC_API_KEY" "$PROJECT" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$PROJECT" ||
  ! grep -Fq 'Skipping Fabric upload' "$PROJECT"; then
  printf '%s\n' "Fabric run script must read credentials from local environment variables." >&2
  exit 1
fi

if grep -Fq "println(beacons)" "$ROOT_DIR/settee/AppDelegate.swift"; then
  printf '%s\n' "Raw beacon payloads must not be logged." >&2
  exit 1
fi

if grep -Fq "println(String(proximity))" "$ROOT_DIR/settee/WaitingController.swift"; then
  printf '%s\n' "Beacon proximity transitions must not be logged." >&2
  exit 1
fi

if grep -R -F "println(error)" "$ROOT_DIR/settee"/*.swift >/dev/null ||
  grep -R -E 'println\(.*(session\.userName|connectionError|clientError|localizedDescription|String\(id\)|\(error\))' "$ROOT_DIR/settee"/*.swift >/dev/null; then
  printf '%s\n' "Twitter account, tweet ID, and raw error details must not be logged." >&2
  exit 1
fi

if ! grep -Fq "Twitter tweet load failed" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "Twitter guest login failed" "$ROOT_DIR/settee/TVSearchAPI.swift" ||
  ! grep -Fq "Avoid logging tweet IDs" "$ROOT_DIR/settee/RESTApi.swift"; then
  printf '%s\n' "Twitter logging must use generic diagnostics without account-specific values." >&2
  exit 1
fi

if ! grep -Fiq "malformed Twitter search JSON" "$ROOT_DIR/README.md" ||
  ! grep -Fiq "Twitter search transport failures" "$ROOT_DIR/README.md" ||
  ! grep -Fiq "malformed Twitter REST JSON" "$ROOT_DIR/README.md" ||
  ! grep -Fiq "Loaded TwitterKit tweet objects" "$ROOT_DIR/README.md" ||
  ! grep -Fiq "malformed Twitter search JSON" "$ROOT_DIR/VISION.md" ||
  ! grep -Fiq "Twitter search transport failures" "$ROOT_DIR/VISION.md" ||
  ! grep -Fiq "malformed Twitter REST JSON" "$ROOT_DIR/VISION.md" ||
  ! grep -Fiq "Loaded TwitterKit tweet responses" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "README and VISION must document malformed Twitter search JSON handling." >&2
  exit 1
fi

beacon_nil_guards=$(grep -R "if beacons == nil" "$ROOT_DIR/settee" | wc -l | tr -d ' ')
if [ "$beacon_nil_guards" -lt 2 ]; then
  printf '%s\n' "Beacon ranging callbacks must guard missing beacon arrays." >&2
  exit 1
fi

if grep -Fq "topN =" "$ROOT_DIR/settee/RateLimit.swift" ||
  ! grep -Fq "limitTweetIDs" "$ROOT_DIR/settee/RateLimit.swift" ||
  ! grep -Fq "completion(result: limitTweetIDs(tweetArray, maxCount: 20))" "$ROOT_DIR/settee/TVSearchAPI.swift"; then
  printf '%s\n' "RateLimit.swift must keep a complete bounded-list helper." >&2
  exit 1
fi

if grep -Fq 'json!["statuses"]' "$ROOT_DIR/settee/TVSearchAPI.swift" ||
  grep -Fq 'json!["statuses"]' "$ROOT_DIR/settee/RESTApi.swift" ||
  ! grep -Fq "if let jsonDictionary = json as? JSONDictionary" "$ROOT_DIR/settee/TVSearchAPI.swift" ||
  ! grep -Fq "if let jsonDictionary = json as? JSONDictionary" "$ROOT_DIR/settee/RESTApi.swift" ||
  ! grep -Fq "Twitter API response missing data" "$ROOT_DIR/settee/RESTApi.swift" ||
  ! grep -Fq "Twitter API response could not be parsed" "$ROOT_DIR/settee/RESTApi.swift" ||
  ! grep -Fq "completion(result: [])" "$ROOT_DIR/settee/TVSearchAPI.swift"; then
  printf '%s\n' "Twitter search JSON parsing must avoid force-unwrapping malformed responses and fail closed." >&2
  exit 1
fi

search_empty_completions=$(grep -F "completion(result: [])" "$ROOT_DIR/settee/TVSearchAPI.swift" | wc -l | tr -d ' ')
if [ "$search_empty_completions" -lt 6 ] ||
  ! grep -Fq "Twitter search request failed" "$ROOT_DIR/settee/TVSearchAPI.swift" ||
  ! grep -Fq "Twitter search request could not be created" "$ROOT_DIR/settee/TVSearchAPI.swift"; then
  printf '%s\n' "Twitter search transport/setup failures must complete with empty results." >&2
  exit 1
fi

if ! grep -Fq "lint: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "test: check" "$ROOT_DIR/Makefile" ||
  ! grep -Fq "build: check" "$ROOT_DIR/Makefile"; then
  printf '%s\n' "Makefile must expose lint, test, and build gates." >&2
  exit 1
fi

loading_reset_count=$(grep -F "self.isLoadingTweets = false" "$ROOT_DIR/settee/ViewController.swift" | wc -l | tr -d ' ')
active_context_count=$(grep -F "if !self.hasActiveBeaconTweetContext()" "$ROOT_DIR/settee/ViewController.swift" | wc -l | tr -d ' ')
if ! grep -Fq "if tweetIDs.isEmpty" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "func hasActiveBeaconTweetContext() -> Bool" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "return isBeaconScreenVisible && prev == 1" "$ROOT_DIR/settee/ViewController.swift" ||
  [ "$active_context_count" -ne 3 ] ||
  ! grep -Fq "self.isLoadingTweets = true" "$ROOT_DIR/settee/ViewController.swift" ||
  [ "$loading_reset_count" -lt 2 ]; then
  printf '%s\n' "Tweet loading must skip empty IDs, mark in-flight requests, and clear the loading flag on failure/completion." >&2
  exit 1
fi

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
checks = []
start = 0
needle = "if !self.hasActiveBeaconTweetContext()"
while True:
    position = source.find(needle, start)
    if position == -1:
        break
    checks.append(position)
    start = position + len(needle)

loading_started = source.find("self.isLoadingTweets = true")
tweet_request = source.find("loadTweetsWithIDs(tweetIDs)")
loading_reset = source.find("self.isLoadingTweets = false", tweet_request)
tweet_assignment = source.find("self.tweets = loadedTweets")

if len(checks) != 3 or not (
    checks[0] < loading_started < checks[1] < tweet_request < loading_reset < checks[2] < tweet_assignment
):
    print("Tweet loading must recheck active beacon context before login, request, and result assignment.", file=sys.stderr)
    raise SystemExit(1)
PY

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()
load_start = source.find("func loadTweets(tweetIDs: [String])")
load_end = source.find("override func didReceiveMemoryWarning()", load_start)
load = source[load_start:load_end]

search_callback = source.find("Search() { (result: [String]) in")
search_dispatch = source.find(
    "dispatch_async(dispatch_get_main_queue())", search_callback
)
load_invocation = source.find("self.loadTweets(result)", search_dispatch)

guest_callback = load.find("logInGuestWithCompletion")
guest_dispatch = load.find("dispatch_async(dispatch_get_main_queue())", guest_callback)
session_failure = load.find("if session == nil", guest_dispatch)
tweet_request = load.find("loadTweetsWithIDs(tweetIDs)", session_failure)
result_dispatch = load.find("dispatch_async(dispatch_get_main_queue())", tweet_request)
loading_reset = load.find("self.isLoadingTweets = false", result_dispatch)
stale_check = load.find("if !self.hasActiveBeaconTweetContext()", loading_reset)
tweet_assignment = load.find("self.tweets = loadedTweets", stale_check)

positions = (
    search_callback,
    search_dispatch,
    load_invocation,
    load_start,
    load_end,
    guest_callback,
    guest_dispatch,
    session_failure,
    tweet_request,
    result_dispatch,
    loading_reset,
    stale_check,
    tweet_assignment,
)
if -1 in positions or not (
    search_callback < search_dispatch < load_invocation and
    guest_callback < guest_dispatch < session_failure < tweet_request <
    result_dispatch < loading_reset < stale_check < tweet_assignment
):
    raise SystemExit(
        "Twitter callbacks must publish state on the main queue after stale-context validation"
    )

if source.count("dispatch_async(dispatch_get_main_queue())") != 3 or load.count(
    "dispatch_async(dispatch_get_main_queue())"
) != 2 or load.count(
    "self.tweets = loadedTweets"
) != 1:
    raise SystemExit(
        "Twitter callbacks must retain three main-queue boundaries and one publication"
    )
PY

if ! grep -Fq "if let loadedTweetObjects = twttrs" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "if let tweet = i as? TWTRTweet" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "self.tweets = loadedTweets" "$ROOT_DIR/settee/ViewController.swift" ||
  grep -Fq "self.tweets.append(i as TWTRTweet)" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "Loaded TwitterKit tweet responses" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "Loaded TwitterKit tweets must be type-checked before replacing table contents." >&2
  exit 1
fi

for permalink_contract in \
  "func validatedTweetPermalink(url: NSURL?) -> NSURL?" \
  'candidate.scheme?.lowercaseString == "https"' \
  "candidate.user == nil" \
  "candidate.password == nil" \
  "if let host = candidate.host" \
  "if !host.isEmpty" \
  "validatedTweetPermalink(tweet?.permalink)" \
  'println("Tweet permalink was rejected")'; do
  if ! grep -Fq "$permalink_contract" "$ROOT_DIR/settee/ViewController.swift"; then
    printf '%s\n' "Tweet permalink validation contract is missing: $permalink_contract" >&2
    exit 1
  fi
done

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()
selection = source.find("func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!)")
validation = source.find("validatedTweetPermalink(tweet?.permalink)", selection)
web_view = source.find("let webView = UIWebView", selection)
request_load = source.find("webView.loadRequest(NSURLRequest(URL: permalink))", selection)
push = source.find("pushViewController", selection)

if -1 in (selection, validation, web_view, request_load, push) or not (
    selection < validation < web_view < request_load < push
):
    raise SystemExit("Tweet permalink validation must precede request and web-view navigation")
PY

if ! grep -Fq "make check" "$ROOT_DIR/README.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_API_KEY" "$ROOT_DIR/README.md" ||
  ! grep -Fq "FABRIC_BUILD_SECRET" "$ROOT_DIR/README.md" ||
  ! grep -Fq "physical-device" "$ROOT_DIR/README.md"; then
  printf '%s\n' "README must document baseline verification and local Fabric/beacon setup." >&2
  exit 1
fi

if ! grep -Fq "scripts/check-baseline.sh" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Fabric run script" "$ROOT_DIR/VISION.md" ||
  ! grep -iq "raw beacon payloads" "$ROOT_DIR/VISION.md"; then
  printf '%s\n' "VISION must describe the current Fabric and beacon privacy guardrails." >&2
  exit 1
fi

if ! grep -Fq "*.xcconfig" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq ".env" "$ROOT_DIR/.gitignore" ||
  ! grep -Fq "!settee/Info.plist" "$ROOT_DIR/.gitignore"; then
  printf '%s\n' "Local credential files must stay ignored while the app Info.plist stays tracked." >&2
  exit 1
fi

if ! grep -Fq "runs-on: macos-15" "$CI_WORKFLOW" ||
  ! grep -Fq "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10" "$CI_WORKFLOW" ||
  ! grep -Fq "persist-credentials: false" "$CI_WORKFLOW" ||
  ! grep -Fq "run: make check" "$CI_WORKFLOW" ||
  ! grep -Fq "permissions:" "$CI_WORKFLOW" ||
  ! grep -Fq "contents: read" "$CI_WORKFLOW" ||
  ! grep -Fq "workflow_dispatch:" "$CI_WORKFLOW" ||
  ! grep -Fq "cancel-in-progress: true" "$CI_WORKFLOW" ||
  ! grep -Fq "timeout-minutes: 10" "$CI_WORKFLOW"; then
  printf '%s\n' "GitHub Actions workflow must run the pinned, read-only macOS baseline." >&2
  exit 1
fi

if ! grep -Fq "GitHub Actions" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "make check" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "no persisted checkout" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "GitHub Actions" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "does not persist checkout" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/plans/2026-06-10-ci-baseline.md" "$ROOT_DIR/README.md"; then
  printf '%s\n' "Project docs must record the GitHub Actions CI baseline." >&2
  exit 1
fi

if command -v xcodebuild >/dev/null 2>&1; then
  xcodebuild -list -project "$ROOT_DIR/settee.xcodeproj"
else
  printf '%s\n' "Skipping xcodebuild project listing: xcodebuild is not installed."
fi

if ! grep -Fq "status: completed" "$PLAN"; then
  printf '%s\n' "Plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWEET_LIMIT_PLAN"; then
  printf '%s\n' "Tweet result limit plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_LOG_PLAN"; then
  printf '%s\n' "Twitter log boundary plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$LOCATION_PRIVACY_PLAN"; then
  printf '%s\n' "Location usage plist plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWEET_LOAD_PLAN"; then
  printf '%s\n' "Tweet load in-flight guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_JSON_PLAN"; then
  printf '%s\n' "Twitter search JSON guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_REST_JSON_PLAN"; then
  printf '%s\n' "Twitter REST JSON guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_SEARCH_FAILURE_PLAN"; then
  printf '%s\n' "Twitter search failure completion plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_TWEET_TYPE_PLAN"; then
  printf '%s\n' "Twitter loaded tweet type guard plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$BEACON_AUTHORIZATION_PLAN"; then
  printf '%s\n' "Beacon authorization plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must be marked completed." >&2
  exit 1
fi

if ! grep -Fq "Status: Completed" "$STALE_TWEET_PLAN" ||
  ! grep -Fq "27391974765" "$STALE_TWEET_PLAN" ||
  ! grep -Fq "27391975696" "$STALE_TWEET_PLAN"; then
  printf '%s\n' "Stale beacon tweet plan must remain completed with hosted verification recorded." >&2
  exit 1
fi

if ! grep -Fq "make check" "$TWITTER_REST_JSON_PLAN"; then
  printf '%s\n' "Twitter REST JSON guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$TWITTER_SEARCH_FAILURE_PLAN"; then
  printf '%s\n' "Twitter search failure completion plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$TWITTER_TWEET_TYPE_PLAN"; then
  printf '%s\n' "Twitter loaded tweet type guard plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "make check" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must record make check verification." >&2
  exit 1
fi

if ! grep -Fq "xcodebuild -list" "$CI_PLAN" ||
  ! grep -Fq "disabled checkout credential persistence" "$CI_PLAN"; then
  printf '%s\n' "CI baseline plan must record hosted Xcode parsing and credential hardening." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWEET_PERMALINK_PLAN" ||
  ! grep -Fq "scheme mutation failed" "$TWEET_PERMALINK_PLAN" ||
  ! grep -Fq "userinfo mutation failed" "$TWEET_PERMALINK_PLAN" ||
  ! grep -Fq "guard bypass mutation failed" "$TWEET_PERMALINK_PLAN" ||
  ! grep -Fq "hosted macOS check" "$TWEET_PERMALINK_PLAN"; then
  printf '%s\n' "Tweet permalink plan must record completed local verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$TWITTER_MAIN_QUEUE_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$TWITTER_MAIN_QUEUE_PLAN" ||
  ! grep -Fq "xcodebuild was unavailable" "$TWITTER_MAIN_QUEUE_PLAN" ||
  ! grep -Fq "No Twitter credentials" "$TWITTER_MAIN_QUEUE_PLAN"; then
  printf '%s\n' "Twitter main-queue publication plan must record completed local verification." >&2
  exit 1
fi

for appearance_plan_contract in \
  "status: completed" \
  "## Status: Completed" \
  "exactly one override" \
  "make build" \
  "Six isolated hostile mutations were rejected" \
  "xcodebuild was unavailable" \
  "No Fabric/Twitter credentials"; do
  if ! grep -Fq "$appearance_plan_contract" "$VIEW_APPEARANCE_PLAN"; then
    printf '%s\n' "View appearance plan must record completed verification: $appearance_plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq 'one `viewWillAppear` lifecycle override' "$ROOT_DIR/README.md" ||
  ! grep -Fq '`viewWillAppear` override so the lifecycle compiles' "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq 'One `viewWillAppear` override' "$ROOT_DIR/VISION.md" ||
  ! grep -Fq 'Consolidated duplicate `viewWillAppear` overrides' "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq 'one `viewWillAppear` override' "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "View appearance lifecycle documentation must remain synchronized." >&2
  exit 1
fi

if ! grep -Fq "Search, guest-login, and tweet-load callbacks publish controller and table" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Twitter search, login, and load callback state plus visible table publication" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Search, guest-login, and tweet-load callbacks publish controller and table" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Publish asynchronous Twitter controller and table state on the main queue" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must preserve main-queue Twitter state publication." >&2
  exit 1
fi

if ! grep -Fq "credential-free HTTPS" "$ROOT_DIR/README.md" ||
  ! grep -Fq "credential-free HTTPS URLs" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "credential-free HTTPS permalinks" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Validated selected tweet permalinks" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must document tweet permalink validation." >&2
  exit 1
fi

python3 - "$DEVICE_VERIFICATION" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
required_sections = {
    "Status And Evidence Boundary": [
        "was not executed during the Linux maintenance session",
        "Static Linux checks and hosted Xcode project listing do not satisfy this physical-device run.",
        "Do not convert `make check`, `xcodebuild -list`, or a green hosted job",
        "owned by the tester or explicitly authorized for testing",
    ],
    "Prerequisites": [
        "physical iOS device",
        "simulator is not sufficient for beacon ranging",
        "controlled test beacon",
        "tester-controlled Twitter account",
        "fixed hashtag search may surface third-party public content",
        "do not copy, screenshot, publish, or retain that content as test evidence",
    ],
    "Authorization And Screen Lifecycle": [
        "only when-in-use location authorization",
        "does not request always-on location access",
        "Deny location access",
        "ranging starts only after authorization",
        "Confirm ranging stops",
    ],
    "Proximity And Tweet Loading": [
        "unknown` proximity",
        "no Twitter guest load begins before",
        "immediate proximity",
        "one bounded search/load begins",
        "overlapping guest/tweet loads do not start",
        "Move from immediate to near proximity",
        "stale tweet rows clear",
        "record any retained-row behavior as an observed limitation",
    ],
    "Stale Async Results": [
        "leave immediate proximity before guest authentication or tweet loading completes",
        "late callback does not repopulate the table",
        "hiding or leaving the beacon screen before completion",
    ],
    "Permalink Navigation": [
        "credential-free HTTPS permalink",
        "non-empty hostname",
        "invalid, non-HTTPS, hostless, or credential-bearing test URL",
        "no request is loaded",
        "rejected URL or tweet details are not logged",
    ],
    "Failure And Privacy Checks": [
        "failure is generic",
        "empty/no replacement results",
        "no beacon UUID/major/minor values",
        "no account, credential, token, or raw error details",
        "Do not mark dependent steps passed.",
    ],
    "Cleanup And Evidence Record": [
        "Rotate a credential immediately",
        "commit SHA",
        "physical device model",
        "pass/fail/blocked result for every checklist item",
        "scrubbed of beacon identifiers",
        "prove source/project contracts only",
    ],
}

sections = {}
current = None
for line in source.splitlines():
    if line.startswith("## "):
        current = line[3:]
        sections[current] = []
    elif current is not None:
        sections[current].append(line)

for heading, phrases in required_sections.items():
    body = "\n".join(sections.get(heading, []))
    if not body:
        raise SystemExit("Beacon/Twitter checklist section missing: " + heading)
    normalized_body = " ".join(body.split())
    for phrase in phrases:
        if " ".join(phrase.split()) not in normalized_body:
            raise SystemExit(
                "Beacon/Twitter checklist assertion missing from "
                + heading
                + ": "
                + phrase
            )
PY

if ! grep -Fq "status: completed" "$DEVICE_VERIFICATION_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$DEVICE_VERIFICATION_PLAN" ||
  ! grep -Fq "physical-device checklist remains unexecuted" "$DEVICE_VERIFICATION_PLAN" ||
  ! grep -Fq "bounded exact-head macOS/CodeQL snapshot" "$DEVICE_VERIFICATION_PLAN"; then
  printf '%s\n' "Device beacon/Twitter verification plan must record completed local verification." >&2
  exit 1
fi

if ! grep -Fq "docs/manual-beacon-twitter-verification.md" "$ROOT_DIR/README.md" ||
  ! grep -Fq "docs/manual-beacon-twitter-verification.md" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq "docs/manual-beacon-twitter-verification.md" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "without claiming that the checklist has been executed" "$ROOT_DIR/VISION.md" ||
  grep -Fq "Add clearer README verification steps for beacon and Twitter behavior" "$ROOT_DIR/VISION.md" ||
  grep -Fq "Add tests or manual checklists around rate limits and proximity handling" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "truthful signed-device checklist" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must preserve truthful beacon/Twitter device verification boundaries." >&2
  exit 1
fi

printf '%s\n' "FabricTwitterBeacons baseline checks passed."
