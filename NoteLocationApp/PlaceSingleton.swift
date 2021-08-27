//
//  PlaceSingleton.swift
//  NoteLocationApp
//
//  Created by Alican Kurt on 27.08.2021.
//

import Foundation
import UIKit


class PlaceSingleton{
    
    static let sharedPlaceInstance = PlaceSingleton()
    
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    
    
    private init(){}
    
    
}
