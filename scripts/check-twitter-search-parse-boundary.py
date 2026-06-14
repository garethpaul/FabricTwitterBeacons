#!/usr/bin/env python3
import sys
from pathlib import Path


source = Path(sys.argv[1]).read_text(encoding="utf-8")
plan = Path(sys.argv[2]).read_text(encoding="utf-8")

required = [
    "let TwitterSearchResponseMaxBytes = 1024 * 1024",
    "func acceptsTwitterSearchResponse(response: NSURLResponse?, data: NSData?) -> Bool",
    "if let httpResponse = response as? NSHTTPURLResponse",
    "if httpResponse.statusCode != 200",
    "if let responseData = data",
    "return responseData.length <= TwitterSearchResponseMaxBytes",
    "if !acceptsTwitterSearchResponse(response, data: data)",
]
for fragment in required:
    if fragment not in source:
        raise SystemExit("Twitter search parse boundary missing: " + fragment)

callback_start = source.find("Twitter.sharedInstance().APIClient.sendTwitterRequest(request)")
acceptance = source.find("if !acceptsTwitterSearchResponse(response, data: data)", callback_start)
parse = source.find("NSJSONSerialization.JSONObjectWithData", callback_start)
completion = source.find("completion(result: [])", acceptance)
if -1 in (callback_start, acceptance, parse, completion) or not (
    callback_start < acceptance < completion < parse
):
    raise SystemExit(
        "Twitter search responses must fail closed before JSON parsing."
    )


def accepts(status, body_length, limit=1024 * 1024):
    return status == 200 and body_length is not None and body_length <= limit


accepted = [(200, 0), (200, 1024 * 1024)]
rejected = [
    (None, 0),
    (199, 0),
    (201, 0),
    (204, 0),
    (301, 0),
    (400, 0),
    (401, 0),
    (403, 0),
    (404, 0),
    (429, 0),
    (500, 0),
    (200, None),
    (200, 1024 * 1024 + 1),
]
if not all(accepts(status, length) for status, length in accepted):
    raise SystemExit("Twitter search boundary rejected an allowed response.")
if any(accepts(status, length) for status, length in rejected):
    raise SystemExit("Twitter search boundary accepted a rejected response.")

for evidence in ("status: completed", "hostile mutations were rejected", "make check"):
    if evidence not in plan:
        raise SystemExit("Twitter search parse boundary plan missing: " + evidence)

print("Twitter search parse boundary checks passed.")
