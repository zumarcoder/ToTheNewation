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

class MapViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate , UIGestureRecognizerDelegate , NSFetchedResultsControllerDelegate {
    
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
        mapView.mapType = MKMapType.standard
        mapView.showsUserLocation = true
    }
    
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       self.navigationController?.navigationBar.topItem?.title = "Map"
        for item in fetchedResultController.fetchedObjects!
        {
            let anotationn = MKPointAnnotation()
            anotationn.title = item.name
            anotationn.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
            mapView.addAnnotation(anotationn)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
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
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        self.mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("unable to access your Current Location")
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Location updation in process")
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Location updation is done")
    }
}
