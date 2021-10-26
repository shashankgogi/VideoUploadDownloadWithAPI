//
//  CircularProgressView.swift
//  iOSVideoPlug
//
//  Created by Rahul Panzade on 05/04/19.
//  Copyright © 2019 Omni-Bridge. All rights reserved.
//

import UIKit


/// enum constant for Downloading Status

enum ViewProgressStatus {
    case start
    case stop
    case completed
}

class CircularProgressView: UIView {
    // Variables
    var progress: Float = 0 {
        didSet {
            circleShape.strokeEnd = CGFloat(self.progress)
            lblForProgressPercentage.text = "\(String(format: "%.1f", Float(self.progress) * 100)) %"
            self.addAnimation()
        }
    }
    
    var circleShape = CAShapeLayer()
    var innerCircleShape = CAShapeLayer()
    var lblForProgressPercentage = UILabel()
    
    /// used to set default property to UIDownloadProgressButton
    public func drawCircle() {
        let x: CGFloat = 0.0
        let y: CGFloat = 0.0
        let circlePath = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: self.frame.height, height: self.frame.height), cornerRadius: self.frame.height / 2).cgPath
        innerCircleShape.path = circlePath
        innerCircleShape.lineCap = CAShapeLayerLineCap.round
        innerCircleShape.lineWidth = 1
        innerCircleShape.strokeColor = UIColor.clear.cgColor
        innerCircleShape.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(innerCircleShape)
        
        circleShape.path = circlePath
        circleShape.lineCap = CAShapeLayerLineCap.round
        circleShape.lineWidth = 10
        circleShape.strokeColor = UIColor.purple.cgColor
        circleShape.strokeStart = 0
        circleShape.strokeEnd = 0
        circleShape.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(circleShape)
        addPercentageLabel()
    }
    
    /// Adding percentage lable
    func addPercentageLabel(){
        lblForProgressPercentage.frame = self.bounds
        lblForProgressPercentage.textAlignment = .center
        lblForProgressPercentage.text = "0.0 %"
        lblForProgressPercentage.textColor = UIColor.green
        self.addSubview(lblForProgressPercentage)
    }
    
    /// Used to animate the progress of UIDownloadProgressButton
    func addAnimation(){
        DispatchQueue.main.async {
            let animation = CABasicAnimation(keyPath: "StrokeEnd")
            animation.toValue = 1
            animation.duration = 0.1
            animation.fillMode = CAMediaTimingFillMode.forwards
            animation.isRemovedOnCompletion = false
            self.circleShape.add(animation, forKey: "urSoBasic")
        }
    }
    
    // MARK: - Update the download status of UIDownloadProgressButton
    var status: ViewProgressStatus = .start {
        didSet{
            switch self.status {
            case .start:
                self.innerCircleShape.strokeColor = UIColor.gray.cgColor
            case .completed:
                self.progress = 0
                self.innerCircleShape.strokeColor = UIColor.clear.cgColor
            case .stop:
                self.innerCircleShape.strokeColor = UIColor.gray.cgColor
                
            }
        }
    }
}



