//
//  ExtentionFile.swift
//  ToTheNewation
//
//  Created by Akash Verma on 22/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func deselectSelectedRow(animated: Bool) {
        if let indexPathForSelectedRow = self.indexPathForSelectedRow {
            self.deselectRow(at: indexPathForSelectedRow, animated: animated)
        }
    }
    
}


extension UIView {
    // This Method can curve any specific corner of the view
    func roundtheCorners(corner: CGFloat , maskableCorners : CACornerMask ) {
        self.layer.cornerRadius = corner
        self.layer.maskedCorners = maskableCorners
        //self.clipsToBounds = true
    }

    
    // This Function Gives border width and border color to the UIview
    func bordertheUIView(borderWidth : CGFloat , borderColor : CGColor ) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}


extension UITextField{
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
