//
//  ProgressHUD.swift
//  surfers
//
//  Created by United It Services on 18/08/23.
//

import Foundation
import UIKit
class ProgressHUD: UIVisualEffectView {
    
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init() {
        activityIndictor.color = .black
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            superview.isUserInteractionEnabled = false
            
            let width : CGFloat = 50.0
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
           
        }
    }
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.superview?.isUserInteractionEnabled = true
        self.isHidden = true
    }
}
    

