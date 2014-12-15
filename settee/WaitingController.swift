//
//  WaitingController.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import UIKit
import CoreLocation

class WaitingController: UIViewController, CLLocationManagerDelegate {


    let locationManager = CLLocationManager()
    let region = getRegion()
    var lView: UIImageView!
    var prev: Int?

    @IBOutlet var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup the navigation bar
        setupNavBar()

        // start the spinner
        self.spinner.startAnimating()

        // trackBeacons to see if near beacon
        trackBeacons()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Animate the logo when the view appears.
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 1.5, options: .CurveEaseInOut, animations: { () -> Void in
            // Place the frame at the correct origin position.
            self.lView.frame.origin.y = 22
            }, completion: nil)
    }

    //
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        if (knownBeacons.count > 0) {
            let closestBeacon = knownBeacons[0] as CLBeacon

            let proximity = closestBeacon.proximity.rawValue

            if prev != proximity {

                // set this as the previous value
                prev = proximity

                // Print the proximity 1 is close / 3 is away
                if (proximity == 1){
                    self.performSegueWithIdentifier("ViewController", sender: self)
                }
                
                println(String(proximity))
            }
            
        }
        
    }

    func trackBeacons(){
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.Authorized) {
            locationManager.requestAlwaysAuthorization()
        }

        locationManager.startRangingBeaconsInRegion(region)

    }

    func setupNavBar(){
        // Append Image to NavigationBar
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
    }


    
    

}