//
//  String.swift
//  Todotrix
//
//  Created by leo on 16/7/4.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import TextAttributes

public extension NSAttributedString {
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat.max)
        let options = NSStringDrawingOptions.UsesLineFragmentOrigin
        let size = boundingRectWithSize(boundingSize, options: options, context: nil)
        return ceil(size.height)
    }
}

public extension String {
    
    func attributedTitle(color color: UIColor , alignment: NSTextAlignment) -> NSAttributedString {
        let attrs = TextAttributes()
            .font(UIFont.defaultFont(size: 17))
            .foregroundColor(color)
            .alignment(alignment)
            .lineSpacing(3)
            .dictionary
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    func title() -> NSAttributedString {
        return attributedTitle(color: UIColor.blackColor(), alignment: .Left)
    }
    
    func centeredTitle() -> NSAttributedString {
        return attributedTitle(color: UIColor.blackColor(), alignment: .Center)
    }
    
    func centeredGrayTitle() -> NSAttributedString {
        return attributedTitle(color: UIColor(hex: 0xdddddd), alignment: .Center)
    }
}