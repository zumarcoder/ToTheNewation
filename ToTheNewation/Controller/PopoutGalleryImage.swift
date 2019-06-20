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
    
    override func viewWillDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    
    override var shouldAutorotate: Bool {
        return true
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
