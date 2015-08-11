//
//  LunchDetailsViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/15/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Controller for the details page for Lunch Options that a User selects.

import UIKit

class LunchDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Menu item to be passed in from the previous screen
    var menuItem : MenuItem?
    
    // Lunch Order Variable
    let lunchOrder = LunchOrder()
    
    // Array of desserts to be passed from the previous view
    var desserts : [Dessert]?
    
    // Outlets for the Menu Item info
    @IBOutlet weak var menuItemName  : UILabel!
    @IBOutlet weak var menuItemImage : UIImageView!
    
    // Views that act as UI element containers
    @IBOutlet weak var ingredientsContainer : UIView!
    @IBOutlet weak var collection           : UICollectionView!
    
    // Constants for the correct font and text color to be used
    let smallFont        = UIFont(name: "HelveticaNeue-Thin", size: 20.0)
    let largerFont       = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
    let textColor        = UIColor(red: 78/255, green: 108/255, blue: 163/255, alpha: 1)
    let selectedTabColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 1.0)
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Change the title of the page based on the MenuItem passed in
        menuItemName.text = menuItem?.name
        
        // Assign the menu item image to the UIImageView
        menuItemImage.image = menuItem?.photo
        
        // Set the background of the collectionView
        self.collection.backgroundColor = self.selectedTabColor
        
        // Create the Switches and labels for the dessert view
        if let ingredientsArray = menuItem?.ingredients
        {
            // Variables for the x and y for the labels
            var labelXCol1  : CGFloat = 50
            var labelXCol2  : CGFloat = 250
            var labelY      : CGFloat = 10
            var labelWidth  : CGFloat = 150
            
            // Variables for the x and y for the UISwitches
            var switchXCol1 : CGFloat = 10
            var switchXCol2 : CGFloat = 200
            var switchY     : CGFloat = 10
            
            // Counter to change the x value based on the column
            var counter = 1
            
            for ingredient in ingredientsArray
            {
                // Create the switch
                let ingredientSwitch = UISwitch()
                ingredientSwitch.on  = true
                
                // Create the Label
                let ingredientName       = UILabel()
                ingredientName.text      = ingredient.name
                ingredientName.font      = self.smallFont
                ingredientName.textColor = self.textColor
                
                ingredientName.sizeToFit()
                
                ingredientName.numberOfLines = 3
                ingredientName.lineBreakMode = NSLineBreakMode.ByWordWrapping
                
                // Set the size and location based on the counter
                if counter % 2 == 0
                {
                    ingredientSwitch.frame = CGRectMake(switchXCol2, switchY, 0, 0)
                    ingredientName.frame   = CGRectMake(labelXCol2, labelY, labelWidth, ingredientName.frame.height)
                    labelY                 += 100
                    switchY                += 100
                }
                else
                {
                    ingredientSwitch.frame = CGRectMake(switchXCol1, switchY, 0, 0)
                    ingredientName.frame   = CGRectMake(labelXCol1, labelY, labelWidth, ingredientName.frame.height)
                }
                
                // Set the label
                self.ingredientsContainer.addSubview(ingredientName)
                self.ingredientsContainer.addSubview(ingredientSwitch)
                
                // Increment the y values and the counter
                counter += 1
            }
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
        if let dessertsArray = self.desserts
        {
            return dessertsArray.count
        }
        else
        {
            return 0
        }
    }
    
    /**
    * Returns the cell for a given index path
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // Set the cell
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("dessertCell", forIndexPath: indexPath) as! DessertCell
        if let dessertsArray = self.desserts
        {
            // Change the label to be the name of the menu item
            cell.label.text = dessertsArray[indexPath.item].name
            
            // Make sure the item has a URL for the photo, and if so, grab the corresponding image from the
            // pre-populated dictionaries
            if let image: UIImage = dessertsArray[indexPath.item].photo
            {
                cell.image.image = image
            }
        }
        
        return cell
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
}
