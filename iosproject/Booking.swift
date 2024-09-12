/*
 
 author: Kiret
 
 */

import UIKit
import Foundation

// Define a class to represent a booking
class Booking: NSObject {
    
    // Property to store the booked place
    let bookedPlace: String // Name or identifier of the booked place
    
    // Initializer to create a new booking object with the specified booked place
    init(bookedPlace: String) {
        // Initialize the bookedPlace property with the provided value
        self.bookedPlace = bookedPlace
        
        // Call the designated initializer of the superclass (NSObject)
        super.init()
    }
}
