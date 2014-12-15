//
//  BeaconConstants.swift
//  settee
//
//  Created by Gareth Jones  on 12/14/14.
//  Copyright (c) 2014 Twitter. All rights reserved.
//

import Foundation
import CoreLocation

func getRegion() -> CLBeaconRegion {
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"), identifier: "couch")
    return region
}
