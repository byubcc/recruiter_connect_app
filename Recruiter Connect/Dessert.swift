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

class Dessert {
    // Properties
    var id    : Int?
    var name  : String?
    var photo : UIImage?
    
    // Default init
    init()
    {
        
    }
    
    // Custom init for when passed a Dictionary from REST call
    init(item : NSDictionary)
    {
        if let id = item["id"] as? Int
        {
            self.id = id
        }
        
        if let name = item["name"] as? String
        {
            self.name = name
        }
    }
}