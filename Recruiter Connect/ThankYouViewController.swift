//
//  ThankYouViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 7/27/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import UIKit

class ThankYouViewController: UIViewController
{

//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Style the nav bar and remove the back button so the user has to return 
        // to home through the "Home" button
        // Set the nav bar translucent and remove the title
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = ""
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
}
