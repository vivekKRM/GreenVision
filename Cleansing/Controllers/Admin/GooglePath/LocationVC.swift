//
//  LocationVC.swift
//  Cleansing
//
//  Created by UIS on 06/11/23.
//

import UIKit
import CoreLocation
import GooglePlaces
class LocationVC: UIViewController {
    
    @IBOutlet weak var searchView: UIView!
    var resultsViewController: GMSAutocompleteResultsViewController!
    var searchController: UISearchController!
//    var locationManager: CLLocationManager?
//    var userInfo = UserInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager = CLLocationManager()
//        locationManager?.delegate = self
//        locationManager?.requestAlwaysAuthorization()
        GMSPlacesClient.provideAPIKey("AIzaSyBS5nIuVZFyJHD18sgBgk25roDshPpVci0")
        title = ""
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        //        filter.country = "IN"
        resultsViewController.autocompleteFilter = filter
        //specify the place data types to return
        let fields: GMSPlaceField = [.name,.placeID,.all]
        resultsViewController.placeFields = fields
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchResultsUpdater = resultsViewController
        searchController.searchBar.sizeToFit()
        searchView.addSubview(searchController.searchBar)
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
}
extension LocationVC: GMSAutocompleteResultsViewControllerDelegate//, CLLocationManagerDelegate
{
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController.isActive = false
        //Do something with the selected place
        print("place name: \(place.name ?? "none")")
        print("place address: \(place.formattedAddress ?? "none")")
        print("place attributions: \(place.attributions?.string ?? "none")")
        print("latitude is ",place.coordinate.latitude)
        print("longitude is ",place.coordinate.longitude)
        if let name =  place.name{
            let lat = place.coordinate.latitude
            let long = place.coordinate.longitude
            let b: String = String(format: "%f", lat)
            let c: String = String(format: "%f", long)
            UserDefaults.standard.removeObject(forKey: "Map")
            let userLocation: NSDictionary = ["lat": b, "long": c]
            UserDefaults.standard.setValue(userLocation, forKey: "Map")
            UserDefaults.standard.removeObject(forKey: "PlaceName")
            searchController.searchBar.searchTextField.text = name
            print(name)
            UserDefaults.standard.setValue(name, forKey: "PlaceName")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "disconnectPaxiSocketss"), object: nil)
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ",error.localizedDescription)
    }
}
