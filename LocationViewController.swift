//
//  LocationViewController.swift
//  sprint2
//
//  Created by Capgemini-DA164 on 9/25/22.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var userMap: MKMapView!
    var manageLocation: CLLocationManager!
    var currentLocationStr: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User Location"
getUserLocation()
        // Do any additional setup after loading the view.
    }
    
// Function to fetch user location
    func getUserLocation() {
        //creating a location manager to get user location
        manageLocation = CLLocationManager()
        manageLocation.delegate = self
        //To show how presizely we need the accuracy of map
        manageLocation.desiredAccuracy = kCLLocationAccuracyBest
        //Request for autherization
        manageLocation.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //Start fetching the location
            manageLocation.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocatio: CLLocation = locations[0] as CLLocation
        //Setting user current location in mapView
        let centerposition = CLLocationCoordinate2D(latitude: userLocatio.coordinate.latitude, longitude: userLocatio.coordinate.longitude)
        //creating a region for location and giving the span of the coordinate
        let nearRegion = MKCoordinateRegion(center: centerposition, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //creating a point Annotation at user location
        let  mkAnnotation : MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(userLocatio.coordinate.latitude, userLocatio.coordinate.longitude)
        
        getAddress { (address) in
            mkAnnotation.title = address
        }
       //Adding annotation to mapView
        userMap.setRegion(nearRegion, animated: true)
        userMap.addAnnotation(mkAnnotation)
        
        func getAddress(handler: @escaping (String) -> Void ) {
            
            let  geocoder = CLGeocoder()
            let locations = CLLocation(latitude: userLocatio.coordinate.latitude, longitude: userLocatio.coordinate.longitude)
            //Geocoding request for the specified location
            geocoder.reverseGeocodeLocation(locations, completionHandler: { (placemarks, error) -> Void in
                //to give description of geographical coordinate
                var  placemark: CLPlacemark?
                
                placemark = placemarks?[0]
                
     /* To get the address of street, locality, city,pincode, country*/
                let address = "\(placemark?.subThoroughfare ?? ""),\(placemark?.thoroughfare ?? ""),\(placemark?.locality ?? ""),\(placemark?.subLocality ?? ""),\(placemark?.administrativeArea ?? ""),\(placemark?.postalCode ?? ""),\(placemark?.country ?? "")"
                
                
                
            handler(address)
        })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

}
