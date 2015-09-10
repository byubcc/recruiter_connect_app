//
//  RecruiterInfoViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 2/4/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//
// This file contains the class for the first screen of the New Recruiter
// use case flow, where a recruiter begins placing their information
// to register in the system. 
//
// Imporant notes about this file: Companies are pulled via AlamoFire and placed
// in the Picker View which shows up when user taps the company text field.


import UIKit
import Foundation
import Alamofire

class RecruiterInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CompanyInfoViewControllerDelegate, UITextFieldDelegate
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Fields for adding in recruiter information
    @IBOutlet weak var firstNameField       : UITextField!
    @IBOutlet weak var lastNameField        : UITextField!
    @IBOutlet weak var emailField           : UITextField!
    @IBOutlet weak var passwordField        : UITextField!
    @IBOutlet weak var confirmPasswordField : UITextField!
    @IBOutlet weak var phoneField           : UITextField!
    @IBOutlet weak var companyField         : UITextField!
    
    // Array to hold the Company objects returned from the API
    var companiesArray = [Company]()
    
    // Recruiter object to hold the new recruiter
    var recruiter = Recruiter()
    
    // Pickerview that will appear when the user taps on the "Company" textfield
    var picker = UIPickerView()
    
    // Main view in the VC
    @IBOutlet var parentView: UIView!
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        // Grab the companies
        grabCompanies(){}
        
        // Load the companies into the pickerview and attach pickerview to the
        // company text field
        self.picker.delegate   = self
        self.picker.dataSource = self
        
        self.companyField.inputView = self.picker
        
        // Set up the delegates for the textfields to this class
        self.firstNameField.delegate       = self
        self.lastNameField.delegate        = self
        self.emailField.delegate           = self
        self.passwordField.delegate        = self
        self.confirmPasswordField.delegate = self
        self.phoneField.delegate           = self
        self.companyField.delegate         = self
        
        // Set the first responder to the first name field
        self.firstNameField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * The functions to move to the next UITextField for all of the textfields
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Based on which textfield it is, move to the next one
        switch textField
        {
            case firstNameField:
                lastNameField.becomeFirstResponder()
            case lastNameField:
                emailField.becomeFirstResponder()
            case emailField:
                passwordField.becomeFirstResponder()
            case passwordField:
                confirmPasswordField.becomeFirstResponder()
            case confirmPasswordField:
                phoneField.becomeFirstResponder()
            case phoneField:
                companyField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        
        return true
    }
    
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
     * Action to dismiss the page if the user selects the "back" button at the top of the screen
     */
    @IBAction func dismiss(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     * Next button tapped - Check the network before calling the segue
     */
    @IBAction func nextButtonTapped(sender: AnyObject)
    {
        // Test the network
        GeneralUtility.checkNetwork(self.parentView, needOverlay: true, needSpinner: true)
        {
            (errorFlag) in
            
            // Let the user know the network is down right now
            if errorFlag
            {
                let alert = UIAlertView()
                
                alert.title   = "Network error"
                alert.message = "Please make sure you are connected to WiFi. If you are, then please try again later"
                alert.addButtonWithTitle("OK")
                
                alert.show()
            }
            else
            {
                self.performSegueWithIdentifier("toVehicleInfo", sender: nil)
            }
        }
        
        // Check to see if the textboxes are empty
        if firstNameField.text.isEmpty || lastNameField.text.isEmpty || emailField.text.isEmpty || passwordField.text.isEmpty || confirmPasswordField.text.isEmpty || companyField.text.isEmpty || phoneField.text.isEmpty
        {
            // Let the user know that they need to fill in the text fields
            let alert = UIAlertView()
            
            alert.title   = "Empty Fields"
            alert.message = "Please fill in all fields on the screen before moving on."
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
        else if passwordField.text != confirmPasswordField.text
        {
            // Let the user know that they need to fill in the text fields
            let alert = UIAlertView()
            
            alert.title   = "Passwords Don't Match"
            alert.message = "The text in the password and confirmation fields don't match."
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
        else if emailField.text.rangeOfString("@") == nil || emailField.text.rangeOfString(".") == nil
        {
            // Let the user know that they need to fill in the text fields
            let alert = UIAlertView()
            
            alert.title   = "Invalid Email"
            alert.message = "Please enter a valid email address."
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
        else
        {
            // If the recruiter object doesn't have an ID (ie. It's not created in the DB yet), create it in the db
            // Else just move along, since the recruiter object already exists, and can be passed as is
            if self.recruiter.id == nil
            {
                // Fill in the recruiter's info in the recruiter object and post it to the db
                recruiter.firstName = firstNameField.text
                recruiter.lastName  = lastNameField.text
                recruiter.password  = passwordField.text
                recruiter.email     = emailField.text
                
                // Get the right value from the companies array according to what
                // picker view row is selected
                let pickerRow = picker.selectedRowInComponent(0)
                
                recruiter.company = companiesArray[pickerRow]
                
                // Post the recruiter to the DB
                recruiter.create(nil)
            }
        }
    }
    
    /**
     * Prepare for segue
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Check that it's the correct segue
        if segue.identifier == "addCompanySegue"
        {
            // Set self as the delegate for the destination
            var destination      = segue.destinationViewController as! CompanyInfoViewController
            destination.delegate = self
        }
        else if segue.identifier == "toVehicleInfo"
        {
            // Set the destination as the next VC, and set that destination delegate as this controller
            // Send the recruiter object to the next screen to be added to the check in
            var destination       = segue.destinationViewController as! VehicleInfoViewController
            destination.delegate  = self
            destination.recruiter = self.recruiter
        }
    }
    
    /** 
     * Prepare for the segue and stop it if the information isn't filled out totally
     */
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        // Check to see if it's the correct segue
        if identifier == "toVehicleInfo"
        {
            // Check to see if the textboxes are empty
            if firstNameField.text.isEmpty || lastNameField.text.isEmpty || emailField.text.isEmpty || passwordField.text.isEmpty || confirmPasswordField.text.isEmpty || companyField.text.isEmpty || phoneField.text.isEmpty
            {
                // Let the user know that they need to fill in the text fields
                let alert = UIAlertView()
                
                alert.title   = "Empty Fields"
                alert.message = "Please fill in all fields on the screen before moving on."
                alert.addButtonWithTitle("OK")
                
                alert.show()
                
                return false
            }
            else if passwordField.text != confirmPasswordField.text
            {
                // Let the user know that they need to fill in the text fields
                let alert = UIAlertView()
                
                alert.title   = "Passwords Don't Match"
                alert.message = "The text in the password and confirmation fields don't match."
                alert.addButtonWithTitle("OK")
                
                alert.show()
                
                return false
            }
            else if emailField.text.rangeOfString("@") == nil || emailField.text.rangeOfString(".") == nil
            {
                // Let the user know that they need to fill in the text fields
                let alert = UIAlertView()
                
                alert.title   = "Invalid Email"
                alert.message = "Please enter a valid email address."
                alert.addButtonWithTitle("OK")
                
                alert.show()
                
                return false
            }
            else
            {
                // If the recruiter object doesn't have an ID (ie. It's not created in the DB yet), create it in the db
                // Else just move along, since the recruiter object already exists, and can be passed as is
                if self.recruiter.id == nil
                {
                    // Fill in the recruiter's info in the recruiter object and post it to the db
                    recruiter.firstName = firstNameField.text
                    recruiter.lastName  = lastNameField.text
                    recruiter.password  = passwordField.text
                    recruiter.email     = emailField.text
                    
                    // Get the right value from the companies array according to what
                    // picker view row is selected
                    let pickerRow = picker.selectedRowInComponent(0)
                    
                    recruiter.company = companiesArray[pickerRow]
                    
                    // Post the recruiter to the DB
                    recruiter.create(nil)
                }
                
                return true
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
//----------------------------------- PICKERVIEW CONTROLS ----------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
     * Function to go out and grab the companies
     */
    func grabCompanies(completion:() -> Void)
    {
        // Go out and grab all of the companies from the DB
        let endpoint = "https://recruiterconnect.byu.edu/api/companies/?format=json"
        // let endpoint = "http://localhost:8000/api/companies/?format=json"
        
        Alamofire.request(.GET, endpoint)
            .responseJSON
            {
                (request, response, data, error) in
                
                // If there is an error, print it
                if let JSONError = error
                {
                    println(JSONError)
                }
                
                // Unwrap the data into a NSArray
                if let json: NSArray = data as? NSArray
                {
                    // Delete all items from the company array first, in case
                    // the array is already populated
                    self.companiesArray.removeAll(keepCapacity: false)
                    
                    // Populate the companies array with the objects
                    for item in json
                    {
                        var company = Company(item: item as! NSDictionary)
                        self.companiesArray.append(company)
                    }
                }
                
                self.picker.reloadAllComponents()
                
                // Call the completion handler
                completion()
            }
    }
    
    /**
     * Select a recently updated company after modal is dismissed
     */
    func updateNewCompany(newCompany: String)
    {
        // reload the pickerview
        grabCompanies(
        {
            
            var companyNameArray = [String]()
        
            for company in self.companiesArray
            {
                companyNameArray.append(company.name!)
            }
        
            // find the correct company from the array and select that row
            if let index = find(companyNameArray, newCompany)
            {
                self.picker.selectRow(index, inComponent: 0, animated: false)
            }
        })
    }
    
    /**
     * Required method for the UIPickerViewDataSource protocol.
     * Returns the number of components for the companies picker view.
     */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    /** 
     * Required method for the UIPickerViewDataSource protocol
     * Returns the number of rows for the single component in the picker view.
     */
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.companiesArray.count
    }
    
    /**
     * Put the names of the companies into the picker view
     */
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return self.companiesArray[row].name!
    }
    
    /** 
     * When a user selects company, add it to the company text field
     */
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.companyField.text = companiesArray[row].name!
        self.companyField.resignFirstResponder()
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

}

//------------------------------------------------------------------------------------------//
//---------------------------------- DELEGATE EXTENSION ------------------------------------//
//------------------------------------------------------------------------------------------//

extension RecruiterInfoViewController: VehicleInfoDelegate
{
    func updateRecruiterObject(recruiter: Recruiter?)
    {
        if let recruiterObject = recruiter
        {
            self.recruiter = recruiterObject
        }
    }
}

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
