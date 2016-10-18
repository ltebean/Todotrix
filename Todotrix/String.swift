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
    
    func heightWithConstrainedWidth(_ width: CGFloat) -> CGFloat {
        let boundingSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let options = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = boundingRect(with: boundingSize, options: options, context: nil)
        return ceil(size.height)
    }
}

public extension String {
    
    func attributedTitle(color: UIColor , alignment: NSTextAlignment) -> NSAttributedString {
        let attrs = TextAttributes()
            .font(UIFont.defaultFont(size: 17))
            .foregroundColor(color)
            .alignment(alignment)
            .lineSpacing(3)
            .dictionary
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    func title() -> NSAttributedString {
        return attributedTitle(color: UIColor.black, alignment: .left)
    }
    
    func centeredTitle() -> NSAttributedString {
        return attributedTitle(color: UIColor.black, alignment: .center)
    }
    
    func centeredGrayTitle() -> NSAttributedString {
        return attributedTitle(color: UIColor(hex: 0xdddddd), alignment: .center)
    }
}
