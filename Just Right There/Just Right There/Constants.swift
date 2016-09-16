//
//  Constants.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 12/30/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import Foundation

extension UIColor {
    class func primaryDarkBlue() -> UIColor {
        return UIColor(red: 33.0/255.0, green: 36.0/255.0, blue: 44.0/255.0, alpha: 1.0)
    }
    
    class func navyColor() -> UIColor {
        return UIColor(red: 31.0/255.0, green: 42.0/255.0, blue: 69.0/255.0, alpha: 1.0)
    }
    
    class func mediumBlue() -> UIColor {
        return UIColor(red: 54.0/255.0, green: 72.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    }
    
    class func greyBlue() -> UIColor {
        return UIColor(red: 90.0/255.0, green: 99.0/255.0, blue: 120.0/255.0, alpha: 1.0)
    }
    
    class func lightGreyBlue() -> UIColor {
        return UIColor(red: 148.0/255.0, green: 161.0/255.0, blue: 197.0/255.0, alpha: 1.0)
    }
    
    class func flatRed() -> UIColor {
        return UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    }
    
    class func flatGold() -> UIColor {
        return UIColor(red: 241.0/255.0, green: 196.0/255.0, blue: 15.0/255.0, alpha: 1.0)
    }
    
    class func flatGrey() -> UIColor {
        return UIColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    }
}

extension UIImage {
    public class func imageOfBackarrow(frame frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 0.5, selected: Bool = false, rotate: CGFloat = -90) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawBackarrow(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), color: color, scale: scale, selected: selected, rotate: rotate)
        
        let imageOfBackarrow = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageOfBackarrow!
    }
    
    public class func drawBackarrow(frame frame: CGRect = CGRect(x: 0, y: 0, width: 50, height: 50), color: UIColor = UIColor(red: 0.095, green: 0.095, blue: 0.095, alpha: 1.000), scale: CGFloat = 0.5, selected: Bool = false, rotate: CGFloat = -90) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        var colorHueComponent: CGFloat = 1,
        colorSaturationComponent: CGFloat = 1,
        colorBrightnessComponent: CGFloat = 1
        color.getHue(&colorHueComponent, saturation: &colorSaturationComponent, brightness: &colorBrightnessComponent, alpha: nil)
        
        let highlightedColor = UIColor(hue: 0.449, saturation: colorSaturationComponent, brightness: colorBrightnessComponent, alpha: CGColorGetAlpha(color.CGColor))
        
        //// Variable Declarations
        let strokeColor = selected ? highlightedColor : color
        
        //// arrow Drawing
        CGContextSaveGState(context!)
        CGContextTranslateCTM(context!, frame.minX + 0.50500 * frame.width, frame.minY + 0.49700 * frame.height)
        CGContextRotateCTM(context!, -rotate * CGFloat(M_PI) / 180)
        CGContextScaleCTM(context!, scale, scale)
        
        let arrowPath = UIBezierPath()
        arrowPath.moveToPoint(CGPoint(x: 6.5, y: 11.7))
        arrowPath.addLineToPoint(CGPoint(x: -6.5, y: 0))
        arrowPath.addLineToPoint(CGPoint(x: 6.5, y: -11.7))
        arrowPath.miterLimit = 4;
        
        arrowPath.lineCapStyle = .Round;
        
        arrowPath.lineJoinStyle = .Round;
        
        arrowPath.usesEvenOddFillRule = true;
        
        strokeColor.setStroke()
        arrowPath.lineWidth = 5
        arrowPath.stroke()
        
        CGContextRestoreGState(context!)
    }
}

// Monochromatic Icon Colors
let NavyColor = UIColor(red: 31.0/255.0, green: 42.0/255.0, blue: 69.0/255.0, alpha: 1.0) // #1F2A45
let DarkGrey = UIColor(red: 71.0/255.0, green: 78.0/255.0, blue: 94.0/255.0, alpha: 1.0) // #474E5E
let GreyColor = UIColor(red: 109.0/255.0, green: 120.0/255.0, blue: 145.0/255.0, alpha: 1.0) // #6D7891
let DarkBlue = UIColor(red: 65.0/255.0, green: 89.0/255.0, blue: 145.0/255.0, alpha: 1.0) // #415991
let BlueColor = UIColor(red: 100.0/255.0, green: 135.0/255.0, blue: 222.0/255.0, alpha: 1.0) // #6487DE
let WhiteColor = UIColor.whiteColor()
let BlackColor = UIColor.blackColor()
let ClearColor = UIColor.clearColor()