//
//  VideoDetails.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 02/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit

struct VideoDetails {
    let id : Int
    let strVideoName : String
    let size : Int
    let strThubnailUrl : String
    let progressPercentage : Float
    var isDownloading: Bool
    var isDownloaded: Bool
    let strVideoUrl : String
    let timestamp : Int
    
    init(_ dictionary : [String : Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.strVideoName = dictionary["videoTitle"] as? String  ?? ""
        self.strVideoUrl = dictionary["videoURL"] as? String  ?? ""
        self.size = Int(((dictionary["sizeInBytes"] as? String ?? "0") as NSString).intValue)
        self.strThubnailUrl = dictionary["thumbnailUrl"] as? String ?? ""
        self.progressPercentage = 0
        self.isDownloading = false
        self.isDownloaded = true
        self.timestamp = dictionary["timestamp"] as? Int ?? 0
    }
    
}
