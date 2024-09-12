
/*
 
 Author: Rahul Chowdhary
 Brief: created Sign up page here, to create Account with firebase authentication email and password, added full name field and confirm password for security
 used guard to check if all the field are filled, also added to check password mathces with confirm password.
 
 */
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmpasswordTextField: UITextField!

    var myData: signupData = signupData()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting the text of nameTextField to the name stored in myData
        nameTextField.text = myData.name

        // Setting the text of emailTextField to the email stored in myData
        emailTextField.text = myData.email

        // Setting the text of passwordTextField to the password stored in myData
        passwordTextField.text = myData.password

        // Setting the text of confirmpasswordTextField to the confirm password stored in myData
        confirmpasswordTextField.text = myData.confirmPassword
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signupClicked(_ sender: UIButton) {
            guard let name = nameTextField.text else { return }
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            guard let confirmPassword = confirmpasswordTextField.text else { return }
            
            guard password == confirmPassword else {
                   showAlert(title: "Error", message: "Passwords do not match.")
                   return
            }
            
            myData.name = name
            myData.email = email
            myData.password = password
            myData.confirmPassword = confirmPassword
            
            Auth.auth().createUser(withEmail: email, password: password) { firebaseResult, error in
                if let e = error {
                    self.showAlert(title: "Error", message: e.localizedDescription)
                } else {
                    // Store user's name in Firebase
                    let user = Auth.auth().currentUser
                    let changeRequest = user?.createProfileChangeRequest()
                    changeRequest?.displayName = name
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print("Error updating display name: \(error.localizedDescription)")
                        } else {
                            print("Display name updated successfully")
                        }
                    }
                    
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            }
        }
        
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
 

}
