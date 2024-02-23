//
//  GoogleMapsVC.swift
//  Cleansing
//
//  Created by United It Services on 14/09/23.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import Alamofire
//import SwiftyJSON
class GoogleMapsVC: UIViewController, GMSMapViewDelegate {
    var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let startCoordinate = CLLocationCoordinate2D(latitude: 28.5355, longitude: 77.3910)  // Noida
//        let endCoordinate = CLLocationCoordinate2D(latitude: 28.4089, longitude: 77.3178)  // Faridabad
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 1.0, height: UIScreen.main.bounds.height * 1.0))
        let camera = GMSCameraPosition.camera(withLatitude:  28.4089,longitude: 77.3178, zoom: 12.0)
               mapView.camera = camera
               mapView.delegate = self // Set the delegate to self if you want to customize route drawing
        getDirections()
    }
    
    func getDirections() {
        let origin = "San Francisco, CA" // Starting point
        let destination = "Mountain View, CA" // Ending point
        
        let originLatitude = 28.4089 // Delhi's latitude
        let originLongitude = 77.3178 // Delhi's longitude
        
        
        let destinationLatitude = 28.5355 // Delhi's latitude
        let destinationLongitude = 77.3910 // Delhi's longitude

        // Configure your Google Maps Directions API key here
        let apiKey = "AIzaSyCrCGPXfswRFDdMzSdEaGBnZiz9LQNFTCA"

        // Create the URL for the Directions API request
        let directionsURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(originLatitude),\(originLongitude)&destination=\(destinationLatitude),\(destinationLongitude)&key=\(apiKey)"


        // Make an HTTP request to fetch directions
        AF.request(directionsURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any],
                   let routes = json["routes"] as? [[String: Any]] {
                    
                    for route in routes {
                        if let overviewPolyline = route["overview_polyline"] as? [String: Any],
                           let points = overviewPolyline["points"] as? String {
                            
                            let path = GMSPath(fromEncodedPath: points)
                            if let path = path {
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeWidth = 3.0
                                polyline.map = self.mapView
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print("Error fetching directions: \(error)")
            }
        }
    }
    

   

}
