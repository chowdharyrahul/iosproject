/*
 
 author: Kiret Oberoi
 brief: used firestore collection bookings to save bookedPlaces code based on the user uid from authentication in firebase, so that if user logs out and log in again, their reservation show under their id.
 used table view to show names of hotel in table cell
 After payment booked places are displayed on this page.
 
 */

import UIKit
import Firebase
import FirebaseAuth

class BookingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var user: User?
    var selectedHotelName: String?// THIS IS FROM WHERE VALUE IS COOMING FOR HOTEL NAME
    //@IBOutlet var hotelNameLabel: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var tableView : UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check if user is authenticated
        
        
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        loadBookedPlace()
        
    }
    
    func loadBookedPlace() {
        // Check if user is logged in
        if let currentUser = Auth.auth().currentUser {
            user = currentUser
            
            // Print the current user's UID
            print("Current User UID: \(currentUser.uid)")
            
            // Retrieve booked place for the user from Firestore
            let db = Firestore.firestore()
            let userId = currentUser.uid
            
            db.collection("bookings").document(userId).getDocument { (document, error) in
                if let error = error {
                    print("Error fetching booked place: \(error.localizedDescription)")
                    return
                }
                
                if let document = document, document.exists {
                    // Document exists, retrieve booked place information
                    if let bookedPlace = document.data()?["bookedPlace"] as? String {
                        self.selectedHotelName = bookedPlace
                        self.tableView.reloadData()
                    } else {
                        print("No booked place found for the user")
                    }
                } else {
                    print("No booked place document found for the user")
                }
            }
        } else {
            // User is not logged in
            print("User is not logged in")
        }
    }




  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // Return the number of rows you want to display, for example, 1
        return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "bookingCell", for: indexPath)
            
            // Configure the cell
            cell.textLabel?.text = selectedHotelName
            
            return cell
        }
    

    
}

extension BookingViewController : UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name
        switch item.tag {
        case 0:
            let bookingViewController = BookingViewController()
            bookingViewController.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen
            present(bookingViewController, animated: true, completion: nil)
            print("Tab bar Item \(item.tag) selected")
        case 1:
            // Present SignUpViewController itself
            if let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
                signUpViewController.modalPresentationStyle = .fullScreen
                present(signUpViewController, animated: true, completion: nil)
            }
            print("Tab bar Item \(item.tag) selected")
        case 2:
            if let profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController {
                
                profileViewController.modalPresentationStyle = .fullScreen // Set modal presentation style to full screen
                present(profileViewController, animated: true, completion: nil)
            }
            print("Tab bar Item \(item.tag) selected")
        default:
            break
        }
    }

}
