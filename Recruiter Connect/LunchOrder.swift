//
//  LunchOrder.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/23/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for the lunch orders placed by the recruiter

import Foundation
import Alamofire

class LunchOrder
{
    // Properties
    var id: Int?
    var itemRemoval: String?
    var healthConcerns: String?
    var dessert: String?
    var menuItem: MenuItem?
    var checkIn: CheckIn?
    
    // Salad dressing (if menu item is a salad)
    var dressing: SaladDressing?
    
    // Default Initializer
    init()
    {
        
    }
    
    // Custom Initializer
}