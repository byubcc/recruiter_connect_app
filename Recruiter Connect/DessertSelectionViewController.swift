//
//  DessertSelectionViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/11/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import UIKit
import Alamofire

/**
 * Protocol for the Lunch Options screen to conform to as this VC's delegate. 
 * This will allow the this VC to dismiss itself after creating the lunch order
 * and then move to the Thank You screen from the Lunch Options menu
 */
protocol DessertSelectionDelegate
{
    func dismissDessertSelection()
}

class DessertSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

//------------------------------------------------------------------------------------------//
//---------------------------------------- OUTLETS -----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Variable for the delegate
    var delegate : DessertSelectionDelegate?
    
    // Array for the desserts
    var desserts = [Dessert]()
    
    // Variable to hold the lunch order object
    var lunchOrder : LunchOrder?
    
    // Collectionview
    @IBOutlet weak var collection: UICollectionView!
    
    // Holds the index path for the selected UICollectionView Cell
    var selectedCellPath : NSIndexPath?
    
    // Styles
    let selectedTabColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 1.0)
    
    // Buttons
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the button's styles
        self.cancelButton.backgroundColor    = UIColor.clearColor()
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderWidth  = 1
        self.cancelButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        self.selectButton.backgroundColor    = UIColor.clearColor()
        self.selectButton.layer.cornerRadius = 5
        self.selectButton.layer.borderWidth  = 1
        self.selectButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        // Print the lunch order object to make sure that it's there
        println("<<<<<<<<<<<<<<<<<<<<<<< LUNCH ORDER OBJECT RECEIVED: \(lunchOrder)")
        
        // Retrieve the desserts from the DB
        self.retrieveDesserts()
        {
            (errorFlag) in
            
            // Remove the overlay
            
        }
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
     * Select Button tapped - Dismiss this modal, create the lunch order, and move to the 
     * Thank you screen
     */
    @IBAction func selectButtonTapped(sender: AnyObject)
    {
        // Validate that the user has selected a dessert
        if let selectedPath = self.selectedCellPath
        {
            // Create the lunch order with the dessert option
            self.lunchOrder?.dessert = self.desserts[selectedPath.item]
            
            self.lunchOrder?.create()
            {
                (errorFlag) in
                
                if errorFlag
                {
                    let alert = UIAlertView()
                    
                    alert.title   = "Network Error"
                    alert.message = "Uh oh! Looks like the Internet isn't working! Try again in a bit!"
                    alert.addButtonWithTitle("Try Again")
                    
                    alert.show()
                }
                else
                {
                    // Dismiss this VC and then call the delegate method to move to the 
                    // Thank You screen
                    self.dismissViewControllerAnimated(true)
                    {
                        self.delegate?.dismissDessertSelection()
                    }
                }
            }
        }
        else
        {
            let alert = UIAlertView()
            
            alert.title   = "No Dessert!?"
            alert.message = "Oops! Looks like you forgot to select a dessert!"
            alert.addButtonWithTitle("I Guess I'll Choose One")
            
            alert.show()
        }
    }
    
    /**
     * Cancel button tapped - Dismiss this modal and return to the previous
     */
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//-------------------------------- COLLECTION VIEW FUNCTIONS -------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
    * Returns number of sections in the collection view
    */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    /**
    * Returns the number of cells to be created in the collection view
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.desserts.count
    }
    
    /**
    * Returns the cell for a given index path
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // Set the cell
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("dessertCell", forIndexPath: indexPath) as! DessertCell
        
        // Change the label to be the name of the menu item
        cell.label.text = self.desserts[indexPath.item].name
            
        // Make sure the item has a URL for the photo, and if so, grab the corresponding image from the
        // pre-populated dictionaries
        if let image: UIImage = self.desserts[indexPath.item].photo
        {
            cell.image.image = image
        }
        
        return cell
    }
    
    /**
     * Cell tapped - Change the color of the background of the cell to a selected color
     * Then save the index of the cell so as to find the dessert later.
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        // First set the previous cell's background back to normal (if there was a previous)
        if let selectedPath = self.selectedCellPath
        {
            collectionView.cellForItemAtIndexPath(selectedPath)?.backgroundColor = UIColor.whiteColor()
        }
        else
        {
            self.selectedCellPath = NSIndexPath()
        }
        
        // Store the index path
        self.selectedCellPath = indexPath
        
        // Change the background color of the cell
        collectionView.cellForItemAtIndexPath(indexPath)?.backgroundColor = selectedTabColor
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//--------------------------------- OTHER USEFUL FUNCTIONS ---------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
    * Make the Alamofire request for the desserts
    */
    func retrieveDesserts(completion: ((Bool) -> Void)?)
    {
        // Attempt to make the GET call via Alamofire
        let endpoint = "http://recruiterconnect.byu.edu/api/desserts/?format=json"
        // let endpoint = "http://localhost:8000/api/desserts/?format=json"
        
        var errorFlag = false
        
        // Make the GET request via AlamoFire
        Alamofire.request(.GET, endpoint).responseJSON
        {
            (request, response, data, error) in
                
            // Reinitialize the array, just in case page is reloaded
            self.desserts = [Dessert]()
            
            // If there's an error, print it
            if let JSONError = error
            {
                println("<<<<<<<<<<<<<<< DESSERT ERROR: \(JSONError)")
                errorFlag = true
            }
                
            // Unwrap the data into a NSArray
            if let json: NSArray = data as? NSArray
            {
                // Create a dessert for each item returned in the array
                for item in json
                {
                    var dessert = Dessert(item: item as! NSDictionary)
                    
                    // Grab the images and then append the dessert to the array
                    dessert.retrieveImages()
                    {
                        (errorFlag) in
                            
                        if errorFlag
                        {
                            let alert = UIAlertView()
                                
                            alert.title   = "Network error"
                            alert.message = "It seems that the network is acting up. Be aware that the dessert images will not appear in the next screen."
                            alert.addButtonWithTitle("OK")
                                
                            alert.show()
                        }
                            
                        self.desserts.append(dessert)
                        self.collection.reloadData()
                    }
                }
            }
            else
            {
                errorFlag = true
            }
                
            completion?(errorFlag)
        }
        
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

}
