//
//  WelcomeScreenViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/10/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// Contains class for the Welcome Screen view controller
//
// NOTES: This file also holds the Exit Segue that can occur from the Thank You Screen

import UIKit
import Alamofire

class WelcomeScreenViewController: UIViewController
{
    
//------------------------------------------------------------------------------------------//
//---------------------------------------- OUTLETS -----------------------------------------//
//------------------------------------------------------------------------------------------//

    // Check In Button
    @IBOutlet weak var checkInButton: UIButton!
    
    // Parent view container
    @IBOutlet var mainView: UIView!
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Test the network connectivity as the page loads using the GeneralUtility Class
//        GeneralUtility.checkNetwork(self.mainView, needOverlay: false, needSpinner: false)
//        {
//            (errorFlag) in
//                
//            if errorFlag
//            {
//                let alert = UIAlertView()
//                
//                alert.title   = "Network error"
//                alert.message = "Please make sure you are connected to WiFi. If you are, then please try again later"
//                alert.addButtonWithTitle("OK")
//                
//                alert.show()
//            }
//        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    /** 
     * Exit/Unwind Segue code
     */
    @IBAction func returnHome(segue: UIStoryboardSegue)
    {
        
    }
    
    /**
     * Test the network connection before moving on
     */
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if identifier == "toRecruiterInfo"
        {
            return GeneralUtility.checkNetwork(self.mainView, needOverlay: true, needSpinner: true)
            {
                (errorFlag) in
                
                
            }
        }
        else
        {
            return true
        }
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//---------------------------------- OTHER USEFUL FUNCTIONS --------------------------------//
//------------------------------------------------------------------------------------------//
    
    
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
}
