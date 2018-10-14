//
//  Place.swift
//  LocationService
//
//  Created by Bethany Huang on 10/6/18.
//  Copyright © 2018 Liuxuan Huang. All rights reserved.
//

import UIKit
import MapKit

class Place: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
