
/*
 
 Author: Dakshil
 
 */


import UIKit
import Foundation

// Define a class to represent a hotel
class Hotel: NSObject {
    
    // Properties of the hotel
    let name: String // Name of the hotel
    let location: String // Location of the hotel
    let price: Double // Price per night of the hotel
    let rooms: Int // Number of rooms available in the hotel
   
    // Initializer to create a new hotel object
    init(name: String, location: String, price: Double, rooms: Int) {
        // Initialize properties with provided values
        self.name = name
        self.location = location
        self.price = price
        self.rooms = rooms
       
        // Call the designated initializer of the superclass (NSObject)
        super.init()
    }
}
