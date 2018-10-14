//
//  ViewController.swift
//  LocationService
//
//  Created by Bethany Huang on 9/27/18.
//  Copyright © 2018 Liuxuan Huang. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var previousPoint:CLLocation?
    private var totalMovementDistance:CLLocationDistance = 0
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var latitudeLabel:UILabel!
    @IBOutlet var longitudeLabel:UILabel!
    @IBOutlet var horizontalAccuracy:UILabel!
    @IBOutlet var altitudeLabel:UILabel!
    @IBOutlet var verticalAccuracy:UILabel!
    @IBOutlet var distanceTraveledLabel:UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self // refer to the controller class
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // don't need requestAlwaysAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        default:
            locationManager.stopUpdatingLocation()
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let errorType = error._code == CLError.denied.rawValue ? "Access Denied": "Error \(error._code)"
        let alertController = UIAlertController(title: "Location Manager Error", message: errorType, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {action in})
        alertController.addAction(okAction)
        present(alertController, animated:true, completion: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = (locations as [CLLocation]) [locations.count - 1]
        
        let latitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.latitude)
        latitudeLabel.text = latitudeString;
        
        let longitudeString = String(format: "%g\u{00B0}", newLocation.coordinate.longitude)
        longitudeLabel.text = longitudeString;
        
        let horizontalAccuracyString = String(format: "%gm", newLocation.horizontalAccuracy)
        horizontalAccuracy.text = horizontalAccuracyString;
        
        let altitudeString = String(format: "%gm", newLocation.altitude)
        altitudeLabel.text = altitudeString;
        
        let verticalAccuracyString = String(format: "%gm", newLocation.verticalAccuracy)
        verticalAccuracy.text = verticalAccuracyString;
        
        if newLocation.horizontalAccuracy < 0 {return} // invalid accuracy
        // accuracy radius is too large, it's not accurate enough. We can't use it
        if newLocation.horizontalAccuracy > 100 || newLocation.verticalAccuracy > 50 {return}
        if previousPoint == nil {
            totalMovementDistance = 0
            let start = Place(title: "Start Point", subtitle: "This is where we started", coordinate: newLocation.coordinate)
            mapView.addAnnotation(start)
            let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
            mapView.setRegion(region, animated: true)
        }else{
            print("movement distance: \(newLocation.distance(from: previousPoint!))")
            totalMovementDistance += newLocation.distance(from: previousPoint!)
        }
        previousPoint = newLocation
        let distanceString = String(format: "%gm", totalMovementDistance)
        distanceTraveledLabel.text = distanceString
    }
}

