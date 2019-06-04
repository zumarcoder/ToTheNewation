//
//  Elementroundable.swift
//  ToTheNewation
//
//  Created by Akash Verma on 22/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit

// Curves the edge of the UIView
protocol ElementRoundable {
    func roundTheView(corner : CGFloat )
}

extension UIView : ElementRoundable {
    func roundTheView(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.clipsToBounds = true
    }
}

