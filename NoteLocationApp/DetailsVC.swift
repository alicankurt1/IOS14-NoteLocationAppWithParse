//
//  DetailsVC.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 26.08.2021.
//

import UIKit
import MapKit
import Parse


class DetailsVC: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var detailsPlaceImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeCommentTextView: UITextView!
    @IBOutlet weak var detailsMap: MKMapView!
    

    var choosenPlaceId = ""
    var placeLatitude = Double()
    var placeLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsMap.delegate = self
        
        getDataFromParse()

    }
    
    
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects , error  in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else{
                if objects != nil{
                    // OBJECTS
                    let choosenPlaceObject = objects![0]
                    if let placeName = choosenPlaceObject.object(forKey: "name") as? String{
                        if let placeType = choosenPlaceObject.object(forKey: "type") as? String{
                            if let placeComment = choosenPlaceObject.object(forKey: "comment") as? String{
                                if let placeLatitudeDB = choosenPlaceObject.object(forKey: "latitude") as? String{
                                    if let placeLongitudeDB = choosenPlaceObject.object(forKey: "longitude") as? String{
                                        
                                        self.placeNameLabel.text = placeName
                                        self.placeTypeLabel.text = placeType
                                        self.placeCommentTextView.text = placeComment
                                        if let doubleLatitude = Double(placeLatitudeDB){
                                            if let doubleLongitude = Double(placeLongitudeDB){
                                                self.placeLatitude = doubleLatitude
                                                self.placeLongitude = doubleLongitude
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    // Get Image From Parse
                    if let placeImageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject{
                        placeImageData.getDataInBackground { data , error  in
                            if error != nil{
                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error 342")
                            }else{
                                if data != nil{
                                    self.detailsPlaceImageView.image = UIImage(data: data!)
                                }
                            }
                        }
                    }
                    
                    // MAPS
                    let location = CLLocationCoordinate2DMake(self.placeLatitude, self.placeLongitude)
                    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    let region = MKCoordinateRegion(center: location, span: span)
                    
                    self.detailsMap.showsUserLocation = true
                    self.detailsMap.setRegion(region, animated: true)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location
                    annotation.title = self.placeNameLabel.text
                    annotation.subtitle = self.placeTypeLabel.text
                    
                    self.detailsMap.addAnnotation(annotation)
                    
                    
                    
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        // Added button on annotation
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let annoButton = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = annoButton
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    // Go To Navigation when Clicked Annotation
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.placeLatitude != 0.0 && self.placeLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.placeLatitude, longitude: self.placeLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error  in
                if error == nil{
                    if placemarks != nil{
                        let mkPlaceMark = MKPlacemark(placemark: placemarks![0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                }
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
