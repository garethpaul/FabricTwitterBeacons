#!/usr/bin/env python3
"""Verify the static and behavioral tweet permalink host boundary."""

from pathlib import Path
import re
import sys
from urllib.parse import urlsplit

CANONICAL_HOSTS = ("twitter.com", "www.twitter.com", "x.com", "www.x.com")


def accepts(url: str) -> bool:
    candidate = urlsplit(url)
    return (
        candidate.scheme.lower() == "https"
        and candidate.username is None
        and candidate.password is None
        and candidate.port is None
        and candidate.hostname in CANONICAL_HOSTS
    )


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: check-twitter-permalink-host-boundary.py <ViewController.swift>")

    source = Path(sys.argv[1]).read_text(encoding="utf-8")
    required = (
        'candidateHost == "twitter.com"',
        'candidateHost == "www.twitter.com"',
        'candidateHost == "x.com"',
        'candidateHost == "www.x.com"',
        "candidate.port == nil",
        "isCanonicalTweetPermalinkHost(candidate.host)",
    )
    missing = [contract for contract in required if contract not in source]
    if missing:
        raise SystemExit("Missing permalink host contracts: " + ", ".join(missing))

    forbidden = ("hasSuffix", "containsString", "candidateHost !=", "return true")
    helper_start = source.find("func isCanonicalTweetPermalinkHost")
    validator_start = source.find("func validatedTweetPermalink", helper_start)
    helper = source[helper_start:validator_start]
    if helper_start == -1 or validator_start == -1 or any(token in helper for token in forbidden):
        raise SystemExit("Tweet permalink hosts must use exact equality, not substring matching")
    allowed_hosts = re.findall(r'candidateHost == "([^"]+)"', helper)
    if allowed_hosts != list(CANONICAL_HOSTS):
        raise SystemExit("Tweet permalink host allowlist must contain exactly four canonical hosts")

    selection = source.find("func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!)")
    validation = source.find("validatedTweetPermalink(tweet?.permalink)", selection)
    web_view = source.find("let webView = UIWebView", selection)
    request_load = source.find("webView.loadRequest(NSURLRequest(URL: permalink))", selection)
    push = source.find("pushViewController", selection)
    if -1 in (selection, validation, web_view, request_load, push) or not (
        selection < validation < web_view < request_load < push
    ):
        raise SystemExit("Tweet permalink validation must precede request and navigation creation")

    accepted = (
        "https://twitter.com/example/status/1",
        "https://www.twitter.com/example/status/1?ref=app",
        "https://x.com/example/status/1",
        "https://www.x.com/example/status/1#context",
        "https://TWITTER.COM/example/status/1",
    )
    rejected = (
        "http://twitter.com/example/status/1",
        "https://user@twitter.com/example/status/1",
        "https://twitter.com:8443/example/status/1",
        "https://mobile.twitter.com/example/status/1",
        "https://twitter.com.evil.example/status/1",
        "https://evil-twitter.com/example/status/1",
        "https://example.com/twitter/status/1",
        "https:///example/status/1",
    )
    if not all(accepts(url) for url in accepted):
        raise SystemExit("Canonical Twitter permalink matrix rejected a valid URL")
    if any(accepts(url) for url in rejected):
        raise SystemExit("Canonical Twitter permalink matrix accepted an invalid URL")


if __name__ == "__main__":
    main()
