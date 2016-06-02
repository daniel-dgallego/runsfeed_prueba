//
//  imageExtension.swift
//  ManejoParse
//
//  Created by dgallego on 28/12/15.
//  Copyright © 2015 webseoglobal. All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    
    func fixOrientation()->UIImage{
     
        
        if self.imageOrientation == UIImageOrientation.Up{
            print("orientacion correcto")
            return self
        }
        else{
            print("incorrecto")
            
            var transform = CGAffineTransformIdentity
            
            switch (self.imageOrientation) {
            case UIImageOrientation.Down:
                transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
            case UIImageOrientation.DownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI));
                
                
            case UIImageOrientation.Left:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
            case UIImageOrientation.LeftMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
                
                
            case UIImageOrientation.Right:
                transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
            case UIImageOrientation.RightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, self.size.height);
                transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
                
            case UIImageOrientation.Up: break
            case UIImageOrientation.UpMirrored: break
                
            }
            
            
            switch (self.imageOrientation) {
            case UIImageOrientation.UpMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                
            case UIImageOrientation.DownMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientation.LeftMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
            case UIImageOrientation.RightMirrored:
                transform = CGAffineTransformTranslate(transform, self.size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            case UIImageOrientation.Up: break
            case UIImageOrientation.Down: break
            case UIImageOrientation.Left: break
            case UIImageOrientation.Right:
                break;
            }
            
            
            
            let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height), CGImageGetBitsPerComponent(self.CGImage), 0, CGImageGetColorSpace(self.CGImage), CGImageGetBitmapInfo(self.CGImage).rawValue)
            
            CGContextConcatCTM(ctx, transform)
            
            switch (self.imageOrientation) {
            case UIImageOrientation.Left:
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            case UIImageOrientation.LeftMirrored:
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            case UIImageOrientation.Right:
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            case UIImageOrientation.RightMirrored:
                // Grr...
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
                break;
                
            default:
                CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
                break;
            }
            
            
            let cgimg = CGBitmapContextCreateImage(ctx)
            let im = UIImage(CGImage: cgimg!)
            return im
            
        }
    }
    
    
    
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            
            let context = UIGraphicsGetCurrentContext()! as CGContextRef
            CGContextTranslateCTM(context, 0, self.size.height)
            CGContextScaleCTM(context, 1.0, -1.0);
            CGContextSetBlendMode(context, .Normal)
        
            let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
            CGContextClipToMask(context, rect, self.CGImage)
            tintColor.setFill()
            CGContextFillRect(context, rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
            UIGraphicsEndImageContext()
            
            return newImage
    }
    
    
    func imageByApplyingAlpha(alpha : CGFloat)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        
        CGContextScaleCTM(ctx, 1, -1)
        CGContextTranslateCTM(ctx, 0, -area.size.height)
        
        CGContextSetBlendMode(ctx, .Multiply)
        CGContextSetAlpha(ctx, alpha)
        CGContextDrawImage(ctx, area, self.CGImage)
        
        let new = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return new
    }
    
    
    func imageResize(tam: CGSize)->UIImage{
        
        UIGraphicsBeginImageContextWithOptions(tam, false, 0.0)
        self.drawInRect(CGRect(x: 0, y: 0, width: tam.width, height: tam.height))
        let nueva = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return nueva
    }
    
    
    
    func imageOnlyWithColor(col: UIColor)->UIImage{
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0);
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        
        CGContextClipToMask(context, rect, self.CGImage)
        col.setFill()
        
        CGContextFillRect(context, rect)
        let nueva = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return nueva
    }
    
    
    
    
   
    
}