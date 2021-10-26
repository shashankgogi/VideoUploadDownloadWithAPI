//
//  Extensions.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 03/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit
import AVKit
import MobileCoreServices

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        self.navigationController?.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
        if let navController = self.navigationController {
            navController.view.endEditing(true)
        }
    }
}


extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}

// MARK: - Used to set two image on single imageview
extension UIImage {
    func combineWith(image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        self.draw(in: CGRect(x:0 , y: 0, width: self.size.width, height: self.size.height))
        image.draw(in: CGRect(x: self.size.width / 2 - 50, y: self.size.height / 2 - 50, width: 100,  height: 100))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage(named: "loading")!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
