//
//  PopoutGalleryImage.swift
//  ToTheNewation
//
//  Created by Akash Verma on 30/05/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class PopoutGalleryImage: UIViewController {
    @IBOutlet weak var popOutImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            let url = UserDefaults.standard.string(forKey: "BigImage")
            guard let imageURL = URL(string: url!)
                else
            {
                return
            }
            UIImage.loadImage(url: imageURL) { image in
                if let image = image {
                    self.popOutImageView.image = image
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

}
