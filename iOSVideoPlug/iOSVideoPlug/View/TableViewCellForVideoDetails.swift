//
//  TableViewCellForVideoDetails.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 02/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit
import AlamofireImage

class TableViewCellForVideoDetails: UITableViewCell {
    
    @IBOutlet weak var imgViewForVideo : UIImageView!
    @IBOutlet weak var lblForVideoTitle : UILabel!
    @IBOutlet weak var lblForVideoSize : UILabel!
    @IBOutlet weak var lblForVideoProgress : UILabel!
    @IBOutlet weak var btnForVideoProgress : UIDownloadProgressButton!
    

    /// Used configure cell
    ///
    /// - Parameter videoModel: videoModel 
    func configure(videoModel : VideoDetails){
        self.lblForVideoTitle.text = videoModel.strVideoName
        self.lblForVideoSize.text = "\(((videoModel.size / (1024 * 1024)) >= 1 ? "\(Float(videoModel.size / (1024 * 1024))) MB" : "\(Float(videoModel.size / (1024))) KB"))"
        
        if videoModel.isDownloading{
            self.lblForVideoProgress.isHidden = false
            self.lblForVideoProgress.text = "\(videoModel.progressPercentage)%"
        }else{
            self.lblForVideoProgress.isHidden = true
        }
        
        if videoModel.isDownloaded{
            self.btnForVideoProgress.isHidden = true
        }else{
            self.btnForVideoProgress.isHidden = false
        }
        
        if videoModel.strThubnailUrl.count == 0{
            return
        }
     //   guard let imageUrl = URL(string: videoModel.strThubnailUrl) else{return}
  
        //print(imageUrl)
//        self.imgViewForVideo.af_setImage(withURL:imageUrl,placeholderImage:Image(named: "Ic_UploadVideo"))
       
     //.combineWith(image: UIImage(named: "play")!)
    }
}
