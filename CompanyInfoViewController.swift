//
//  CompanyInfoViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 2/4/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// This file is for the small modal screen that pops up where a recruiter enters the 
// company name, if the company doesn't exist in the system yet. 
//
// Important notes about this file: Once enter is pressed, a new company object should
// be created in the database before the screen dismisses.

import UIKit
import Foundation
import Alamofire

// Protocol to reach the previous VC
protocol CompanyInfoViewControllerDelegate
{
    func updateNewCompany(var name: String)
}

class CompanyInfoViewController: UIViewController
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Delegate
    var delegate: CompanyInfoViewControllerDelegate?
    
    // Holds the Company name that the User enters
    @IBOutlet weak var companyName: UITextField!
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Dismiss the modal
    @IBAction func dismiss(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Submit company to the DB
    @IBAction func submitCompany(sender: AnyObject)
    {
        // First make sure that the textbox is filled in
        // If not, don't do anything
        if companyName.text!.isEmpty == false
        {
            // Create a new Company object based on the name entered
            let company = Company()
            company.name = companyName.text
            
            // Send the info to the DB
            // If it passes, then move the user back to the previous page and
            // reload the pickerview and select the new company
            company.create(
            {
                self.delegate!.updateNewCompany(company.name!)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
