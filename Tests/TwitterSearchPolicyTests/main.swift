import Foundation

private var failureCount = 0

private func expect(_ candidate: String?, accepted expected: Bool, _ message: String) {
    let actual = isCanonicalTweetID(candidate)
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect("1", accepted: true, "minimum decimal ID")
expect("12345678901234567890", accepted: true, "maximum decimal ID")
expect("0", accepted: false, "zero ID")
expect("01", accepted: false, "leading zero")
expect(nil, accepted: false, "missing ID")
expect("", accepted: false, "empty ID")
expect("123456789012345678901", accepted: false, "oversized ID")
expect(" 123", accepted: false, "leading whitespace")
expect("123\n", accepted: false, "control character")
expect("１２３", accepted: false, "Unicode digits")
expect("12.3", accepted: false, "non-decimal punctuation")

if failureCount > 0 {
    exit(1)
}

print("TwitterSearchPolicy behavioral tests passed")
