//
//  EmployeeDetails.swift
//  ToTheNewation
//
//  Created by Akash Verma on 22/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit
import MapKit

class EmployeeDetails: UIViewController, Gettable ,UIGestureRecognizerDelegate , MKMapViewDelegate , CLLocationManagerDelegate , SavingDataToDB
{
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var profilePictureBaseView : UIView!
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var gallerybuttonUIView: UIView!
    @IBOutlet weak var locationbuttonUIView: UIView!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var imageAddButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var addAnnotationButton: UIButton!
    @IBOutlet weak var gallaryCollectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var galleryandmapViewCombinedView: UIView!
    
    var arraydata = [EmployeeStruct]()
    var empId = ""
    let locationManager = CLLocationManager()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
        depthEffect(element: detailsView, shadowColor: UIColor.black, shadowOpacity: 1, shadowOffSet:  CGSize(width: 0, height: 1.6), shadowRadius: 4)
        depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.delegate = self
        profilePictureBaseView.addGestureRecognizer(tap)
        let nib = UINib.init(nibName: "CollectionViewCell", bundle: nil)
        gallaryCollectionView.register(nib, forCellWithReuseIdentifier: "collectionCell")
        
        if CLLocationManager.authorizationStatus() == .notDetermined
        {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied
        {
            print("Location services were previously denied. Please enable location services for this app in Settings.")
        }
        else if CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
        }
    
        detailsView.roundTheView(corner: 10)
        profilePictureImage.roundTheView(corner: profilePictureImage.bounds.height/2)
        galleryandmapViewCombinedView.roundTheView(corner: 15)
        detailsView.bordertheUIView(borderWidth: 2.5, borderColor: UIColor.gray.cgColor)
        gallerybuttonUIView.roundtheCorners(corner: 15, maskableCorners: [.layerMinXMinYCorner])
        locationbuttonUIView.roundtheCorners(corner: 15, maskableCorners: [.layerMaxXMinYCorner])
        gallaryCollectionView.roundtheCorners(corner: 15, maskableCorners: [.layerMinXMinYCorner , .layerMaxXMaxYCorner , .layerMinXMaxYCorner])
        mapView.roundtheCorners(corner: 15, maskableCorners: [.layerMaxXMinYCorner ,  .layerMaxXMaxYCorner , .layerMinXMaxYCorner])
        getData()
        }
    func getData()
    {
        let url = URL(string: "http://dummy.restapiexample.com/api/v1/employee/\(empId)")
        URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
            do{
                if error == nil
                {
                    let result = [try JSONDecoder().decode(EmployeeStruct.self, from: data!)]
                    DispatchQueue.main.async {
                        self.nameLabel.text = result[0].employee_name
                        self.ageLabel.text = result[0].employee_age
                        self.salaryLabel.text = result[0].employee_salary
                        self.idLabel.text = result[0].id
                    }
                }
            }
                
            catch
            {
                print("Error in getData()")
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Employee Details"
        locationbuttonUIView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func getEmpId(_ empId: String) {
        self.empId = empId
    }
    
    @IBAction func onGalleryButtonTap(_ sender: Any) {
        mapView.isHidden = true
        galleryButton.setTitleColor(.white , for: .normal)
        imageAddButton.setTitleColor(.white , for: .normal)

        gallaryCollectionView.isHidden = false
        gallerybuttonUIView.layer.backgroundColor = UIColor.init(white: 1.0, alpha: 0).cgColor
        locationbuttonUIView.layer.backgroundColor = UIColor.white.cgColor
        mapButton.setTitleColor(.black , for: .normal)
        addAnnotationButton.setTitleColor(.black , for: .normal)

    }
    
    @IBAction func onMapButtonTap(_ sender: Any) {
        gallaryCollectionView.isHidden = true
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
        mapButton.setTitleColor(.white , for: .normal)
        addAnnotationButton.setTitleColor(.white , for: .normal)

        mapView.isHidden = false
        locationbuttonUIView.layer.backgroundColor = UIColor.init(white: 1.0, alpha: 0).cgColor
        gallerybuttonUIView.layer.backgroundColor = UIColor.white.cgColor
        galleryButton.setTitleColor(.black , for: .normal)
        imageAddButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func onaddAnotationTap(_ sender: Any) {
        gallaryCollectionView.isHidden = true
        mapButton.setTitleColor(.white , for: .normal)
        addAnnotationButton.setTitleColor(.white , for: .normal)
        
        mapView.isHidden = false
        locationbuttonUIView.layer.backgroundColor = UIColor.init(white: 1.0, alpha: 0).cgColor
        gallerybuttonUIView.layer.backgroundColor = UIColor.white.cgColor
        galleryButton.setTitleColor(.black , for: .normal)
        imageAddButton.setTitleColor(.black, for: .normal)
    }

    @IBAction func onimageAddTap(_ sender: Any) {
        mapView.isHidden = true
        galleryButton.setTitleColor(.white , for: .normal)
        imageAddButton.setTitleColor(.white , for: .normal)
        
        gallaryCollectionView.isHidden = false
        gallerybuttonUIView.layer.backgroundColor = UIColor.init(white: 1.0, alpha: 0).cgColor
        locationbuttonUIView.layer.backgroundColor = UIColor.white.cgColor
        mapButton.setTitleColor(.black , for: .normal)
        addAnnotationButton.setTitleColor(.black , for: .normal)
        

    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionStyleSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionStyleSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionStyleSheet.addAction(UIAlertAction(title: "Google Images", style: .default, handler: {(action : UIAlertAction) in
            
        }))
        
        actionStyleSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil ))
        self.present(actionStyleSheet, animated: true, completion: nil)
    }
    

    @objc func handleTap(_ gestureReconizer: UILongPressGestureRecognizer)
    {
        if gestureReconizer.state == .began {
            let location = gestureReconizer.location(in: mapView)
            let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
            
            // Add annotation:
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "latitude:" + String(format: "%.02f",annotation.coordinate.latitude) + "& longitude:" + String(format: "%.02f",annotation.coordinate.longitude)
            mapView.addAnnotation(annotation)
            addData(name: "NewAnnotation", longitude: annotation.coordinate.longitude, latitude: annotation.coordinate.latitude)
//                    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//                    urls[urls.count-1] as NSURL
//                    print(urls)
        }
    }

    
    var selectedAnnotation: MKPointAnnotation?
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
        let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
        print("latitude: \(latValStr) & longitude: \(lonvalStr)")
    }
}

extension EmployeeDetails : UICollectionViewDataSource , UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gallaryCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        return cell
    }
}

extension EmployeeDetails : UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        profilePictureImage.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension EmployeeDetails
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to access your Current Location")
    }
}

