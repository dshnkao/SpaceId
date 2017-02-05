//
//  ButtonImage.swift//  SpaceId
//
//  Created by Dennis Kao on 5/2/17.
//  Copyright © 2017 Dennis Kao. All rights reserved.
//

import Cocoa
import Foundation

class ButtonImage {
    
    private let size = CGSize(width: 16, height: 16)

    private func textAttributes(color: NSColor) -> [String: Any] {
        let font = NSFont.boldSystemFont(ofSize: 11)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        return [ NSFontAttributeName: font,
                 NSForegroundColorAttributeName: color,
                 NSParagraphStyleAttributeName: paragraphStyle
               ] as [String : Any]
    }
    
    func roundedSquare(text: String) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        let rect = NSRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = NSBezierPath(roundedRect: rect, xRadius: 2, yRadius: 2)
        path.fill()
        text.drawVerticallyCentered(in: rect, withAttributes: textAttributes(color: NSColor.white))
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
