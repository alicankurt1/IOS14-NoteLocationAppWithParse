//
//  AddPlaceDetailVC.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 26.08.2021.
//

import UIKit

class AddPlaceDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var placeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        placeImageView.isUserInteractionEnabled = true
        let imageRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        placeImageView.addGestureRecognizer(imageRecognizer)
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && commentTextView.text != "" && placeImageView.image != nil{
            
            let placeDetailsSingleton = PlaceSingleton.sharedPlaceInstance
            placeDetailsSingleton.placeName = placeNameText.text!
            placeDetailsSingleton.placeType = placeTypeText.text!
            placeDetailsSingleton.placeComment = commentTextView.text
            placeDetailsSingleton.placeImage = placeImageView.image!
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
            
        }else{
            makeAlert(title: "Error", message: "Next Button Error!")
        }
        
        
    }
    
    
    func makeAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
