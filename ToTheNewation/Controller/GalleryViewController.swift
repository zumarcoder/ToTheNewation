//
//  GalleryViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    var arraydata = [ItemDict]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Gallery"
    }
    func getData()
    {
        let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=mango&cx=014779335774980121077%3Aj4u2pcebgfi&searchType=image&key=AIzaSyDFQJjdsS7BbaEUQYfbwOT93j00GO9kKQw&start=1&num=2")
        URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
            do{
               if error == nil
               {
                  self.arraydata = try JSONDecoder().decode([ItemDict].self, from: data!)
                    DispatchQueue.main.async {
                        self.galleryCollectionView.reloadData()
                        print(self.arraydata)
                        }
                }
            }

            catch
            {
                print(error)
                print("Error in getData()")
            }
            }.resume()
    }
}

extension GalleryViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "PopoutGalleryImage") as! PopoutGalleryImage
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
