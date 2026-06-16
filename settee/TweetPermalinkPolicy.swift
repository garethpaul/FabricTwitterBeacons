import Foundation

func isCanonicalTweetPermalinkHost(host: String?) -> Bool {
    if let host = host {
        let candidateHost = NSString(string: host).lowercaseString
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
            if NSString(string: scheme).lowercaseString == "https" &&
                candidate.user == nil &&
                candidate.password == nil &&
                candidate.port == nil &&
                isCanonicalTweetPermalinkHost(candidate.host) {
                return candidate
            }
        }
    }

    return nil
}
