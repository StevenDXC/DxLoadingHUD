//
//  ArcToCircleLayer.swift
//  SwiftDemo
//
//  Created by Miutrip on 16/5/30.
//  Copyright © 2016年 Miutrip. All rights reserved.
//

import Foundation
import UIKit

class ArcToCircleLayer: CALayer {
    
    var progress:Float = 0.0;
    var lineWidth:CGFloat = 2.0;
    var color:UIColor = UIColor.blackColor();
   
    override static func needsDisplayForKey(key:String) -> Bool {
        if ("progress" == key) {
            return true;
        }
        
        if ("color" == key) {
            return true;
        }
        
        if ("lineWidth" == key) {
            return true;
        }
        return super.needsDisplayForKey(key);
    }
    
    override func drawInContext(ctx: CGContext) {
        let path:UIBezierPath = UIBezierPath();
        let radius:CGFloat = CGFloat(min(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)))/2 - self.lineWidth/2;
        let center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        //start angle
        let originStart:Float = Float(M_PI * 7 / 2);
        let originEnd:Float = Float(M_PI * 2);
        let currentOrigin:CGFloat = CGFloat(originStart - (originStart-originEnd) * progress);
        
        //end angle
        let destStart:Float = Float(M_PI * 3);
        let destEnd:Float = 0;
        let currentDest:CGFloat = CGFloat(destStart - (destStart-destEnd) * self.progress);
        
        path.addArcWithCenter(center, radius: radius, startAngle: currentOrigin, endAngle: currentDest, clockwise: false);
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetLineWidth(ctx, self.lineWidth);
        CGContextSetStrokeColorWithColor(ctx, self.color.CGColor);
        CGContextStrokePath(ctx);
    }
    
}