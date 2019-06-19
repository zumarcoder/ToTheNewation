//
//  Toastable Label.swift
//  ToTheNewation
//
//  Created by Akash Verma on 06/06/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit

extension UILabel : Toastable
{
    func toastMessageLabel(message: String)  {
        self.isHidden = false
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.font = UIFont(name: "Montserrat-Light", size: 12.0)
        self.text = message
        self.alpha = 1.0
        self.layer.cornerRadius = 10
        self.clipsToBounds  =  true
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: {(isCompleted) in
            self.isHidden = true
        })
    }
}

//extension UIView
//{
    func depthEffect (element : UIView , shadowColor : UIColor , shadowOpacity : Int , shadowOffSet : CGSize , shadowRadius : Int)
    {
        element.layer.masksToBounds = false
        element.layer.shadowColor = UIColor.lightGray.cgColor
        element.layer.shadowOpacity = 0.6
        element.layer.shadowOffset = CGSize(width: 0, height: 1.6)
        element.layer.shadowRadius = 4
    }
//}
