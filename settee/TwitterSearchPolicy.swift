import Foundation

#if EXECUTABLE_POLICY_TESTS
func isCanonicalTweetID(_ candidate: String?) -> Bool {
    guard let candidate = candidate else {
        return false
    }

    let bytes = Array(candidate.utf8)
    if bytes.isEmpty || bytes.count > 20 || bytes[0] == 48 {
        return false
    }

    return bytes.allSatisfy { byte in
        byte >= 48 && byte <= 57
    }
}
#else
func isCanonicalTweetID(candidate: String?) -> Bool {
    if let candidate = candidate {
        let bytes = Array(candidate.utf8)
        if bytes.count == 0 || bytes.count > 20 || bytes[0] == 48 {
            return false
        }

        for byte in bytes {
            if byte < 48 || byte > 57 {
                return false
            }
        }

        return true
    }

    return false
}
#endif
