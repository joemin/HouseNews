//
//  TextField.swift
//  House News
//
//  Created by Joseph Min on 6/17/16.
//
//

import Foundation
import UIKit

class TextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.textColor = UIColor.blackColor()
        self.font = UIFont(name: (self.font?.fontName)!, size: 12)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}