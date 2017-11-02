//
//  URLitems.swift
//  diveMap
//
//  Created by Trym Lintzen on 02-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation

class DetailDiveSite {
    
    var url: String
    var description : String = ""
    var country: String = ""
    var diveHazards: String = ""
    
    init(url: String) {
        self.url = url
    }
}
