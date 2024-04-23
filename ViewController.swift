//
//  ViewController.swift
//  tray_MapGPS
//
//  Created by Tristan Earl Ray, Jr on 4/18/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var mapSwitch: UISwitch!
    @IBOutlet weak var zoomSlider: UISlider!
    
    let myAnnotation = MKPointAnnotation() // a marker showing your location on the map
    let locationManager = CLLocationManager() //this is important to read GPS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        myMap.mapType = .hybrid
        myMap.isZoomEnabled = true
        myMap.isScrollEnabled = true
        myMap.addAnnotation(myAnnotation)
        let tmpRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.092540, longitude: -95.990437), latitudinalMeters: 500, longitudinalMeters: 500)
        
        myMap.setRegion(tmpRegion, animated: true)
        mapSwitch.setOn(true, animated:true)
        
        zoomSlider.maximumValue = 3.0
        zoomSlider.minimumValue = 0.0
        zoomSlider.setValue(1.05, animated: true)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways, .authorizedWhenInUse:
            //activate GPS
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        default:
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        let myLocation = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        
        myMap.setCenter(myLocation, animated: true)
        myAnnotation.coordinate = myLocation
    }
    
    @IBAction func ChangeMapType(_ sender: Any) {
        if(mapSwitch.isOn) {
            myMap.mapType = .hybrid
        } else {
            myMap.mapType = .standard
        }
    }
    
    
    
    @IBAction func ZoonInOut(_ sender: Any) {
        let miles = Double(self.zoomSlider.value)
        let delta = miles / 69.0
        var currentRegion = myMap.region
        currentRegion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        myMap.region = currentRegion
        
    }
    
}

