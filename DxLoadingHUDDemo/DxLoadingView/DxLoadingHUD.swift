//
//  RxHUD.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/29.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import Foundation
import UIKit

public class DxLoadingHUD:NSObject{
    
    static let sharedInstance = DxLoadingHUD();
    
    public var dimsBackground = true; //whether dimness background,
    private var window:Window!;
    private var _hiddenOnAnimationCompletion = true;

    var hiddenOnAnimationCompletion : Bool {
        get { return _hiddenOnAnimationCompletion  }
        set {
            if(_hiddenOnAnimationCompletion){
                getContentView().getLoadingView().animationEndHandler = {
                    self.delayHidden();
                };
            }else{
                getContentView().getLoadingView().animationEndHandler = nil;
            }
        }
    }
    
    private override init() {
        super.init()
        window = Window();
        window.frameView.autoresizingMask = [ .FlexibleLeftMargin,.FlexibleTopMargin,.FlexibleTopMargin,.FlexibleBottomMargin];
        let contentView = HUDContentView();
        window.frameView.content = contentView;
        hiddenOnAnimationCompletion = true;
    }
    
    func getContentView() -> HUDContentView {
        return window.frameView.content as! HUDContentView;
    }
    
    
    public func show() {
        window.showFrameView();
        if dimsBackground {
            window.showBackground(animated: true)
        }
        getContentView().startLaodingAnimation();
    }
    
    public func showSuccessAnimation(){
        getContentView().showSuccessAnimation();
        
    }
    
    public func showErrorAnimation(){
        getContentView().showErrorAnimation();
        if(hiddenOnAnimationCompletion){
            getContentView().getLoadingView().animationEndHandler = {
                self.delayHidden();
            };
        }
    }
    
    public func showEmptyAnimation(){
        getContentView().showEmptyAnimation();
        if(hiddenOnAnimationCompletion){
            getContentView().getLoadingView().animationEndHandler = {
                self.delayHidden();
            };
        }
    }
    
    public func hide(animated:Bool){
        window.hideFrameView(animated: animated)
    }
    
    public var isVisible: Bool {
        return !window.hidden
    }

    private func delayHidden(){
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1*NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(),{
            self.hide(true);
        })
    }

    
}