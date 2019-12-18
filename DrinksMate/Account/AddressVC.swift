//
//  AddressVC.swift
//  DrinksMate
//
//  Created by LeemingJin on 11/11/19.
//  Copyright © 2019 LeemingJin. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

class AddressVC: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, GMSAutocompleteViewControllerDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 12.0


    var isOther : Bool!
    var selectedAddress : GMSAddress!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var buildingTxt: UITextField!
    @IBOutlet weak var landmarkTxt: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.isHidden = !self.isOther
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
    }
    
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      print("Location: \(location)")

        self.mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        marker.map = self.mapView
        
        self.mapView.animate(to: self.mapView.camera)
        
        if (!self.isOther) {
            self.getNearBy(location: location)
        }
        
    }

    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
          case .restricted:
            print("Location access was restricted.")
          case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
          case .notDetermined:
            print("Location status not determined.")
          case .authorizedAlways: fallthrough
          case .authorizedWhenInUse:
            print("Location status is OK.")
          default:
            break
            }
    }

    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func getNearBy(location : CLLocation) {
        
        let geocoder = GMSGeocoder()
//        let location = CLLocation(latitude: 40.712899, longitude: -73.962759)
        geocoder.reverseGeocodeCoordinate(location.coordinate) { (response, error) in
            if (error != nil) {
                return
            }
            
            let value = response?.results()
            
            let addresses = UIAlertController(title: "Select Delivery Address", message: nil, preferredStyle: .alert)
            
            for address in value! {
                let addressString = address.lines![0]
        
                let addressAction = UIAlertAction(title: addressString, style: .default) { (action) in
                    self.selectedAddress = address
                    self.addressLbl.text = addressString
                }
                
                addresses.addAction(addressAction)
                if (addresses.actions.count == 3) {
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                        
                    }
                    addresses.addAction(cancelAction)
                    
                    self.present(addresses, animated: true, completion: nil)
                    return
                }
            }
        }
    }

    @IBAction func saveLocationAction(_ sender: Any) {
        var address = self.addressLbl.text!
        
        if (self.buildingTxt.text!.count > 0) {
            address = self.buildingTxt.text! + " ," + address
        }
        
        if (self.landmarkTxt.text!.count > 0) {
            address = self.landmarkTxt.text! + " ," + address
        }
        
        let headers = AppUtil.user.getAuthentification()
        
        let url = URL(string: AppUtil.serverURL + "checkout/saveaddress")
        
        var params = [:] as [String : Any]
        
        if (self.selectedAddress != nil) {
            params = ["address": address, "addressCity":self.selectedAddress.subLocality!, "addressPin":self.selectedAddress.postalCode!, "addressState":self.selectedAddress.administrativeArea!, "latitude": self.selectedAddress.coordinate.latitude, "longitude":self.selectedAddress.coordinate.longitude]
        }
        else {
            params = ["address": address, "addressCity":"", "addressPin":"", "addressState":"", "latitude": 0.0, "longitude":0.0]
        }
        

        Alamofire.request(url!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { response in

            guard response.result.isSuccess else {

                return
            }
            
            AppUtil.isAddressSelected = true
            self.dismiss(animated: false, completion: nil)
        }
 
        
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // Other location
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "NZ"
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.clear()
        
        self.mapView.camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude,
                                            longitude: place.coordinate.longitude,
                                            zoom: zoomLevel)
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        marker.map = self.mapView
        
        self.mapView.animate(to: self.mapView.camera)
        dismiss(animated: true, completion: nil)
        
        placesClient.lookUpPlaceID(place.placeID!) { (place, error) in
            
            GMSGeocoder().reverseGeocodeCoordinate((place?.coordinate)!) { (response, error) in
                if (error != nil) {
                    return
                }
                
                let value = response?.results()
                self.selectedAddress = value![0]
            }
        }

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didSelect prediction: GMSAutocompletePrediction) -> Bool {
        
        self.addressLbl.text = prediction.attributedFullText.string
        
        
        return true
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
