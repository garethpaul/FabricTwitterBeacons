//
//  TVSearchAPI.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//


import Foundation
import TwitterKit

let TwitterSearchResponseMaxBytes = 1024 * 1024
let TwitterSearchResultMaxCount = 20

func acceptsTwitterSearchResponse(response: NSURLResponse?, data: NSData?) -> Bool {
    if let httpResponse = response as? NSHTTPURLResponse {
        if httpResponse.statusCode != 200 {
            return false
        }
    } else {
        return false
    }

    if let responseData = data {
        return responseData.length <= TwitterSearchResponseMaxBytes
    }

    return false
}

func Search(completion: (result: [String]) -> Void) {

    // setup some type aliases to handle regular wording for JSON type objects
    typealias JSON = AnyObject
    typealias JSONDictionary = Dictionary<String, JSON>
    typealias JSONArray = Array<JSON>

    // set an endpoint you can check out the docs via:
    // https://dev.twitter.com/rest/reference/get/search/tweets
    let RESTAPIEndpoint = "https://api.twitter.com/1.1/search/tweets.json"

    // setup the params for the request
    let params = ["q": "#NETFLIX OR #BBCOne", "count": "50"]

    // setup container for an error
    var clientError : NSError?

    // Initialize Twitter
    Twitter.initialize()

    // Send a REQUEST to Twitter using GuestAuthentication e.g. no authenticated user just the app.
    Twitter.sharedInstance().logInGuestWithCompletion{
        (session, error) -> Void in
        if (session != nil) {

            // woohoo we have a session - let's get crazy
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL:  RESTAPIEndpoint, parameters: params, error:&clientError)

            // if the request is ready to rock and roll
            if request != nil {

                // let's send us a REST API reuest
                Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                    if (connectionError == nil) {

                        if !acceptsTwitterSearchResponse(response, data: data) {
                            println("Twitter search response was rejected")
                            completion(result: [])
                            return
                        }

                        // Setup a tweet array to contain all of those juicy tweets
                        var tweetArray = Array<String>()
                        var seenTweetIDs = Dictionary<String, Bool>()

                        var jsonError : NSError?
                        let json : AnyObject? =
                        NSJSONSerialization.JSONObjectWithData(data,
                            options: nil,
                            error: &jsonError)

                        if jsonError != nil {
                            println("Twitter search response could not be parsed")
                            completion(result: [])
                            return
                        }

                        // Iterate through JSON response and append the values to the TweetArray
                        if let jsonDictionary = json as? JSONDictionary {
                            if let statuses = jsonDictionary["statuses"] as? JSONArray {

                                // For each tweet in the status block of the json request e.g. {"statuses": [tweets.........
                                for tweet in statuses {
                                    if let tweetDictionary = tweet as? JSONDictionary {
                                        if let id = tweetDictionary["id_str"] as? String {
                                            if isCanonicalTweetID(id) {
                                                if seenTweetIDs[id] == nil {
                                                    seenTweetIDs[id] = true
                                                    tweetArray.append(id)
                                                }
                                            }
                                        }
                                    }

                                    if tweetArray.count == TwitterSearchResultMaxCount {
                                        break
                                    }
                                }
                            }
                        }
                        else {
                            completion(result: [])
                            return
                        }

                        // complete this magical request
                        completion(result: limitTweetIDs(tweetArray, maxCount: TwitterSearchResultMaxCount))
                    }



                    else {
                        println("Twitter search request failed")
                        completion(result: [])
                    }
                }
            }
            else {
                println("Twitter search request could not be created")
                completion(result: [])
            }

        } else {
            println("Twitter guest login failed");
            completion(result: [])
        }
        
    }
}
