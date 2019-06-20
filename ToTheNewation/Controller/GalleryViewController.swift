//
//  GalleryViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 20/06/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GalleryViewController :UIViewController , NSFetchedResultsControllerDelegate
{
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var gallaryImageUrl = [String]()
    var galarytitle = [String]()
    
    fileprivate lazy var fetchedResultController1: NSFetchedResultsController<UserImageData> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = UserImageData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "urlImage", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
        return fetchResultController as! NSFetchedResultsController<UserImageData>
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        for item in fetchedResultController1.fetchedObjects!
        {
                self.gallaryImageUrl.append(item.urlImage!)
                self.galarytitle.append(item.userName ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.all)
        self.navigationController?.navigationBar.topItem?.title = "Gallery"
        self.gallaryImageUrl.removeAll()
        self.galarytitle.removeAll()
        for item in fetchedResultController1.fetchedObjects!
        {
            self.gallaryImageUrl.append(item.urlImage!)
            self.galarytitle.append(item.userName ?? "")
        }
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

extension GalleryViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallaryImageUrl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        do{
            let url = self.gallaryImageUrl[indexPath.row]
            let title = self.galarytitle[indexPath.row]
            guard let imageURL = URL(string: url) else
            {
                return cell }
            UIImage.loadImage(url: imageURL) { image in
                if let image = image {
                    cell.imageView.image = image
                    cell.titleLabel.text = title
                }
            }
        }
        return cell

    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("update in db")
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //print("update in db done")
        self.galleryCollectionView.reloadData()
    }
    
}
