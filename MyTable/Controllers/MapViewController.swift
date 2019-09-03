//
//  MapViewController.swift
//  MyTable
//
//  Created by Hristijan Anastasovski on 9/2/19.
//  Copyright © 2019 Hristijan Anastasovski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var restaurant: RestaurantUser!
    
    var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawLocation()
        // Do any additional setup after loading the view.
    }
    
    func drawLocation(){
       
        geocoder.geocodeAddressString("11th October St. 54, Skopje 1000") {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark?.location?.coordinate.latitude
            let lng = placemark?.location?.coordinate.longitude
            print("Lat: \(String(describing: lat)), Lng: \(String(describing: lng))")
            self.mapView.removeAnnotations(self.mapView.annotations)
            let restaurantLocation = MKPointAnnotation()
            restaurantLocation.title = self.restaurant.restaurantName
            restaurantLocation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
            self.mapView.addAnnotation(restaurantLocation)
            self.zoomToLatestLocation(with: CLLocationCoordinate2D(latitude: lat!, longitude: lng!))
            
        }
        
        
    }
    
    func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setRegion(region, animated: true)
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
