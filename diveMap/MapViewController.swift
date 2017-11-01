//
//  ViewController.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var diveItemsObjects: [DiveMapItems] = []

    var lastCoordinateTouched = CLLocationCoordinate2D()
    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewOutlet.showsUserLocation = true
        mapViewOutlet.delegate = self
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.notifyObservers(notification:)),
                                               name: NSNotification.Name(rawValue: notificationIDs.diveItemID),
                                               object: nil)
        lastCoordinateTouched = CLLocationCoordinate2D.init(latitude: 47.6031537682643, longitude: -122.336164712906)
        setZoomInitialLocation(location: lastCoordinateTouched)
        DiveMapService.sharedInstance.getDiveMapInfo(lat: 47.6031537682643, lng: -122.336164712906, dist: 25)
        
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

  
    @IBAction func LongPressLocation(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        
        let touchLocation = sender.location(in: self.mapViewOutlet)
        let touchedCoordinate = mapViewOutlet.convert(touchLocation, toCoordinateFrom: self.mapViewOutlet)
        
        // create an annotion point
        let droppedPin = MKPointAnnotation()
        droppedPin.title = "Dropped Pin"
        droppedPin.coordinate = touchedCoordinate
        
        // creat pin view change colour
        let droppedPinView = MKAnnotationView.init(annotation: droppedPin, reuseIdentifier: "pin")
        droppedPinView.tintColor = UIColor.cyan
       
        // add the annotation that bleongs to the pin view in the map
        self.mapViewOutlet.addAnnotation(droppedPinView.annotation!)
        
        DiveMapService.sharedInstance.getDiveMapInfo(lat: touchedCoordinate.latitude,
                                                     lng: touchedCoordinate.longitude,
                                                     dist: 25)
        
    }
    
    func setZoomInitialLocation(location: CLLocationCoordinate2D) {
//        let currentLocation = CLLocationCoordinate2D.init(latitude: 47.6031537682643, longitude: -122.336164712906 )
        let regionRadius : CLLocationDistance = 25
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapViewOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func notifyObservers(notification: NSNotification) {
        
        var DiveItemDict = notification.userInfo as! Dictionary<String , [DiveMapItems]>
        diveItemsObjects = DiveItemDict[dictKey.diveItemKey]!
        
        for site in diveItemsObjects {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D.init(latitude: site.lat,
                                                                longitude: site.lng)
            annotation.title = site.name
            self.mapViewOutlet.showAnnotations([annotation], animated: true)
            
        }
        
//        refresh.endRefreshing()
//        self.hideActivityIndicator(loadingView: loadingView, spinner: spinner)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
           // returning nil here if annotation is MKuserlocation blue dot
            return nil
        }
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") {
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView.pinTintColor = UIColor.blue
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            return pinView
        }
    }
    
    
    
}

