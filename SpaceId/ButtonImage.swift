//
//  ButtonImage.swift
//  SpaceId
//
//  Created by Dennis Kao on 5/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Cocoa
import Foundation

class ButtonImage {
    
    static let sharedInstance = ButtonImage()
    
    func roundedSquare(number: Int) -> NSImage {
        let text = String(number)
        let size = CGSize(width: 16, height: 16)
        let image = NSImage(size: size)
        
        let textColor = NSColor.white
        let font = NSFont.boldSystemFont(ofSize: 11)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: paragraphStyle
            ] as [String : Any]
        
        image.lockFocus()
        
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = NSBezierPath(roundedRect: rect, xRadius: 2, yRadius: 2)
        path.fill()
        text.drawVerticallyCentered(in: rect, withAttributes: textFontAttributes)
        
        image.unlockFocus()
        return image
    }
    
}

extension NSString {
    func drawVerticallyCentered(in rect: CGRect, withAttributes attributes: [String : Any]? = nil) {
        let size = self.size(withAttributes: attributes)
        let centeredRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.size.height-size.height)/2.0, width: rect.size.width, height: size.height)
        self.draw(in: centeredRect, withAttributes: attributes)
    }
}
