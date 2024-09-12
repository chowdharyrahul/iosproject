/*
 
 Author: Abhi Sharma
 Brief:This code manages payment details and confirmation. It sets up UI elements for card information, validates user input, and confirms payment via Firebase. Upon confirmation, it saves the booking in Firestore and displays a success message
 
 Also, added alerts that navigates to bookings page upon successful payment and pass the hotel name for which payment is completed
 
 */

import UIKit
import Firebase

// Class to handle payment details and confirmation
class PaymentViewController: UIViewController, UITextFieldDelegate {
    // Property to store the selected hotel name
    var selectedHotelName: String?
    
    // Outlets for UI elements
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var expiryDateTextField: UITextField!
    @IBOutlet var cvvTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    
    // Instance of PaymentDetails class to store payment information
    var myData: PaymentDetails = PaymentDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable confirm button initially
        confirmButton.isEnabled = false
        
        // Add target for text field editing changes to check if confirm button should be enabled
        cardNumberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        expiryDateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cvvTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Set keyboard type for text fields
                cardNumberTextField.keyboardType = .numberPad
                expiryDateTextField.keyboardType = .numberPad
                cvvTextField.keyboardType = .numberPad
                
                // Set delegate to self for text fields
                cardNumberTextField.delegate = self
                expiryDateTextField.delegate = self
                cvvTextField.delegate = self
        
        
        cardNumberTextField.text = myData.cardNumber
        expiryDateTextField.text = myData.expiryDate
        cvvTextField.text = myData.cvv
        
        
    }
    // UITextFieldDelegate method to capture text field changes
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField == cardNumberTextField {
                myData.cardNumber = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            } else if textField == expiryDateTextField {
                myData.expiryDate = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            } else if textField == cvvTextField {
                myData.cvv = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            }
            return true
        }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        // Check if all text fields have text, enable confirm button if true
        let cardNumberFilled = !(cardNumberTextField.text?.isEmpty ?? true)
        let expiryDateFilled = !(expiryDateTextField.text?.isEmpty ?? true)
        let cvvFilled = !(cvvTextField.text?.isEmpty ?? true)
        confirmButton.isEnabled = cardNumberFilled && expiryDateFilled && cvvFilled
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        // Show an alert upon confirmation
        let alertController = UIAlertController(title: "Confirm Payment", message: "Are you sure you want to proceed with the payment?", preferredStyle: .alert)
        
        
        // Add "No" action
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        // Add "Yes" action
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if let hotelName = self.selectedHotelName,
               let currentUser = Auth.auth().currentUser {
                let userId = currentUser.uid
                let db = Firestore.firestore()
                
                // Save the booked place under the user's UID
                let bookingRef = db.collection("bookings").document(userId)
                bookingRef.setData(["bookedPlace": hotelName]) { error in
                    if let error = error {
                        print("Error saving booked place: \(error.localizedDescription)")
                    } else {
                        print("Booked place saved successfully for user: \(userId)")
                        // Show booking successful alert
                        self.showBookingSuccessfulAlert(with: hotelName)
                    }
                }
            } else {
                // Handle the case where selectedHotelName is nil or user is not authenticated
                print("Error: selectedHotelName is nil or user is not authenticated")
            }
        }))
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }

    
    func showBookingSuccessfulAlert(with hotelName : String) {
        // Show a booking successful message
        let alertController = UIAlertController(title: "Booking Successful", message: "Your payment has been processed successfully.", preferredStyle: .alert)
        
        // Add "Go to bookings page" action
        alertController.addAction(UIAlertAction(title: "Go to Bookings Page", style: .default, handler: { _ in
            // Navigate to BookingViewController
            self.navigateToBookingViewController(hotelName: hotelName)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func navigateToBookingViewController(hotelName: String) {
        // Assuming you have a Firestore collection called "hotels"
        let db = Firestore.firestore()
        db.collection("hotels")
            .whereField("hotel", isEqualTo: hotelName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching hotel: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No hotel found with the name \(hotelName)")
                    return
                }
                
                if let document = documents.first {
                    // Retrieve the hotel name from Firestore document
                    let hotelName = document.get("hotel") as? String ?? "Unknown Hotel"
                    
                    if let bookingViewController = self.storyboard?.instantiateViewController(withIdentifier: "BookingViewController") as? BookingViewController {
                        // Pass the retrieved hotel name to BookingViewController
                        bookingViewController.selectedHotelName = hotelName
                        bookingViewController.modalPresentationStyle = .fullScreen
                        self.present(bookingViewController, animated: true, completion: nil)
                    }
                } else {
                    print("No hotel found with the name \(hotelName)")
                }
        }
    }
}
