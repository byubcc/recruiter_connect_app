//
//  DurationAndLunchViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/2/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import UIKit

class DurationAndLunchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Array for the number of days that a recruiter could possibly be
    // staying this trip
    let numDaysArray = [1,2,3,4,5,6,7]
    
    // Variable to hold the CheckIn variable passed in from the previous screen
    var checkIn: CheckIn?
    
    // Picker view that will show up when Number of days is tapped
    var picker = UIPickerView()
    
    // Outlet for the number of days field
    @IBOutlet weak var numberDaysField: UITextField!
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // When the user has selected to leave this page and move forward, save the 
    // number of days that they are staying in the checkIn object. 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // No matter if the user is going to eat or not, the checkIn object is finished, 
        // so send it to the DB.
        checkIn!.create()
    }
    
    // Before any segue, make sure that the user has selected the a value for number of days
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool
    {
        if numberDaysField.text.isEmpty
        {
            // Create alert
            let alert = UIAlertView()
            
            alert.title = "Empty Fields"
            alert.message = "Please select the number of days that you'll be staying."
            alert.addButtonWithTitle("OK")
            
            alert.show()
            
            return false
        }
        
        return true
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set up the pickerview and attach it to the text field
        self.picker.dataSource = self
        self.picker.delegate = self
        
        self.numberDaysField.inputView = picker
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
//----------------------------------- PICKERVIEW CONTROLS ----------------------------------//
//------------------------------------------------------------------------------------------//
    
    // There will only be 1 component in the picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // Return the count for the array of numbers for the picker view
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return numDaysArray.count
    }
    
    // Return the index for the array for the picker view
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return String(numDaysArray[row])
    }
    
    // When a user selects a number of days, put that value in the text field
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.numberDaysField.text = String(numDaysArray[row])
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

}
