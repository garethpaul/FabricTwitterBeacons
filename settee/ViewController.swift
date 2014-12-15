//
//  ViewController.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit
import CoreLocation
import TwitterKit

class ViewController: UITableViewController, CLLocationManagerDelegate, TWTRTweetViewDelegate  {

    // setup Variables
    var lView: UIImageView!
    var container: UIView!
    var label: UILabel!

    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    @IBOutlet var textLabel: UILabel!

    // setup a 'container' for Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var prototypeCell: TWTRTweetTableViewCell?

    let tweetTableCellReuseIdentifier = "TweetCell"

    var isLoadingTweets = false
    var prev: Int?

    // Setup iBeacon
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"), identifier: "couch")

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the View
        self.setupView()
    }

    func setupView(){

        // hide rows with clearColor until filled with Tweets
        container = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200));
        container.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = container

        // put label to find sofa
        label = UILabel(frame: CGRect(x: 0,y: 0,width: 240,height: 50))
        label.text = "Waiting for you to take a seat"
        label.frame.origin.x = (self.view.frame.size.width - label.frame.size.width) / 2
        label.frame.origin.y = (self.view.frame.size.height/2) - 100
        self.view.addSubview(label)

        // Setup navigation bar
        lView = UIImageView(frame: CGRectMake(0, 0, 65, 35))
        lView.image = UIImage(named: "settee")?.imageWithRenderingMode(.AlwaysTemplate)
        lView.tintColor = toColor("ffffff")
        lView.frame.origin.x = (self.view.frame.size.width - lView.frame.size.width) / 2
        lView.frame.origin.y = -lView.frame.size.height - 1
        self.navigationController?.view.addSubview(lView)
        self.navigationController?.view.bringSubviewToFront(lView)

        // Customize the navigation bar.
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: toColor("ff3b30")]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.barTintColor = toColor("ff3b30")

        // put a spinner on the loading and waiting
        activityIndicator.frame = CGRectMake(100, 100, 100, 100);
        activityIndicator.frame.origin.x = (self.view.frame.size.width - activityIndicator.frame.size.width) / 2
        activityIndicator.frame.origin.y = (self.view.frame.size.height/2) - 100
        activityIndicator.startAnimating()
        self.view.addSubview( activityIndicator )

        // Begin the magic with iBeacons
        locationManager.delegate = self

        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Authorized) {
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.startRangingBeaconsInRegion(region)


    }

    func loadTweets(tweetIDs: [String]) {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingTweets {
            return
        }

        // load tweets with guest login
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) in

            // Find the tweets with the tweetIDs
            Twitter.sharedInstance().APIClient.loadTweetsWithIDs(tweetIDs) {
                (twttrs, error) -> Void in

                // If there are tweets do something magical
                if ((twttrs) != nil) {

                    // Loop through tweets and do something
                    for i in twttrs {
                        // Append the Tweet to the Tweets to display in the table view.
                        self.tweets.append(i as TWTRTweet)
                    }
                } else {
                    println(error)
                }
                
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // This is where all the magic happens for determing whether to render the Tweets
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon

            // Set the proximity
            let proximity = closestBeacon.proximity.rawValue

            // If the proximity does not equal the prev value set the user has become closer or further away from the beacon
            if prev != closestBeacon.proximity.rawValue {

                // If the proximity is very close - we should show some TV tweets
                if (proximity == 1){

                    // Create a single prototype cell for height calculations.
                    self.prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: tweetTableCellReuseIdentifier)

                    // Register the identifier for TWTRTweetTableViewCell.
                    self.tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableCellReuseIdentifier)

                    // Send a request to the Search API. Check out TVSearchAPI.swift for details..
                    Search() { (result: [String]) in

                        // Load the array back to display the Tweets
                        self.loadTweets(result)
                    }


                }

                // If the proximity is further away.
                else if proximity == 2 {

                    // If the previous value was 1 aka close then we need to start again remove the tweets and wait for the 
                    // user to come back in range.
                    if prev == 1 {

                        // remove the Label from View
                        label.removeFromSuperview()

                        // remove the activityIndication from the View
                        activityIndicator.removeFromSuperview()

                        // Lets set an empty array for the tweets
                        self.tweets = []

                        // Get going and setup the View Again
                        setupView()
                    }
                }

                // set previous value
                prev = proximity


            }


            // if the tweets have been loaded
            if (tweets.count >= 1) {

                // Stop animating the spinner
                activityIndicator.stopAnimating()

                // Remove the spinner
                activityIndicator.removeFromSuperview()

                // Remove the label
                label.removeFromSuperview()

            }
        }
    }


    func refreshInvoked() {
        // Trigger a load for the most recent Tweets.
        Search() { (result: [String]) in
            self.loadTweets(result)
        }
    }

    // MARK: TWTRTweetViewDelegate
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        // Display a Web View when selecting the Tweet.
        let webViewController = UIViewController()
        let webView = UIWebView(frame: webViewController.view.bounds)
        webView.loadRequest(NSURLRequest(URL: tweet.permalink))
        webViewController.view = webView
        self.navigationController?.pushViewController(webViewController, animated: true)
    }
    

    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.


        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve the Tweet cell.
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableCellReuseIdentifier, forIndexPath: indexPath) as TWTRTweetTableViewCell



        // Assign the delegate to control events on Tweets.
        cell.tweetView.delegate = self

        // Retrieve the Tweet model from loaded Tweets.
        let tweet = tweets[indexPath.row]

        // Configure the cell with the Tweet.
        cell.configureWithTweet(tweet)

        // Return the Tweet cell.
        return cell
    }

    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {


        let tweet = self.tweets[indexPath.row]
        self.prototypeCell?.configureWithTweet(tweet)
        if let height = self.prototypeCell?.calculatedHeightForWidth(self.view.bounds.width) {
            return height
        } else {
            return self.tableView.estimatedRowHeight
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Animate the logo when the view appears.
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            // Place the frame at the correct origin position.
            self.lView.frame.origin.y = 22
            }, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is translucent.
        self.navigationController?.navigationBar.translucent = true
    }

    func refreshView(){
        self.viewDidLoad()
        self.viewWillAppear(true)
    }







}

