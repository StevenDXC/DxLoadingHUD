//
//  BlurFrameView.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/29.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import UIKit

class BlurFrameView: UIVisualEffectView {
    
    private var _content = UIView();
    
    internal init() {
        super.init(effect: UIBlurEffect(style:.Light))
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = UIColor(white: 0.8, alpha: 0.36)
        layer.cornerRadius = 9.0
        layer.masksToBounds = true

        contentView.addSubview(self.content)
        
        let offset = 20.0
        
        let motionEffectsX = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        motionEffectsX.maximumRelativeValue = offset
        motionEffectsX.minimumRelativeValue = -offset
        
        let motionEffectsY = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        motionEffectsY.maximumRelativeValue = offset
        motionEffectsY.minimumRelativeValue = -offset
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [motionEffectsX, motionEffectsY]
        
        self.addMotionEffect(group)    
    }
    
    internal var content: UIView {
        get {
            return _content
        }
        set {
            _content.removeFromSuperview()
            _content = newValue
            _content.alpha = 0.85
            _content.clipsToBounds = true
            _content.contentMode = .Center
            frame.size = _content.bounds.size
            addSubview(_content)
        }
    }
}