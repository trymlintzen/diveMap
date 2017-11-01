//
//  DiveMapService.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation
import Alamofire

class DiveMapService {
    public static let sharedInstance = DiveMapService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    
    
    func getDiveMapInfo(lat: Double, lng: Double, dist: Double)  {
        
        do {
            let urlString =  "\(urls.baseURL)?mode=sites&lat=\(lat))&lng=\(lng)&dist=\(dist)"
            Alamofire.request( urlString ,
                               method: .get,
                               parameters: nil,
                               encoding: JSONEncoding.default).responseJSON { (jsonData) in
                                print(jsonData)
                                if let result = jsonData.result.value as? NSDictionary {
                                    self.parseData(result: result)
                                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parseData (result: NSDictionary) {
        var diveItems: [DiveMapItems] = []
        
        if let sites = result["sites"] as? NSArray {
            for currentHit in sites {
                if let dict = currentHit as? NSDictionary,
                    let lat = dict["lat"] as? String,
                    let lng = dict["lng"] as? String,
                    let id = dict["id"] as? String,
                    let name = dict["name"] as? String {
                    if let latDouble = Double(lat),
                        let lngDouble = Double(lng) {
                        let diveMapObject = DiveMapItems.init(lat: latDouble, lng: lngDouble, id: id, name: name)
                        diveItems.append(diveMapObject)
                    }
                }
            }
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.diveItemID),
                                        object: self,
                                        userInfo: [dictKey.diveItemKey : diveItems])
    }
    
}
