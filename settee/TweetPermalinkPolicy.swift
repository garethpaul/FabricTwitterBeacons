import Foundation

func isCanonicalTweetPermalinkHost(host: String?) -> Bool {
    if let host = host {
#if EXECUTABLE_POLICY_TESTS
        let candidateHost = host.lowercased()
#else
        let candidateHost = host.lowercaseString
#endif
        return candidateHost == "twitter.com" ||
            candidateHost == "www.twitter.com" ||
            candidateHost == "x.com" ||
            candidateHost == "www.x.com"
    }

    return false
}

#if EXECUTABLE_POLICY_TESTS
func isCanonicalTweetUsername(_ candidate: String) -> Bool {
    let bytes = Array(candidate.utf8)
    if bytes.isEmpty || bytes.count > 15 {
        return false
    }

    return bytes.allSatisfy { byte in
        (byte >= 48 && byte <= 57) ||
            (byte >= 65 && byte <= 90) ||
            (byte >= 97 && byte <= 122) ||
            byte == 95
    }
}
#else
func isCanonicalTweetUsername(candidate: String) -> Bool {
    let bytes = Array(candidate.utf8)
    if bytes.count == 0 || bytes.count > 15 {
        return false
    }

    for byte in bytes {
        let valid = (byte >= 48 && byte <= 57) ||
            (byte >= 65 && byte <= 90) ||
            (byte >= 97 && byte <= 122) ||
            byte == 95
        if !valid {
            return false
        }
    }

    return true
}
#endif

#if EXECUTABLE_POLICY_TESTS
func isCanonicalTweetPermalinkPath(_ path: String?) -> Bool {
    guard let path = path else {
        return false
    }

    let components = path.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
    return components.count == 4 &&
        components[0].isEmpty &&
        isCanonicalTweetUsername(components[1]) &&
        components[2].lowercased() == "status" &&
        isCanonicalTweetID(components[3])
}
#else
func isCanonicalTweetPermalinkPath(path: String?) -> Bool {
    if let path = path {
        let components = path.componentsSeparatedByString("/")
        return components.count == 4 &&
            components[0].isEmpty &&
            isCanonicalTweetUsername(components[1]) &&
            components[2].lowercaseString == "status" &&
            isCanonicalTweetID(components[3])
    }

    return false
}
#endif

func validatedTweetPermalink(url: NSURL?) -> NSURL? {
    if let candidate = url {
        if let scheme = candidate.scheme {
#if EXECUTABLE_POLICY_TESTS
            let normalizedScheme = scheme.lowercased()
#else
            let normalizedScheme = scheme.lowercaseString
#endif
            if normalizedScheme == "https" &&
                candidate.user == nil &&
                candidate.password == nil &&
                candidate.port == nil {
#if EXECUTABLE_POLICY_TESTS
                let hasCanonicalHost = isCanonicalTweetPermalinkHost(host: candidate.host)
#else
                let hasCanonicalHost = isCanonicalTweetPermalinkHost(candidate.host)
#endif
                if hasCanonicalHost {
#if EXECUTABLE_POLICY_TESTS
                    let hasCanonicalPath = isCanonicalTweetPermalinkPath(candidate.path)
#else
                    let hasCanonicalPath = isCanonicalTweetPermalinkPath(candidate.path)
#endif
                    if hasCanonicalPath {
                    return candidate
                    }
                }
            }
        }
    }

    return nil
}
