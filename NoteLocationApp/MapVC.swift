//
//  MapVC.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 26.08.2021.
//

import UIKit
import MapKit
import Parse


class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var placeMap: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        placeMap.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Mark On Map
        let longTapMapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(choosePlaceOnMap(longTapMapRecognizer:)))
        longTapMapRecognizer.minimumPressDuration = 1
        placeMap.addGestureRecognizer(longTapMapRecognizer)
        
    }
    
    @objc func choosePlaceOnMap(longTapMapRecognizer: UIGestureRecognizer){
        
        if longTapMapRecognizer.state == UIGestureRecognizer.State.began{
            
            let touches = longTapMapRecognizer.location(in: self.placeMap)
            let coordinates = self.placeMap.convert(touches, toCoordinateFrom: self.placeMap)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceSingleton.sharedPlaceInstance.placeName
            annotation.subtitle = PlaceSingleton.sharedPlaceInstance.placeType
            
            PlaceSingleton.sharedPlaceInstance.placeLatitude = String(coordinates.latitude)
            PlaceSingleton.sharedPlaceInstance.placeLongitude = String(coordinates.longitude)
            
            
            self.placeMap.addAnnotation(annotation)
            
            
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: location, span: span)
        
        // Show User Location
        self.placeMap.showsUserLocation = true
        
        placeMap.setRegion(region, animated: true)
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        //Save Parse Database
        
        let placeSingleton = PlaceSingleton.sharedPlaceInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeSingleton.placeName
        object["type"] = placeSingleton.placeType
        object["comment"] = placeSingleton.placeComment
        object["latitude"] = placeSingleton.placeLatitude
        object["longitude"] = placeSingleton.placeLongitude
        
        if let imageData = placeSingleton.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        
        object.saveInBackground { success , error  in
            if error != nil{
                self.makeAlert(title: "Error", message: "Database Error!")
            }else{
                self.performSegue(withIdentifier: "toLocationsVCfromMapVC", sender: nil)
            }
        }
        
    }
    
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

 

}
