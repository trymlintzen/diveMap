//
//  URLMapService.swift
//  diveMap
//
//  Created by Trym Lintzen on 02-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

class DetailDiveSiteMapService {
    public static let sharedInstance = DetailDiveSiteMapService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    
    func diveSearchDetail(id: String)  {
        
        do {
            let urlString =  "\(urls.baseURL)?mode=detail&siteid=\(id)"
            Alamofire.request( urlString ,
                               method: .get,
                               parameters: nil,
                               encoding: JSONEncoding.default).responseJSON { (jsonData) in
                                print(jsonData)
                                if let result = jsonData.result.value as? NSDictionary {
                                    self.getDetailData(result: result)
                                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getDetailData (result: NSDictionary) {
        var urlObject = ""
        if let url = result["urls"] as? NSArray {
                if let dict = url[0] as? NSDictionary,
                    let url = dict["url"] as? String {
                    //                if let urlNSURL = NSURL(url) {
                    urlObject = url
            }
            let detailDiveSite = DetailDiveSite.init(url: urlObject)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationIDs.urlItemID),
                                            object: self,
                                            userInfo: [dictKey.diveURLKey : detailDiveSite])
        }
        
        

        
    }
    
}
