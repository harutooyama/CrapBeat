//
//  ViewController.swift
//  Shopintro
//
//  Created by Owner on 2020/06/10.
//  Copyright © 2020 Owner. All rights reserved.
//

import UIKit

import GoogleMaps
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    
    var presentMapLatitude:CLLocationDegrees?
    var presentMapLongitude:CLLocationDegrees?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getMyLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        
        let status = CLLocationManager.authorizationStatus()
        if(status == CLAuthorizationStatus.notDetermined){
            print("didChangeAuthorizationStatus \(status)")
            self.locationManager.requestAlwaysAuthorization()
            
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager:CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus){
        var statusStr = "";
        switch(status){
        case .notDetermined:        statusStr = "NotDetermined"
        case .restricted:           statusStr = "Restricted"
        case .denied:               statusStr = "Denied"
        case .authorized:           statusStr = "Authorized"
        case .authorizedWhenInUse:   statusStr = "AuthorizedWhenInUse"
            
        case .authorizedAlways: break
            
        @unknown default: break
            
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    func locationManager(_ manager:CLLocationManager,didFallWithError error: Error){
        print(error)
    }
    
    func locationManager(_ manager:CLLocationManager,didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        let cordinate = locations[0].coordinate
        print("緯度:\(cordinate.latitude)")
        print("経度\(cordinate.longitude)")
    }


}

