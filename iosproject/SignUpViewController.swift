/*
 
 Author: Dakshil
 Brief: added logic to use tabs on storeyboard, added mapkit to show maps when searching for city to check hotels in that city
 upon clicking search, it takes value from the firebase firestore collection, which I have hard coded for two cities Ottawa and Toronto
 and mentioned 5 hotels for both cities in firestore collection
 
 */

import UIKit
import Firebase
import MapKit
import CoreLocation

class SignUpViewController: UIViewController, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let initialLocation = CLLocation(latitude: -24.641, longitude: 25.878)
    
    
    // Outlet for displaying the map
    @IBOutlet var myMapView: MKMapView!
    
    // Outlet for the tab bar
    @IBOutlet var tabBar: UITabBar!
    
    // Outlet for text field to input destination
    @IBOutlet var destinationTextField: UITextField!
    
    // Outlet for date picker to select date
    @IBOutlet var datePicker: UIDatePicker!
    
    // Outlet for text field to input number of adults
    @IBOutlet var adultsNumberTextField: UITextField!
    
    let regionRadius : CLLocationDistance = 8000
    
    func centreMapOnLocation(location : CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0 )
        
        myMapView.setRegion(coordinateRegion, animated: true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[1] // Set the default selected tab bar item to the one at index 1
        
        centreMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Starting at Sheridan College"
        myMapView.addAnnotation(dropPin)
        myMapView.selectAnnotation(dropPin, animated: true)
        
        
    }
    
    
    
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        guard let destination = destinationTextField.text, !destination.isEmpty else {
            // Destination field is empty, show an error message or handle the case
            return
        }
        
        // Perform Firestore query based on the destination
        //searchForHotels(destination: destination)
        if let hotelViewController = storyboard?.instantiateViewController(withIdentifier: "HotelViewController") as? HotelViewController {
               hotelViewController.modalPresentationStyle = .fullScreen
               hotelViewController.destination = destination // Pass the entered destination
               present(hotelViewController, animated: true, completion: nil)
           }
        
    }
    
    
    @IBAction func findNewLocation(sender: UIButton) {
        let locEnteredText = destinationTextField.text
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(locEnteredText!, completionHandler: { (placemarks,error) -> Void in
            if error != nil {
                print(error)
            }
            if let placemark = placemarks?.first {
                let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)

                self.centreMapOnLocation(location: newLocation)
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = coordinates
                dropPin.title = placemark.name
                self.myMapView.removeAnnotations(self.myMapView.annotations) // Remove previous annotations
                self.myMapView.addAnnotation(dropPin)
                self.myMapView.selectAnnotation(dropPin, animated: true)
            }
        })
    }

  
    func searchForHotels(destination: String) {
        if destination.lowercased() == "canada" {
            let db = Firestore.firestore()
            db.collection("hotels")
                .whereField("location", isEqualTo: destination)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting hotels: \(error)")
                    } else {
                        if let documents = querySnapshot?.documents {
                            for document in documents {
                                let data = document.data()
                                let name = data["hotel"] as? String ?? ""
                                let location = data["location"] as? String ?? ""
                                let price = data["price"] as? Double ?? 0.0
                                let rooms = data["rooms"] as? Int ?? 0
                                let adults = data["adults"] as? Int ?? 0
                                print("Hotel Name: \(name), Location: \(location), Price: \(price), Rooms: \(rooms), Adults Number: \(adults)")
                            }
                        }
                    }
                }
        } else {
            print("No hotels found for the entered destination.")
        }
    }
}
extension SignUpViewController: UITabBarDelegate {
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
            let signUpViewController = SignUpViewController()
            signUpViewController.modalPresentationStyle = .fullScreen
            present(signUpViewController, animated: true, completion: nil)
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
