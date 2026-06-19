#!/usr/bin/env python3
import sys
from pathlib import Path


source = Path(sys.argv[1]).read_text(encoding="utf-8")

required = (
    "let TwitterSearchResultMaxCount = 20",
    "if let tweetDictionary = tweet as? JSONDictionary",
    'if let id = tweetDictionary["id_str"] as? String',
    "if isCanonicalTweetID(id)",
    "if seenTweetIDs[id] == nil",
    "seenTweetIDs[id] = true",
    "if tweetArray.count == TwitterSearchResultMaxCount",
    "break",
)
for fragment in required:
    if fragment not in source:
        raise SystemExit("Twitter search result boundary missing: " + fragment)

loop = source.split("for tweet in statuses", 1)[1].split("completion(result:", 1)[0]
positions = [loop.find(fragment) for fragment in required[1:]]
if -1 in positions or positions != sorted(positions):
    raise SystemExit("Twitter search entries must be type-checked, validated, deduplicated, and bounded in order")

print("Twitter search result shape checks passed.")
