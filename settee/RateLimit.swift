//
//  RateLimit.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import Foundation

func limitTweetIDs(tweetIDs: [String], maxCount: Int) -> [String] {
    if maxCount <= 0 {
        return []
    }

    if tweetIDs.count <= maxCount {
        return tweetIDs
    }

    return Array(tweetIDs[0..<maxCount])
}
