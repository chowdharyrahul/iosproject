/*
 
Author: Kiret Oberoi
Brief: created logic using firebase firestore collection to show number of hotels available in city entered in Search hotel page
 used array to store retreived hotels
 
 used table view, table cell, upon did select row at alert is shown showing hotel details coming from firestore collection., used HotelTableViewCell
 
 
 */

import UIKit
import Firebase

// Class to display hotels in a specified destination
class HotelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Array to store retrieved hotels
    var hotels: [Hotel] = []
    
    // Outlet for table view to display hotels
    @IBOutlet var tableView: UITableView!
    
    // Destination for hotel search
    var destination: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform hotel search for the specified destination
        searchForHotels(destination: destination)
    }
    
    // MARK: - Hotel Search
    
    // Method to search for hotels in the specified destination
    func searchForHotels(destination: String) {
        let db = Firestore.firestore()
        db.collection("hotels")
            .whereField("location", isEqualTo: destination)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting hotels: \(error)")
                } else {
                    if let documents = querySnapshot?.documents {
                        self.hotels = documents.compactMap { document in
                            let data = document.data()
                            let name = data["hotel"] as? String ?? ""
                            let location = data["location"] as? String ?? ""
                            let price = data["price"] as? Double ?? 0.0
                            let rooms = data["rooms"] as? Int ?? 0
                            
                            return Hotel(name: name, location: location, price: price, rooms: rooms)
                        }
                        // Reload table view with retrieved hotels
                        self.tableView.reloadData()
                    }
                }
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotels.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 // Adjust the height as needed
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : HotelTableViewCell = tableView.dequeueReusableCell(withIdentifier: "hotelCell") as? HotelTableViewCell ?? HotelTableViewCell(style: .default, reuseIdentifier: "hotelCell")
        
        let hotel = hotels[indexPath.row]
        cell.nameLabel.text = hotel.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedHotel = hotels[indexPath.row]
        
        // Show details in an alert
        let alertController = UIAlertController(title: selectedHotel.name, message: "Location: \(selectedHotel.location)\nRooms Available: \(selectedHotel.rooms)\nPrice per night: \(selectedHotel.price)", preferredStyle: .alert)
        
        // Add "OK" action
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Add "Book" action
        alertController.addAction(UIAlertAction(title: "Book", style: .default, handler: { action in
            self.navigateToPaymentViewController(selectedHotelName: selectedHotel.name)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Navigate to PaymentViewController
    func navigateToPaymentViewController(selectedHotelName: String) {
        if let paymentViewController = storyboard?.instantiateViewController(withIdentifier: "paymentViewController") as? PaymentViewController {
            // Set the selected hotel name
            paymentViewController.selectedHotelName = selectedHotelName
            
            // Present the PaymentViewController modally
            paymentViewController.modalPresentationStyle = .fullScreen
            present(paymentViewController, animated: true, completion: nil)
        }
    }
}
