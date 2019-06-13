//
//  MapViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , UIGestureRecognizerDelegate{
    
    fileprivate lazy var fetchedResultController: NSFetchedResultsController<Annotation> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = Annotation.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate
        try! fetchResultController.performFetch()
        return fetchResultController
    }()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationUpdateUIView: UIView!
    @IBOutlet weak var locationUpdateImage: UIImageView!
    
    let locationManager = CLLocationManager()
//    var keyLat:String = "49.2768"
//    var keyLon:String = "-123.1120"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        tap.delegate = self
        locationUpdateUIView.addGestureRecognizer(tap)
        depthEffect(element: locationUpdateImage, shadowColor: UIColor.black, shadowOpacity: 40, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 90)
        depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 1, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
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
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        longPressRecogniser.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecogniser)
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
//        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(keyLat.toFloat()),longitude:        CLLocationDegrees(keyLon.toFloat()))
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: location, span: span)
//        mapView.setRegion(region, animated: true)
//
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = location
//        annotation.title = "BC Place Stadium"
//        annotation.subtitle = "Vancouver Canada"
//        mapView.addAnnotation(annotation)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.navigationBar.topItem?.title = "Map"
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
        }
    }
    
    var selectedAnnotation: MKPointAnnotation?
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let latValStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.latitude)!))
        let lonvalStr : String = String(format: "%.02f",Float((view.annotation?.coordinate.longitude)!))
        print("latitude: \(latValStr) & longitude: \(lonvalStr)")
    }
    
}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toFloat() -> Float {
        return (self as NSString).floatValue
    }
}

extension MapViewController
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to access your Current Location")
    }
}
