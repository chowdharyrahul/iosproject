
/*
 
 Author: Abhi
 
 */
import UIKit
import Foundation

// Define a class to represent user profile details
class ProfileDetails: NSObject {
    
    // Properties to store user information
    var userEmail: String // User's email address
    var displayName: String // User's display name
    
    // Initializer to create a new profile details object
    init(userEmail: String, displayName: String) {
        // Initialize properties with provided values
        self.userEmail = userEmail
        self.displayName = displayName
    }
    
    // Override the description property to provide a custom string representation of the object
    override var description: String {
        // Return a string containing user email and display name
        return "User Email: \(userEmail), Display Name: \(displayName)"
    }
}

