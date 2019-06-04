//
//  Agreement.swift
//  ToTheNewation
//
//  Created by Akash Verma on 03/06/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit

class AgreementViewController : UIViewController
{
    @IBOutlet weak var agreementTextView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        agreementTextView.textContainerInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 0.0, right: 10.0)
        agreementTextView.roundtheCorners(corner: 10, maskableCorners: [.layerMinXMinYCorner , .layerMaxXMinYCorner])
        closeButton.roundtheCorners(corner: 10, maskableCorners: .layerMinXMaxYCorner)
        acceptButton.roundtheCorners(corner: 10, maskableCorners: .layerMaxXMaxYCorner)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        print(UserDefaults.standard.bool(forKey: "accepted"))
//        if(UserDefaults.standard.bool(forKey: "accepted"))
//        {
//            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! RootTabBarController
//            self.navigationController?.pushViewController(controller, animated: false)
//        }
//    }
    //ascjnjdkncjksdnjkvnjksnvlksd
    //hjgjhgjgjhgbjk
    @IBAction func onCloseButtonTap(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func onAcceptButtonTap(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RootTabBarController") as! RootTabBarController
        self.navigationController?.pushViewController(controller, animated: true)
        UserDefaults.standard.set(true, forKey: "accepted")
    }
}
