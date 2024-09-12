/*
 
 Author : Abhi Sharma
 Brief: Created a profile page, this page hold value of user who logged in with the specific email and display full name which was inputted in sign up page
 
 using firebase authentication to check for current user, to retrieve email entered
 added tab bar logic, and also upon clicking sign out, current user who logged with password and email credential is logged out from the session.
 
 */

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var profileDetails: ProfileDetails? // Declare a variable to store profile details
    
    // Outlet for displaying the user's email
       @IBOutlet var emailLabel: UILabel!
       
       // Outlet for displaying the user's display name
       @IBOutlet var displayNameLabel: UILabel!
       
       // Outlet for the sign out button
       @IBOutlet var signoutButton: UIButton!
       
       // Outlet for the tab bar
       @IBOutlet var tabBar: UITabBar!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[2]
        // Fetch user's email and display name from Firebase Authentication
        if let currentUser = Auth.auth().currentUser {
            let userEmail = currentUser.email ?? "No Email"
            let displayName = currentUser.displayName ?? "No Display Name"
            profileDetails = ProfileDetails(userEmail: userEmail, displayName: displayName) // Assign a new instance of ProfileDetails
            
            // Update UI with profile details
            updateUI()
        }
    }
    
    // Function to update UI with profile details
    func updateUI() {
        emailLabel.text = profileDetails?.userEmail
        displayNameLabel.text = profileDetails?.displayName
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        // Perform sign out
        
        // After signing out, navigate back to the login or sign-up screen
        if let ViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            ViewController.modalPresentationStyle = .fullScreen
            present(ViewController, animated: true, completion: nil)
        }
    }
}


extension ProfileViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        switch item.tag {
        case 0:
            if let bookingViewController = storyboard.instantiateViewController(withIdentifier: "BookingViewController") as? BookingViewController {
                bookingViewController.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen
                present(bookingViewController, animated: true, completion: nil)
            }
            print("Tab bar Item \(item.tag) selected")
        case 1:
            // Present SignUpViewController itself
            if let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
                signUpViewController.modalPresentationStyle = .fullScreen
                present(signUpViewController, animated: true, completion: nil)
            }
            print("Tab bar Item \(item.tag) selected")
        case 2:
            let profileViewController = ProfileViewController()
            profileViewController.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen
            present(profileViewController, animated: true, completion: nil)
            print("Tab bar Item \(item.tag) selected")
        default:
            break
        }
    }
}
