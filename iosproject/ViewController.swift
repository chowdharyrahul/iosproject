/*
 
 Author: Rahul Chowdhary
 Brief: created login page, connected firebase dependency for authentication 
 whenever user types email and password it checks if formatting is wrong and give alert, if login email and password matches with the data in firebase authentication, then it takes to home page 
 
 */


import UIKit
import Firebase

// View controller for handling user login
class ViewController: UIViewController {
    
    // Outlets for email and password text fields
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // Action method to unwind to home view controller
    @IBAction func unwindToHome(sender: UIStoryboardSegue){}
    
    // Instance of loginData class to store user login data
    var myData: loginData = loginData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set text fields with data from myData
        emailTextField.text = myData.email
        passwordTextField.text = myData.password
    }
    
    // Action method triggered when login button is clicked
    @IBAction func loginClicked(_ sender: UIButton){
        // Get email and password from text fields
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        // Update myData with entered email and password
        myData.email = email
        myData.password = password
        
        // Attempt to sign in user with Firebase authentication
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                // Show alert if there's an error during sign in
                self.showAlert(title: "Error", message: e.localizedDescription)
            } else {
                // Perform segue to next screen if sign in is successful
                self.performSegue(withIdentifier: "goToNext", sender: self)
            }
        }
    }
    
    // Function to show alert with provided title and message
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
