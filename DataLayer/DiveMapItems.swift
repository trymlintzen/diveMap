//
//  DiveMapItems.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation

class DiveMapItems {
    
    var lat: Double
    var lng: Double
    var id : String
    var name: String
  
    init(lat: Double, lng: Double, id: String, name: String) {
        self.lat = lat
        self.lng = lng
        self.id = id
        self.name = name
    }
    

}
