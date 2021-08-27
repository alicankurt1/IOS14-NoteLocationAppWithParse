//
//  LocationsVC.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 26.08.2021.
//

import UIKit
import Parse

class LocationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var locationsTableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var placeImageArray = [UIImage]()
    var selectedPlaceId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        getDataFromParse()
        
        locationsTableView.delegate = self
        locationsTableView.dataSource = self
    }
    
    
    // Get Data From Parse Database
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects , error  in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Get Data From Parse Error!")
            }else{
                
                if objects != nil{
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    self.placeImageArray.removeAll(keepingCapacity: false)
                    
                    for object in objects!{
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.placeNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                            
                        }
                                               
                        // Get Image
                        if let placeImageData = object.object(forKey: "image") as? PFFileObject{
                            print(placeImageData)
                            placeImageData.getDataInBackground { data , error  in
                                if error != nil{
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                }else{
                                    if data != nil{
                                        let placeImage = UIImage(data: data!)
                                        self.placeImageArray.append(placeImage!)
                                        print(self.placeImageArray.count)
                                        // It's Important
                                        self.locationsTableView.reloadData()
                                    }
                                }
                                
                                
                            }
                        }
                        
                    }
                    self.locationsTableView.reloadData()
                }
                
                
            }
        }
        
    }
    

    
    // Table View Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        print(self.placeImageArray.count)
        if self.placeImageArray.count > 0{
            cell.imageView?.image = placeImageArray[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC"{
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenPlaceId = selectedPlaceId
            
        }
    }
    
    
    
    
    
    
    @objc func addButtonClicked(){
        // Segue
        performSegue(withIdentifier: "toAddPlaceDetailsVC", sender: nil)
    }
    
    @objc func logoutButtonClicked(){
        
        PFUser.logOutInBackground { error  in
            if error != nil{
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Logout Error")
            }else{
                self.performSegue(withIdentifier: "toLoginVC", sender: nil)
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
