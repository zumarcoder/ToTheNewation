//
//  GalleryViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class GoogleImagesViewController: UIViewController , UISearchBarDelegate , NSFetchedResultsControllerDelegate , SavingDataToDB {
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var welcomeToGallaryView: UIView!
    
    var startIndex = 1
    var numberofItems = 10
    var imageArray = [String]()
    var titleArray = [String]()
    var originalImageURLArray = [String]()
    var searchingImageString = ""
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate lazy var fetchedResultController1: NSFetchedResultsController<UserImageData> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = UserImageData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "urlImage", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
        return fetchResultController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        depthEffect(element: self.navigationController?.navigationBar ?? self.loadMoreButton, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        self.loadMoreButton.roundTheView(corner: 10)
        depthEffect(element: self.loadMoreButton, shadowColor: UIColor.black, shadowOpacity: 2, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        showSearchBar()
        Analytics.logEvent("googleimagesvc_launched", parameters: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Google Image"
        if(self.searchController == nil)
        {
            showSearchBar()
        }else{
            self.definesPresentationContext = true
        }
        self.galleryCollectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    
    func showSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search Images"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func getData()
    {
        let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=\(searchingImageString)&cx=014779335774980121077%3Aj4u2pcebgfi&searchType=image&key=AIzaSyD2Am4ejusKPks2lPak5vDAYEv26WPG6Ug&start=\(startIndex)&num=\(numberofItems)")
        URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
            do{
                 if error == nil
                 {
                    let tempApiResponse = try JSONDecoder().decode(GoogleApi.self, from: data!)
                    DispatchQueue.main.async {
                        var tempoArrayImageUrl = [String]()
                        var tempoArrayImageTitle = [String]()
                        var tempoArrayOriginalImageURL = [String]()
                        for items in 0...9
                        {
                            tempoArrayImageUrl.append(tempApiResponse.items[items].image.thumbnailLink)
                            tempoArrayImageTitle.append(tempApiResponse.items[items].title)
                            tempoArrayOriginalImageURL.append(tempApiResponse.items[items].link)
                        }
                        
                        self.selectedDataFilling(arrayDataImageUrl: tempoArrayImageUrl, arrayDataTitleUrl: tempoArrayImageTitle, arrayDataOriginalImageURL:tempoArrayOriginalImageURL)
                        DispatchQueue.main.async {
                            self.galleryCollectionView.reloadData()
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
                 else
                 {
                    let alert = UIAlertController(title: "Something Wrong Happened", message: "Tap retry to try again", preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in self.getData()}))
                    self.present(alert, animated: true, completion: nil)
                }

            }
            catch
            {
                
            }
            }.resume()
    }
    
    @IBAction func onLoadMoreButtonTap(_ sender: Any) {
        self.startIndex = self.startIndex + numberofItems
        self.getData()
    }
    
    func selectedDataFilling(arrayDataImageUrl : [String] , arrayDataTitleUrl : [String] , arrayDataOriginalImageURL : [String] )
    {
        for item in arrayDataImageUrl
        {
             self.imageArray.append(item)
        }
        for item in arrayDataTitleUrl
        {
            self.titleArray.append(item)
        }
        for item in arrayDataOriginalImageURL
        {
            self.originalImageURLArray.append(item)
        }
    }
}



extension GoogleImagesViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        do{
            let url = self.imageArray[indexPath.row]
            let title = self.titleArray[indexPath.row]
            guard let imageURL = URL(string: url) else
                                {
                                    return cell }
                                UIImage.loadImage(url: imageURL) { image in
                                    if let image = image {
                                        cell.settingData(image: image, name: title)
                                    }
                                }
        }
        catch
        {
            print("error index out ")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let imageurl = imageArray[indexPath.row]
        let originalImageURL = originalImageURLArray[indexPath.row]
        let myString = UserDefaults.standard.string(forKey: "sentName")
        addimageInGallary(location: imageurl , username: myString!, originalImage: originalImageURL )
        //self.searchController.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        //let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        //let controller = storyBoard.instantiateViewController(withIdentifier: "PopoutGalleryImage") as! PopoutGalleryImage
        //self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
         let newString = searchController.searchBar.text!
        self.searchingImageString = newString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        if self.searchingImageString == ""
        {
            self.welcomeToGallaryView.isHidden = false
        }
        else
        {
            self.imageArray.removeAll()
            self.titleArray.removeAll()
            self.welcomeToGallaryView.isHidden = true
            getData()
        }
        
    }
}

extension UIImage {
    
    public static func loadImage(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
