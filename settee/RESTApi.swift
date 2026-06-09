//
//  TVSearchAPI.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//


import Foundation
import TwitterKit

func Search(handle: String, completion: (result: String) -> Void) {

    typealias JSON = AnyObject
    typealias JSONDictionary = Dictionary<String, JSON>
    typealias JSONArray = Array<JSON>

    let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
    let params = ["q": "#NETFLIX OR #BBCONE or #CHANNEL4 or #ITV"]
    var clientError : NSError?
    Twitter.initialize()

    Twitter.sharedInstance().logInWithCompletion{
        (session, error) -> Void in
        if (session != nil) {
            println("Twitter user session established");
            /// go
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL:  statusesShowEndpoint, parameters: params, error:&clientError)

            if request != nil {
                println("Twitter request prepared")
                Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                    if (connectionError == nil) {
                        if data == nil {
                            println("Twitter API response missing data")
                            return
                        }

                        var jsonError : NSError?
                        let json : AnyObject? =
                        NSJSONSerialization.JSONObjectWithData(data,
                            options: nil,
                            error: &jsonError)

                        if jsonError != nil {
                            println("Twitter API response could not be parsed")
                            return
                        }

                        if let jsonDictionary = json as? JSONDictionary {
                            if let statuses = jsonDictionary["statuses"] as? JSONArray {
                                for tweet in statuses {
                                    if let id = tweet["id"] as?Int{
                                        // Avoid logging tweet IDs from account-specific responses.
                                    }
                                }
                            }
                        }

                    }

                    else {
                        println("Twitter API request failed")
                    }
                }
            }
            else {
                println("Twitter request could not be created")
            }

        } else {
            println("Twitter login failed");
        }
        
    }
}

