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


class ViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITableViewDataSource,UITableViewDelegate{
    
    
    


    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager: CLLocationManager!
    var presentMapLatitude:CLLocationDegrees?
    var presentMapLongitude:CLLocationDegrees?
    
    var data = [Shop]()
    let db = SQLiteDB.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMyLocation()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
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
        case .authorizedWhenInUse:  statusStr = "AuthorizedWhenInUse"
            
        case .authorizedAlways: break
            
        @unknown default: break
            
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    func moveCameraPosition(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        let camera = GMSCameraPosition.camera(
            withLatitude: latitude,
            longitude:    longitude,
            zoom:         17
        )
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        mapView.camera = camera
        
        dbUpdateFromLocationAndMarkerSet(latitude: latitude,longitude: longitude)
    }
    func dbUpdateFromLocationAndMarkerSet(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
        data = Shop().allRows(
            order: "ABS(latitude - \(latitude)) + ABS(longitude - \(longitude)) ASC",
            wheresql:"",
            limit:"100"
        )
        tableView.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for:  indexPath)
        
        let shop = data[indexPath.row]
        cell.textLabel!.text = shop.name
        return cell
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

