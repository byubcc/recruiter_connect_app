//
//  Dessert.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/10/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// File for the Dessert class

import Foundation
import UIKit
import Alamofire

class Dessert {
    // Properties
    var id       : Int?
    var name     : String?
    var photoURL : String?
    var photo    : UIImage?
    
    // Default init
    init()
    {
        
    }
    
    // Custom init for when passed a Dictionary from REST call
    init(item : NSDictionary, completion: (() -> ())?)
    {
        var errorFlag = false
        
        if let id = item["id"] as? Int
        {
            self.id = id
        }
        
        if let name = item["name"] as? String
        {
            self.name = name
        }
        
        if let photoURL = item["photo"] as? String
        {
            self.photoURL = "http://recruiterconnect.byu.edu/media\(photoURL)"
        }
        else
        {
            self.photoURL = "http://recruiterconnect.byu.edu/media/utility_images/not-available.png"
        }
        
        // Alamofire call to get the image
        Alamofire.request(.GET, self.photoURL!, parameters: nil).response
        {
            (request, response, data, error) in
                
            if let ERROR = error
            {
                println("<<<<<<<<<<<<<<<<<<<<<<< DESSERT IMAGE ERROR: \(ERROR)")
                errorFlag = true
            }
                
            if let image = data
            {
                self.photo = UIImage(data : image)
            }
                
            completion?()
        }
    }
}