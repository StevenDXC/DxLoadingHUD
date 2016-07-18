//
//  ContentView.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/30.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import Foundation
import UIKit

public class HUDContentView:UIView{
        
    private let defaultFrame = CGRect(origin: CGPointZero, size: CGSize(width:88, height:88));
    private let loadingView:LoadingView = LoadingView();
    
    public override init(frame: CGRect) {
        if(frame.size.width == 0 || frame.size.height == 0){
            super.init(frame:defaultFrame);
        }else{
            super.init(frame:frame);
        }
        let x = (CGRectGetMaxX(self.bounds)-CGRectGetMaxX(loadingView.frame))/2;
        let y = (CGRectGetMaxY(self.bounds)-CGRectGetMaxY(loadingView.frame))/2
        loadingView.frame = CGRect(origin:CGPointMake(x, y),size:loadingView.frame.size);
        self.addSubview(loadingView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func getLoadingView()->LoadingView{
        return loadingView;
    }
    
    public func startLaodingAnimation(){
        loadingView.startLoadingAnimation();
    }
    
    public func showSuccessAnimation(){
        loadingView.toSuccessState();
    }
    
    public func showErrorAnimation(){
        loadingView.toErrorState();
    }
    
    public func showEmptyAnimation(){
        loadingView.toEmptyState();
    }
    
}