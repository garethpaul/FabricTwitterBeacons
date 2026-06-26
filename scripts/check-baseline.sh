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
TWEET_PERMALINK_HOST_PLAN="$ROOT_DIR/docs/plans/2026-06-15-twitter-permalink-host-boundary.md"
TWEET_PERMALINK_HOST_CHECK="$ROOT_DIR/scripts/check-twitter-permalink-host-boundary.py"
TWEET_PERMALINK_EXECUTION_PLAN="$ROOT_DIR/docs/plans/2026-06-16-executable-tweet-permalink-policy-tests.md"
TWEET_PERMALINK_SIGNAL_PLAN="$ROOT_DIR/docs/plans/2026-06-18-tweet-permalink-harness-signal-cleanup.md"
DEVICE_VERIFICATION_PLAN="$ROOT_DIR/docs/plans/2026-06-13-device-beacon-twitter-verification.md"
TWITTER_MAIN_QUEUE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-twitter-main-queue-publication.md"
VIEW_APPEARANCE_PLAN="$ROOT_DIR/docs/plans/2026-06-13-view-appearance-lifecycle-consolidation.md"
VIEW_LIFECYCLE_INVOCATION_DESIGN="$ROOT_DIR/docs/plans/2026-06-25-view-lifecycle-manual-invocation-design.md"
VIEW_LIFECYCLE_INVOCATION_PLAN="$ROOT_DIR/docs/plans/2026-06-25-view-lifecycle-manual-invocation.md"
ORPHANED_WAITING_CONTROLLER_DESIGN="$ROOT_DIR/docs/plans/2026-06-26-orphaned-waiting-controller-design.md"
ORPHANED_WAITING_CONTROLLER_PLAN="$ROOT_DIR/docs/plans/2026-06-26-orphaned-waiting-controller.md"
HIDDEN_RANGING_PLAN="$ROOT_DIR/docs/plans/2026-06-13-hidden-ranging-callback-guard.md"
BEACON_CONTEXT_GENERATION_PLAN="$ROOT_DIR/docs/plans/2026-06-14-beacon-context-generation.md"
STALE_PRESENTATION_PLAN="$ROOT_DIR/docs/plans/2026-06-14-stale-beacon-presentation-reset.md"
STALE_PRESENTATION_CHECK="$ROOT_DIR/scripts/check-stale-beacon-presentation-reset.py"
TWITTER_SEARCH_PARSE_BOUNDARY_PLAN="$ROOT_DIR/docs/plans/2026-06-14-twitter-search-parse-boundary.md"
TWITTER_SEARCH_PARSE_BOUNDARY_CHECK="$ROOT_DIR/scripts/check-twitter-search-parse-boundary.py"
TWITTER_SEARCH_RESULT_SHAPE_CHECK="$ROOT_DIR/scripts/check-twitter-search-result-shape.py"
TWITTER_SEARCH_RESERVATION_PLAN="$ROOT_DIR/docs/plans/2026-06-14-twitter-search-reservation.md"
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
  "settee/TwitterSearchPolicy.swift" \
  "settee/TweetPermalinkPolicy.swift" \
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
  "docs/plans/2026-06-15-twitter-permalink-host-boundary.md" \
  "docs/plans/2026-06-16-executable-tweet-permalink-policy-tests.md" \
  "docs/plans/2026-06-18-tweet-permalink-harness-signal-cleanup.md" \
  "scripts/check-twitter-permalink-host-boundary.py" \
  "scripts/run-tweet-permalink-policy-tests.sh" \
  "scripts/run-twitter-search-policy-tests.sh" \
  "scripts/check-twitter-search-result-shape.py" \
  "Tests/TweetPermalinkPolicyTests/main.swift" \
  "Tests/TwitterSearchPolicyTests/main.swift" \
  "docs/plans/2026-06-13-device-beacon-twitter-verification.md" \
  "docs/plans/2026-06-13-twitter-main-queue-publication.md" \
  "docs/plans/2026-06-13-view-appearance-lifecycle-consolidation.md" \
  "docs/plans/2026-06-25-view-lifecycle-manual-invocation-design.md" \
  "docs/plans/2026-06-25-view-lifecycle-manual-invocation.md" \
  "docs/plans/2026-06-26-orphaned-waiting-controller-design.md" \
  "docs/plans/2026-06-26-orphaned-waiting-controller.md" \
  "docs/plans/2026-06-13-hidden-ranging-callback-guard.md" \
  "docs/plans/2026-06-14-beacon-context-generation.md" \
  "docs/plans/2026-06-14-stale-beacon-presentation-reset.md" \
  "scripts/check-stale-beacon-presentation-reset.py" \
  "docs/plans/2026-06-14-twitter-search-parse-boundary.md" \
  "scripts/check-twitter-search-parse-boundary.py" \
  "docs/plans/2026-06-14-twitter-search-reservation.md" \
  "docs/plans/2026-06-09-twitter-log-boundary.md" \
  "docs/plans/2026-06-08-twitter-search-result-limit.md" \
  "docs/plans/2026-06-08-fabric-twitter-beacons-maintenance-baseline.md"; do
  require_file "$path"
done

python3 "$STALE_PRESENTATION_CHECK" "$ROOT_DIR/settee/ViewController.swift"
python3 "$TWEET_PERMALINK_HOST_CHECK" \
  "$ROOT_DIR/settee/TweetPermalinkPolicy.swift" \
  "$ROOT_DIR/settee/ViewController.swift"
python3 "$TWITTER_SEARCH_PARSE_BOUNDARY_CHECK" \
  "$ROOT_DIR/settee/TVSearchAPI.swift" \
  "$TWITTER_SEARCH_PARSE_BOUNDARY_PLAN"
python3 "$TWITTER_SEARCH_RESULT_SHAPE_CHECK" \
  "$ROOT_DIR/settee/TVSearchAPI.swift"

python3 - "$PROJECT" "$MAKEFILE" \
  "$ROOT_DIR/scripts/run-tweet-permalink-policy-tests.sh" \
  "$ROOT_DIR/Tests/TweetPermalinkPolicyTests/main.swift" <<'PY'
import re
import sys
from pathlib import Path

project, makefile, runner, tests = (Path(path).read_text(encoding="utf-8") for path in sys.argv[1:])
if project.count("TweetPermalinkPolicy.swift in Sources") != 2:
    raise SystemExit("TweetPermalinkPolicy must belong to the app target once")
if project.count("/* TweetPermalinkPolicy.swift */") != 3:
    raise SystemExit("TweetPermalinkPolicy project references must remain complete and unique")
if makefile.count("scripts/run-tweet-permalink-policy-tests.sh") != 1:
    raise SystemExit("Every Make gate must invoke the executable tweet permalink tests once")
runner_contract = (
    "-D EXECUTABLE_POLICY_TESTS",
    "settee/TweetPermalinkPolicy.swift",
    "Tests/TweetPermalinkPolicyTests/main.swift",
    'mktemp -d "${TMPDIR:-/tmp}/tweet-permalink-policy-tests.XXXXXX"',
    "trap cleanup 0",
)
if any(runner.count(fragment) != 1 for fragment in runner_contract):
    raise SystemExit("Tweet permalink runner must compile production policy with bounded cleanup")
signal_handler = re.compile(
    r'''handle_signal\(\) \{\s*'''
    r'''status=\$1\s*'''
    r'''trap - 0 1 2 15\s*'''
    r'''cleanup\s*'''
    r'''exit "\$status"\s*'''
    r'''\}'''
)
if not signal_handler.search(runner):
    raise SystemExit("Tweet permalink runner signals must clean temporary output before exiting")
for signal, status in ((1, 129), (2, 130), (15, 143)):
    binding = f"trap 'handle_signal {status}' {signal}"
    if runner.count(binding) != 1:
        raise SystemExit(f"Tweet permalink runner must retain signal binding: {binding}")
test_contract = (
    'accepted: true, "Twitter host"',
    'accepted: true, "www Twitter host"',
    'accepted: true, "X host"',
    'accepted: true, "www X host"',
    'accepted: true, "mixed-case host"',
    'accepted: false, "missing URL"',
    'accepted: false, "non-HTTPS scheme"',
    'accepted: false, "userinfo"',
    'accepted: false, "password"',
    'accepted: false, "explicit port"',
    'accepted: false, "unlisted subdomain"',
    'accepted: false, "host suffix"',
    'accepted: false, "host prefix"',
    'accepted: false, "unrelated host"',
    'accepted: false, "hostless URL"',
)
if any(tests.count(fragment) != 1 for fragment in test_contract):
    raise SystemExit("Executable tweet permalink tests must preserve every accepted and hostile URL case")
PY

for signal_cleanup_plan_contract in \
  "status: completed" \
  "## Status: Completed" \
  'exit-only signal traps leave `tweet-permalink-policy-tests.*` behind' \
  "success, compiler failure, and bounded termination" \
  "284056cd451bc3ef2093c87392bd40d9a8461435" \
  "27746852183" \
  "27746853979"; do
  if ! grep -Fq "$signal_cleanup_plan_contract" "$TWEET_PERMALINK_SIGNAL_PLAN"; then
    printf '%s\n' "Tweet permalink harness signal-cleanup plan must retain evidence: $signal_cleanup_plan_contract" >&2
    exit 1
  fi
done

if ! grep -Fq "status: completed" "$TWITTER_SEARCH_PARSE_BOUNDARY_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$TWITTER_SEARCH_PARSE_BOUNDARY_PLAN" ||
  ! grep -Fq "make check" "$TWITTER_SEARCH_PARSE_BOUNDARY_PLAN"; then
  printf '%s\n' "Twitter search parse boundary plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "HTTP 200 and at most 1 MiB" "$ROOT_DIR/README.md" ||
  ! grep -Fq "HTTP 200 and at most 1 MiB" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "HTTP 200 and at most 1 MiB" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "HTTP 200 and at most 1 MiB" "$ROOT_DIR/CHANGES.md" ||
  ! grep -Fq "HTTP 200 and at most 1 MiB" "$ROOT_DIR/AGENTS.md"; then
  printf '%s\n' "Project guidance must preserve the Twitter search parse boundary." >&2
  exit 1
fi

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
for forbidden in ("func refreshView", "self.viewDidLoad()", "self.viewWillAppear(true)"):
    if forbidden in source:
        raise SystemExit("UIKit lifecycle callbacks must not be exposed as manual refresh behavior: " + forbidden)
start = source.find("func locationManager(manager: CLLocationManager!, didRangeBeacons")
end = source.find("func refreshInvoked()", start)
callback = source[start:end]
guard = callback.find("if !isBeaconScreenVisible")
beacon_access = callback.find("if beacons == nil")
search = callback.find("self.requestTweetsForContext(contextGeneration)")
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

if ! grep -Fq 'override ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))' "$MAKEFILE" ||
  ! grep -Fq 'CHECK_SCRIPT := $(ROOT)/scripts/check-baseline.sh' "$MAKEFILE" ||
  ! grep -Fq '"$(CHECK_SCRIPT)"' "$MAKEFILE"; then
  printf '%s\n' "Makefile must protect, resolve, and run the baseline independently of the caller directory." >&2
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

"$ROOT_DIR/scripts/check-no-committed-fabric-secrets.sh" "$ROOT_DIR"

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

if [ -e "$ROOT_DIR/settee/WaitingController.swift" ]; then
  printf '%s\n' "Orphaned WaitingController.swift must remain absent." >&2
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

if ! grep -Fq "if beacons == nil" "$ROOT_DIR/settee/ViewController.swift"; then
  printf '%s\n' "The active beacon ranging callback must guard missing beacon arrays." >&2
  exit 1
fi

if grep -Fq "topN =" "$ROOT_DIR/settee/RateLimit.swift" ||
  ! grep -Fq "limitTweetIDs" "$ROOT_DIR/settee/RateLimit.swift" ||
  ! grep -Fq "completion(result: limitTweetIDs(tweetArray, maxCount: TwitterSearchResultMaxCount))" "$ROOT_DIR/settee/TVSearchAPI.swift"; then
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

if ! grep -Fq "if tweetIDs.isEmpty" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "var loadingTweetContextGeneration: Int?" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "var beaconTweetContextGeneration = 0" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "beaconTweetContextGeneration += 1" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "func hasActiveBeaconTweetContext(contextGeneration: Int) -> Bool" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "contextGeneration == beaconTweetContextGeneration" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "func finishLoadingTweets(contextGeneration: Int)" "$ROOT_DIR/settee/ViewController.swift"; then
  printf '%s\n' "Tweet loading must bind active context and in-flight ownership to one generation." >&2
  exit 1
fi

python3 - "$ROOT_DIR/settee/ViewController.swift" <<'PY'
import sys
from pathlib import Path

source = Path(sys.argv[1]).read_text(encoding="utf-8")
finish_start = source.find("func finishLoadingTweets(contextGeneration: Int)")
finish_end = source.find("func requestTweetsForContext", finish_start)
finish = source[finish_start:finish_end]
finish_contract = (
    "if loadingTweetContextGeneration == contextGeneration",
    "loadingTweetContextGeneration = nil",
)
positions = [finish.find(item) for item in finish_contract]
if -1 in positions or positions != sorted(positions):
    raise SystemExit("Only the matching generation may clear in-flight tweet ownership")

request_start = source.find("func requestTweetsForContext(contextGeneration: Int)")
request_end = source.find("func loadTweets", request_start)
request = source[request_start:request_end]
required_request = (
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "if self.loadingTweetContextGeneration == contextGeneration",
    "self.loadingTweetContextGeneration = contextGeneration",
    "Search()",
    "dispatch_async(dispatch_get_main_queue())",
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "self.finishLoadingTweets(contextGeneration)",
    "if result.isEmpty",
    "self.finishLoadingTweets(contextGeneration)",
    "self.loadTweets(result, contextGeneration: contextGeneration)",
)
positions = []
start = 0
for item in required_request:
    position = request.find(item, start)
    positions.append(position)
    start = position + len(item) if position != -1 else start
if -1 in positions:
    raise SystemExit("Twitter search must reserve generation ownership before dispatch and release empty or stale results")

if source.count("Search()") != 1 or source.count("self.requestTweetsForContext(contextGeneration)") != 2:
    raise SystemExit("Beacon ranging and refresh must share the sole reserved Twitter search path")

load_start = source.find("func loadTweets(tweetIDs: [String], contextGeneration: Int)")
load_end = source.find("override func didReceiveMemoryWarning()", load_start)
load = source[load_start:load_end]

required_load = (
    "if tweetIDs.isEmpty",
    "self.finishLoadingTweets(contextGeneration)",
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "self.finishLoadingTweets(contextGeneration)",
    "logInGuestWithCompletion",
    "if session == nil",
    "self.finishLoadingTweets(contextGeneration)",
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "loadTweetsWithIDs(tweetIDs)",
    "dispatch_async(dispatch_get_main_queue())",
    "self.finishLoadingTweets(contextGeneration)",
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "self.tweets = loadedTweets",
)
positions = []
start = 0
for item in required_load:
    position = load.find(item, start)
    positions.append(position)
    start = position + len(item) if position != -1 else start
if -1 in positions:
    raise SystemExit("Twitter loading must retain generation ownership through login, request, and publication")

range_start = source.find("func locationManager(manager: CLLocationManager!, didRangeBeacons")
range_end = source.find("func refreshInvoked()", range_start)
ranging = source[range_start:range_end]
refresh_end = source.find("// MARK: TWTRTweetViewDelegate", range_end)
refresh = source[range_end:refresh_end]

required_ranging = (
    "if beacons == nil",
    "resetBeaconTweetPresentation()",
    "if previousProximity == 1 && proximity != 1",
    "resetBeaconTweetPresentation()",
    "let contextGeneration = beaconTweetContextGeneration",
    "self.requestTweetsForContext(contextGeneration)",
    "} else if prev == 1 {",
    "resetBeaconTweetPresentation()",
)
positions = []
start = 0
for item in required_ranging:
    position = ranging.find(item, start)
    positions.append(position)
    start = position + len(item) if position != -1 else start
if -1 in positions:
    raise SystemExit("Ranging must reset presentation, capture, and propagate beacon context generations in order")

required_refresh = (
    "let contextGeneration = beaconTweetContextGeneration",
    "if !self.hasActiveBeaconTweetContext(contextGeneration)",
    "self.requestTweetsForContext(contextGeneration)",
)
positions = []
start = 0
for item in required_refresh:
    position = refresh.find(item, start)
    positions.append(position)
    start = position + len(item) if position != -1 else start
if -1 in positions:
    raise SystemExit("Refresh must capture, validate, and propagate its beacon context generation")

authorization_start = source.find("func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus")
authorization_end = source.find("func invalidateBeaconTweetContext()", authorization_start)
authorization = source[authorization_start:authorization_end]
authorization_contract = (
    "} else {",
    "if prev == 1",
    "resetBeaconTweetPresentation()",
    "manager.stopRangingBeaconsInRegion(region)",
)
positions = [authorization.find(item) for item in authorization_contract]
if -1 in positions or positions != sorted(positions):
    raise SystemExit("Authorization loss must invalidate close beacon context before ranging stops")

if source.count("invalidateBeaconTweetContext()") != 2 or source.count(
    "resetBeaconTweetPresentation()"
) != 6:
    raise SystemExit("Beacon context must reset on hide and all four active-context loss paths")
if source.count("dispatch_async(dispatch_get_main_queue())") != 3 or load.count(
    "dispatch_async(dispatch_get_main_queue())"
) != 2 or load.count("self.tweets = loadedTweets") != 1:
    raise SystemExit("Twitter callbacks must retain three main-queue boundaries and one publication")

generation = 0
old_request = generation
generation += 1
new_request = generation
if old_request == generation or new_request != generation:
    raise SystemExit("Synthetic leave-and-return generation model did not reject the old request")
PY

if ! grep -Fq "status: completed" "$TWITTER_SEARCH_RESERVATION_PLAN" ||
  ! grep -Fq "make check" "$TWITTER_SEARCH_RESERVATION_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$TWITTER_SEARCH_RESERVATION_PLAN"; then
  printf '%s\n' "Twitter search reservation plan must record completed verification." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md"; do
  if ! grep -Fq "before Twitter search dispatch" "$document"; then
    printf '%s\n' "$document must document Twitter search generation reservation." >&2
    exit 1
  fi
done

if ! grep -Fq "if let loadedTweetObjects = twttrs" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "if let tweet = i as? TWTRTweet" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "self.tweets = loadedTweets" "$ROOT_DIR/settee/ViewController.swift" ||
  grep -Fq "self.tweets.append(i as TWTRTweet)" "$ROOT_DIR/settee/ViewController.swift" ||
  ! grep -Fq "Loaded TwitterKit tweet responses" "$ROOT_DIR/SECURITY.md"; then
  printf '%s\n' "Loaded TwitterKit tweets must be type-checked before replacing table contents." >&2
  exit 1
fi

for permalink_contract in \
  "func isCanonicalTweetPermalinkHost(host: String?) -> Bool" \
  "func validatedTweetPermalink(url: NSURL?) -> NSURL?" \
  "func isCanonicalTweetPermalinkPath" \
  'normalizedScheme == "https"' \
  "candidate.user == nil" \
  "candidate.password == nil" \
  "candidate.port == nil" \
  "isCanonicalTweetPermalinkHost(candidate.host)"; do
  if ! grep -Fq "$permalink_contract" "$ROOT_DIR/settee/TweetPermalinkPolicy.swift"; then
    printf '%s\n' "Tweet permalink validation contract is missing: $permalink_contract" >&2
    exit 1
  fi
done

for navigation_contract in \
  "validatedTweetPermalink(tweet?.permalink)" \
  'println("Tweet permalink was rejected")'; do
  if ! grep -Fq "$navigation_contract" "$ROOT_DIR/settee/ViewController.swift"; then
    printf '%s\n' "Tweet permalink navigation contract is missing: $navigation_contract" >&2
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

if ! grep -Fq "status: completed" "$TWEET_PERMALINK_HOST_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$TWEET_PERMALINK_HOST_PLAN" ||
  ! grep -Fq "make check" "$TWEET_PERMALINK_HOST_PLAN"; then
  printf '%s\n' "Twitter permalink host boundary plan must record completed verification." >&2
  exit 1
fi

python3 - "$TWEET_PERMALINK_EXECUTION_PLAN" <<'PY'
import re
import sys
from pathlib import Path

plan = Path(sys.argv[1]).read_text(encoding="utf-8")
frontmatter = plan.split("---", 2)[1]
verification = plan.split("## Verification Completed\n", 1)[-1]
required = (
    "all four Make gates passed",
    "absolute Makefile path passed",
    "production policy mutation failed",
    "navigation delegation mutation failed",
    "Xcode target membership mutation failed",
    "accepted URL mutation failed",
    "hostile URL mutation failed",
    "plan evidence mutation failed",
    "6b62a4e33010c9f64ae99e7ddfb938d266200347",
    "push run `27643147108`",
    "pull-request run `27643148489`",
)
if (
    re.findall(r"^status: .+$", frontmatter, flags=re.MULTILINE) != ["status: completed"]
    or "## Verification Completed\n" not in plan
    or any(item not in verification for item in required)
    or re.search(r"\b(?:pending|todo|tbd|not run|not yet)\b", verification, re.IGNORECASE)
):
    raise SystemExit("Executable tweet permalink test plan must retain completed evidence")
PY

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md" "$DEVICE_VERIFICATION"; do
  if ! grep -Fq "canonical Twitter and X hosts with no explicit port" "$document"; then
    printf '%s\n' "$document must document the canonical Twitter permalink host boundary." >&2
    exit 1
  fi
done

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

for lifecycle_document in \
  "$ROOT_DIR/README.md" \
  "$ROOT_DIR/SECURITY.md" \
  "$ROOT_DIR/VISION.md" \
  "$ROOT_DIR/AGENTS.md" \
  "$DEVICE_VERIFICATION"; do
  if ! grep -Fq "explicit helpers" "$lifecycle_document"; then
    printf '%s\n' "$lifecycle_document must preserve framework-owned lifecycle guidance." >&2
    exit 1
  fi
done

if ! grep -Fq "## Status: Accepted" "$VIEW_LIFECYCLE_INVOCATION_DESIGN" ||
  ! grep -Fq 'Remove `refreshView()`' "$VIEW_LIFECYCLE_INVOCATION_DESIGN" ||
  ! grep -Fq "## Status: Completed" "$VIEW_LIFECYCLE_INVOCATION_PLAN" ||
  ! grep -Fq "Three isolated hostile mutations" "$VIEW_LIFECYCLE_INVOCATION_PLAN" ||
  ! grep -Fq "28212364799" "$VIEW_LIFECYCLE_INVOCATION_PLAN" ||
  ! grep -Fq "28212365061" "$VIEW_LIFECYCLE_INVOCATION_PLAN"; then
  printf '%s\n' "Manual lifecycle invocation plans must preserve the accepted design and completed evidence." >&2
  exit 1
fi

if ! grep -Fq "## Status: Accepted" "$ORPHANED_WAITING_CONTROLLER_DESIGN" ||
  ! grep -Fq 'Delete `settee/WaitingController.swift`' "$ORPHANED_WAITING_CONTROLLER_DESIGN" ||
  ! grep -Fq "## Status: Completed" "$ORPHANED_WAITING_CONTROLLER_PLAN" ||
  ! grep -Fq "stale aggregate assertion" "$ORPHANED_WAITING_CONTROLLER_PLAN" ||
  ! grep -Fq 'Only the storyboard-backed `ViewController` owns beacon ranging' "$ROOT_DIR/README.md" ||
  ! grep -Fq "Orphaned alternate beacon controllers must remain absent" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Keep orphaned alternate beacon controllers absent" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Keep orphaned alternate beacon controllers absent" "$ROOT_DIR/AGENTS.md" ||
  ! grep -Fq 'orphaned `WaitingController`' "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Orphaned waiting-controller removal evidence and guidance must remain synchronized." >&2
  exit 1
fi

if ! grep -Fq "Search, guest-login, and tweet-load callbacks publish controller and table" "$ROOT_DIR/README.md" ||
  ! grep -Fq "Twitter search, login, and load callback state plus visible table publication" "$ROOT_DIR/SECURITY.md" ||
  ! grep -Fq "Search, guest-login, and tweet-load callbacks publish controller and table" "$ROOT_DIR/VISION.md" ||
  ! grep -Fq "Publish asynchronous Twitter controller and table state on the main queue" "$ROOT_DIR/CHANGES.md"; then
  printf '%s\n' "Project guidance must preserve main-queue Twitter state publication." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$BEACON_CONTEXT_GENERATION_PLAN" ||
  ! grep -Fq "make check" "$BEACON_CONTEXT_GENERATION_PLAN" ||
  ! grep -Fq "hostile mutations were rejected" "$BEACON_CONTEXT_GENERATION_PLAN"; then
  printf '%s\n' "Beacon context generation plan must record completed verification." >&2
  exit 1
fi

if ! grep -Fq "status: completed" "$STALE_PRESENTATION_PLAN" ||
  ! grep -Fq "make check" "$STALE_PRESENTATION_PLAN" ||
  ! grep -Fq "hostile source mutations were rejected" "$STALE_PRESENTATION_PLAN" ||
  ! grep -Fq "No Fabric/Twitter credentials" "$STALE_PRESENTATION_PLAN"; then
  printf '%s\n' "Stale beacon presentation plan must record truthful completed verification." >&2
  exit 1
fi

for document in "$ROOT_DIR/README.md" "$ROOT_DIR/SECURITY.md" "$ROOT_DIR/VISION.md" "$ROOT_DIR/CHANGES.md" "$ROOT_DIR/AGENTS.md"; do
  if ! grep -Fq "generation token" "$document"; then
    printf '%s\n' "$document must document the beacon generation token boundary." >&2
    exit 1
  fi
done

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
