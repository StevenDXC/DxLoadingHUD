//
//  Window.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/29.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import Foundation
import UIKit

typealias BgViewTapedHandler = (Void) -> Void;

class Window:UIWindow{
    
    internal let frameView: BlurFrameView
    
    internal init(frameView:BlurFrameView = BlurFrameView()) {
        self.frameView = frameView
        super.init(frame: UIApplication.sharedApplication().delegate!.window!!.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        frameView = BlurFrameView()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        rootViewController = WindowRootViewController()
        windowLevel = UIWindowLevelNormal + 500.0
        backgroundColor = UIColor.clearColor()
    
        addSubview(backgroundView)
        addSubview(frameView)
    }
    
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        frameView.center = center
        backgroundView.frame = bounds
    }
    
    internal func showFrameView() {
        layer.removeAllAnimations()
        makeKeyAndVisible()
        frameView.center = center
        frameView.alpha = 1.0
        hidden = false
    }
    
    private var willHide = false
    
    internal func hideFrameView(animated anim: Bool, completion: ((Bool) -> Void)? = nil) {
        let finalize: (finished: Bool) -> (Void) = { finished in
            if finished {
                self.hidden = true
                self.resignKeyWindow()
            }
            
            self.willHide = false
            completion?(finished)
        }
        
        if hidden {
            return
        }
        
        willHide = true
        
        if anim {
            UIView.animateWithDuration(0.4, animations: {
                self.frameView.alpha = 0.0
                self.hideBackground(animated: false)
                }, completion: finalize)
        } else {
            self.frameView.alpha = 0.0
            finalize(finished: true)
        }
    }
    
    private let backgroundView:UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white:0.0, alpha:0.25)
        view.alpha = 0.0
        return view
    }()
    
    internal func showBackground(animated anim: Bool) {
        if anim {
            UIView.animateWithDuration(0.175) {
                self.backgroundView.alpha = 1.0
            }
        } else {
            backgroundView.alpha = 1.0
        }
    }
    
    internal func hideBackground(animated anim: Bool) {
        if anim {
            UIView.animateWithDuration(0.4) {
                self.backgroundView.alpha = 0.0
            }
        } else {
            backgroundView.alpha = 0.0
        }
    }
}