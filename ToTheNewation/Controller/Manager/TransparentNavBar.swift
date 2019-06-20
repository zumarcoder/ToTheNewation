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
    
//    override var shouldAutorotate: Bool{
//        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
//            return true
//        }else{
//            return false
//        }
//    }
//
//
//    override var supportedInterfaceOrientations:UIInterfaceOrientationMask {
//        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){
//            return UIInterfaceOrientationMask.allButUpsideDown
//        }else
//        {
//            return UIInterfaceOrientationMask.portrait
//        }
//    }
   
}
