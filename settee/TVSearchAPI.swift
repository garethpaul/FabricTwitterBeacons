//
//  TVSearchAPI.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//


import Foundation
import TwitterKit

func Search(completion: (result: [String]) -> Void) {

    typealias JSON = AnyObject
    typealias JSONDictionary = Dictionary<String, JSON>
    typealias JSONArray = Array<JSON>

    let statusesShowEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
    let params = ["q": "#NETFLIX OR #BBCOne", "count": "50"]
    var clientError : NSError?
    Twitter.initialize()

    Twitter.sharedInstance().logInGuestWithCompletion{
        (session, error) -> Void in
        if (session != nil) {
            /// go
            let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL:  statusesShowEndpoint, parameters: params, error:&clientError)

            if request != nil {


                Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                    if (connectionError == nil) {
                        var tweetArray = Array<String>()
                        var jsonError : NSError?
                        let json : AnyObject? =
                        NSJSONSerialization.JSONObjectWithData(data,
                            options: nil,
                            error: &jsonError)

                        println(json)

                        if let statuses = json!["statuses"] as? JSONArray {
                            for tweet in statuses {
                                if let id = tweet["id_str"] as?String{
                                    tweetArray.append(id)
                                }
                            }
                        }
                        completion(result: tweetArray)
                    }



                    else {
                        println("Error: \(connectionError)")
                    }
                }
            }
            else {
                println("Error: \(clientError)")
            }

        } else {
            println("error: \(error.localizedDescription)");
        }
        
    }
}



