//
//  LoadingView.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/30.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import Foundation
import UIKit

enum LoadingState:Int {
    case loading,success,error,empty
}

public typealias AnimationEndHandler = (Void)->(Void);

public class LoadingView:UIView {
    
    public var loadingColor: UIColor!;
    public var successColor: UIColor!;
    public var errorColor: UIColor!;
    public var emptyColor: UIColor!;
    public var animationEndHandler:AnimationEndHandler?;
    public var lineWith:CGFloat!;
    
    private var state:LoadingState = LoadingState.loading;
    public let defaultFrame = CGRect(origin: CGPointZero, size: CGSize(width:36, height:36));
    private let defaultLineWidth:CGFloat = 2.0;
    private let KName = "animationName";
    private var circleLayer:ArcToCircleLayer!;
    private var radius:CGFloat!;
    
    override init(frame: CGRect) {
        if(frame.size.width == 0 || frame.size.height == 0){
            super.init(frame:defaultFrame);
        }else{
            super.init(frame:frame);
        }
        initValue();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        initValue();
    }
    
    
    public func startLoadingAnimation(){
        reset();
        circleLayer = ArcToCircleLayer();
        circleLayer.contentsScale = UIScreen.mainScreen().scale;
        circleLayer.bounds = defaultFrame;
        circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        self.layer.addSublayer(circleLayer);
        
        circleLayer.progress = 0.9;
        
        let animation:CABasicAnimation = CABasicAnimation();
        animation.keyPath = "progress";
        animation.duration = 1.2;
        animation.fromValue = NSNumber(float: Float(0.0));
        animation.toValue =  NSNumber(float: Float(0.9));
        circleLayer.addAnimation(animation, forKey: nil);
        
        let rotateAnimation:CABasicAnimation = CABasicAnimation();
        rotateAnimation.keyPath = "transform.rotation.z";
        rotateAnimation.removedOnCompletion = false;
        rotateAnimation.duration = 0.8;
        rotateAnimation.repeatCount = Float.infinity;
        rotateAnimation.fillMode = kCAFillModeForwards;
        rotateAnimation.fromValue = NSNumber(float: Float(2*M_PI));
        rotateAnimation.toValue = NSNumber(float: 0.0);
        circleLayer.addAnimation(rotateAnimation,forKey:nil);
    }
    
    public func toSuccessState(){
        state = LoadingState.success;
        self.fillArcToCircle();
    }
    
    public func toErrorState(){
        state = LoadingState.error;
        self.fillArcToCircle();
    }
    
    public func toEmptyState(){
        state = LoadingState.empty;
        self.fillArcToCircle();
    }
    
    //MARK: Animation delegate
    override public func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let name = String(anim.valueForKey(KName)!);
        if "fillArcToCircle" == name {
            circleLayer.removeAllAnimations();
            switch state {
            case LoadingState.success:
                playSuccessAnimation();
            case LoadingState.error:
                playErrorAnimation();
            case LoadingState.empty:
                playEmptyAnimation();
            default: break
            }
        }
        
        if "ErrorAniamtionTop" == name {
            playErrorAniamtionBottom();
            return;
        }
        
        if "ErrorAniamtionBottom" == name {
            playShakeLayerAinmation();
            return;
        }
        
        if "SuccessAnimation" == name || "ShakeLayerAinmation" == name || "EmptyAnimation" == name {
            if animationEndHandler != nil {
                animationEndHandler!();
            }
        }
    }

    //MARK: ---------------------- private func
    private func initValue(){
        lineWith = defaultLineWidth;
        radius = CGRectGetMaxX(self.bounds)/2-lineWith/2
        loadingColor = UIColor.blackColor();
        successColor = UIColor.greenColor();
        errorColor = UIColor.redColor();
        emptyColor = UIColor.darkGrayColor();
    }
    
    private func fillArcToCircle(){
        circleLayer.progress = 1.0;
        let animation = CABasicAnimation();
        animation.keyPath = "progress";
        animation.duration = 0.3;
        animation.fromValue = NSNumber(float:0.9);
        animation.toValue = NSNumber(float:1.0);
        animation.delegate = self;
        animation.setValue("fillArcToCircle", forKey: KName);
        circleLayer.addAnimation(animation, forKey: nil);
    }
    
    private func playEmptyAnimation(){
        circleLayer.color = self.emptyColor;
        let horizontalLineLayer = CAShapeLayer()
        self.layer.addSublayer(horizontalLineLayer)
        horizontalLineLayer.frame = self.bounds;
        
        let path = UIBezierPath();
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds)-radius/2, CGRectGetMidY(self.bounds)));
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds)+radius/2,CGRectGetMidY(self.bounds)));
        horizontalLineLayer.path = path.CGPath;
        horizontalLineLayer.lineWidth = lineWith;
        horizontalLineLayer.strokeColor = self.emptyColor.CGColor;
        horizontalLineLayer.fillColor = nil;
        horizontalLineLayer.strokeStart = 0;
        horizontalLineLayer.strokeEnd = 1;
        
        // animation
        let startAnimation = CABasicAnimation();
        startAnimation.keyPath = "strokeStart";
        startAnimation.fromValue = 0.5;
        startAnimation.toValue = 0.0;
        
        let endAnimation = CABasicAnimation();
        endAnimation.keyPath = "strokeEnd";
        endAnimation.fromValue = 0.5;
        endAnimation.toValue = 1.0;
        
        let animationGroup = CAAnimationGroup();
        animationGroup.animations = [startAnimation, endAnimation];
        animationGroup.duration = 0.3;
        animationGroup.delegate = self;
        animationGroup.setValue("EmptyAnimation", forKey: KName)
        horizontalLineLayer.addAnimation(animationGroup, forKey: nil)
    }
    
    private func playSuccessAnimation(){
        circleLayer.color = self.successColor;
        let checkLayer = CAShapeLayer();
        checkLayer.frame = self.bounds;
        self.layer.addSublayer(checkLayer);
        
        let path = UIBezierPath();
        let centerPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        var firstPoint = centerPoint;
        firstPoint.x -= radius/1.7;
        path.moveToPoint(firstPoint)
        var secondPoint = centerPoint;
        secondPoint.x -= radius/8;
        secondPoint.y += radius/2;
        path.addLineToPoint(secondPoint);
        var thirdPoint = centerPoint;
        thirdPoint.x += radius/2;
        thirdPoint.y -= radius/2;
        path.addLineToPoint(thirdPoint);
        
        checkLayer.path = path.CGPath;
        checkLayer.lineWidth = lineWith;
        checkLayer.strokeColor = self.successColor.CGColor;
        checkLayer.fillColor = nil;
        checkLayer.strokeEnd = 1.0;
        
        let animation = CABasicAnimation();
        animation.keyPath = "strokeEnd"
        animation.duration = 0.4;
        animation.fromValue = 0.0;
        animation.toValue = 1.0;
        animation.delegate = self;
        animation.setValue("SuccessAnimation", forKey: KName);
        checkLayer.addAnimation(animation, forKey: nil);
    }
    
    private func playErrorAnimation(){
        circleLayer.color = self.errorColor;
        playErrorAniamtionTop();
    }
    
    private func playErrorAniamtionTop(){
        let errorTopLayer = CAShapeLayer();
        errorTopLayer.frame = self.bounds;
        errorTopLayer.lineWidth = lineWith;
        errorTopLayer.strokeColor = self.errorColor.CGColor;
        errorTopLayer.fillColor = nil;
        self.layer.addSublayer(errorTopLayer);
        
        let path = UIBezierPath();
        let originY = CGRectGetMidY(self.bounds)-radius/4*3;
        let destY = CGRectGetMidY(self.bounds) + radius/4;
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY));
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY));
        errorTopLayer.path = path.CGPath;

        errorTopLayer.strokeStart = 0.0;
        errorTopLayer.strokeEnd = 1.0;

        let animation = CABasicAnimation();
        animation.keyPath = "strokeEnd";
        animation.fromValue = NSNumber(float:0.0);
        animation.toValue = NSNumber(float:1.0);
        animation.delegate = self;
        animation.duration = 0.4;
        animation.setValue("ErrorAniamtionTop", forKey: KName);
        errorTopLayer.addAnimation(animation, forKey: nil);
    }
    
    private func playErrorAniamtionBottom(){
        let errorBottomLayer = CAShapeLayer();
        errorBottomLayer.frame = self.bounds;
        errorBottomLayer.lineWidth = lineWith;
        errorBottomLayer.strokeColor = self.errorColor.CGColor;
        errorBottomLayer.fillColor = nil;
        self.layer.addSublayer(errorBottomLayer);
        
        let path = UIBezierPath();
        let originY = CGRectGetMidY(self.bounds) + radius/4*3;
        let destY = originY - radius/2;
        path.moveToPoint(CGPointMake(CGRectGetMidX(self.bounds), destY));
        path.addLineToPoint(CGPointMake(CGRectGetMidX(self.bounds), originY));
        errorBottomLayer.path = path.CGPath;
    
        errorBottomLayer.strokeStart = 0.5;
        errorBottomLayer.strokeEnd = 1.0;
        
        let animation = CABasicAnimation();
        animation.keyPath = "strokeEnd";
        animation.fromValue = NSNumber(float:0.5);
        animation.toValue = NSNumber(float:1.0);
        animation.delegate = self;
        animation.duration = 0.25;

        animation.setValue("ErrorAniamtionBottom", forKey: KName);
        errorBottomLayer.addAnimation(animation, forKey: nil);
    }
    
    private func playShakeLayerAinmation(){
        let animation = CABasicAnimation();
        animation.keyPath = "transform.rotation.z";
        animation.fromValue = -M_PI/12;
        animation.toValue = M_PI/12;
        animation.duration = 0.1;
        animation.beginTime = CACurrentMediaTime()+0.2;
        animation.autoreverses = true;
        animation.repeatCount = 4;
        animation.delegate = self;
        animation.setValue("ShakeLayerAinmation", forKey: KName);
        self.layer.addAnimation(animation, forKey: nil);
    }
    
    
    private func reset(){
        self.layer.removeAllAnimations();
        if self.layer.sublayers != nil {
            for layer in self.layer.sublayers! {
                layer.removeFromSuperlayer();
            }
        }
    }

}