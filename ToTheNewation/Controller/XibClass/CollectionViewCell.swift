//
//  CollectionViewCell.swift
//  ToTheNewation
//
//  Created by Akash Verma on 24/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentUIView.roundTheView(corner: 10)
        imageView.roundTheView(corner: 10)
        depthEffect(element: contentUIView, shadowColor: UIColor.black, shadowOpacity: 2, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
    }

    func settingData(image : UIImage , name : String)
    {
        self.imageView.image = image
        self.titleLabel.text = name
    }
    
}
