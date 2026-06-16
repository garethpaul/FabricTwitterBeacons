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
                if isCanonicalTweetPermalinkHost(host: candidate.host) {
#else
                if isCanonicalTweetPermalinkHost(candidate.host) {
#endif
                    return candidate
                }
            }
        }
    }

    return nil
}
