//
//  ViewController.swift
//  DxLoadingHUD
//
//  Created by Miutrip on 16/8/1.
//  Copyright © 2016年 dxc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor();
        
        let startBtn = UIButton(type:.System);
        startBtn.frame = CGRectMake(0, 60, CGRectGetMaxX(self.view.bounds)/4, 40);
        startBtn.setTitleColor(UIColor.blueColor(), forState: .Normal);
        startBtn.setTitle("show", forState: .Normal);
        startBtn.addTarget(self, action: #selector(ViewController.show), forControlEvents: .TouchUpInside);
        self.view.addSubview(startBtn)
        
        let successBtn = UIButton(type:.System);
        successBtn.frame = CGRectMake(CGRectGetMaxX(startBtn.frame), 60, CGRectGetMaxX(self.view.bounds)/4, 40);
        successBtn.setTitleColor(UIColor.blueColor(), forState: .Normal);
        successBtn.setTitle("success", forState: .Normal);
        successBtn.addTarget(self, action: #selector(ViewController.showSuccess), forControlEvents: .TouchUpInside);
        self.view.addSubview(successBtn)
        
        let errorBtn = UIButton(type:.System);
        errorBtn.frame = CGRectMake(CGRectGetMaxX(successBtn.frame), 60, CGRectGetMaxX(self.view.bounds)/4, 40);
        errorBtn.setTitleColor(UIColor.blueColor(), forState: .Normal);
        errorBtn.setTitle("error", forState: .Normal);
        errorBtn.addTarget(self, action: #selector(ViewController.showError), forControlEvents: .TouchUpInside);
        self.view.addSubview(errorBtn)
        
        let emptyBtn = UIButton(type:.System);
        emptyBtn.frame = CGRectMake(CGRectGetMaxX(errorBtn.frame), 60, CGRectGetMaxX(self.view.bounds)/4, 40);
        emptyBtn.setTitleColor(UIColor.blueColor(), forState: .Normal);
        emptyBtn.setTitle("empty", forState: .Normal);
        emptyBtn.addTarget(self, action: #selector(ViewController.showEmpty), forControlEvents: .TouchUpInside);
        self.view.addSubview(emptyBtn)
    }
    
    internal func show(){
        DxLoadingHUD.sharedInstance.show();
        toState(LoadingState.loading);
    }
    
    internal func showSuccess(){
        DxLoadingHUD.sharedInstance.show();
        toState(LoadingState.success);
    }
    
    internal func showError(){
        DxLoadingHUD.sharedInstance.show();
        toState(LoadingState.error);
    }
    
    internal func showEmpty(){
        DxLoadingHUD.sharedInstance.show();
        toState(LoadingState.empty);
    }
    
    
    private func toState(state:LoadingState){
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2*NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(),{
            switch(state){
            case LoadingState.loading:
                DxLoadingHUD.sharedInstance.hide(true);
            case LoadingState.success:
                DxLoadingHUD.sharedInstance.showSuccessAnimation();
            case LoadingState.error:
                DxLoadingHUD.sharedInstance.showErrorAnimation();
            case LoadingState.empty:
                DxLoadingHUD.sharedInstance.showEmptyAnimation();
            }
            
        });
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

