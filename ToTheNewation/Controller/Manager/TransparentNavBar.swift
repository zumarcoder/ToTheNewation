//
//  TransparentNavBar.swift
//  ToTheNewation
//
//  Created by Akash Verma on 04/06/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit

class TransparentNavBar : UINavigationController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
}
