//
//  PopoutGalleryImage.swift
//  ToTheNewation
//
//  Created by Akash Verma on 30/05/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class PopoutGalleryImage: UIViewController {
    @IBOutlet weak var popOutCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        popOutCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
    }
}

extension PopoutGalleryImage
: UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20000
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = popOutCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        return cell
    }
    
}
