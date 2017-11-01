//
//  DiveMapAnnotation.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation
import MapKit

class DiveMapAnnotation: NSObject, MKAnnotation {
    var diveSite: DiveMapItems
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(diveSite: DiveMapItems, coordinate: CLLocationCoordinate2D, title: String ) {
        self.coordinate = coordinate
        self.diveSite = diveSite
        self.title = title
    }
    
}

