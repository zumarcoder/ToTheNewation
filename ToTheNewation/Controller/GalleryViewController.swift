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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadMoreButton: UIButton!
    
    var startIndex = 1
    var numberofItems = 10
    var imageArray = [String]()
    var titleArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        depthEffect(element: self.navigationController?.navigationBar ?? self.loadMoreButton, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        self.loadMoreButton.roundTheView(corner: 10)
        depthEffect(element: self.loadMoreButton, shadowColor: UIColor.black, shadowOpacity: 2, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Gallery"
        self.galleryCollectionView.reloadData()
    }
    
    func getData()
    {
        let url = URL(string: "https://www.googleapis.com/customsearch/v1?q=mango&cx=014779335774980121077%3Aj4u2pcebgfi&searchType=image&key=AIzaSyDFQJjdsS7BbaEUQYfbwOT93j00GO9kKQw&start=\(startIndex)&num=\(numberofItems)")
        URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
            do{
                let tempApiResponse = try JSONDecoder().decode(GoogleApi.self, from: data!)
                DispatchQueue.main.async {
                    var tempoArrayImageUrl = [String]()
                    var tempoArrayImageTitle = [String]()
                    for items in 0...9
                    {
                        tempoArrayImageUrl.append(tempApiResponse.items[items].image.thumbnailLink)
                        tempoArrayImageTitle.append(tempApiResponse.items[items].title)
                    }
                    
                    self.selectedDataFilling(arrayDataImageUrl: tempoArrayImageUrl, arrayDataTitleUrl: tempoArrayImageTitle)
                    DispatchQueue.main.async {
                        self.galleryCollectionView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
            catch
            {
                print("Error in getData()")
            }
            }.resume()
    }
    
    @IBAction func onLoadMoreButtonTap(_ sender: Any) {
        self.startIndex = self.startIndex + numberofItems
        self.getData()
    }
    
    func selectedDataFilling(arrayDataImageUrl : [String] , arrayDataTitleUrl : [String])
    {
        for item in arrayDataImageUrl
        {
             self.imageArray.append(item)
        }
        for item in arrayDataTitleUrl
        {
            self.titleArray.append(item)
        }
    }
}



extension GalleryViewController : UICollectionViewDelegate , UICollectionViewDataSource {
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
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "PopoutGalleryImage") as! PopoutGalleryImage
        self.navigationController?.pushViewController(controller, animated: true)
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
