//
//  ViewController.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UIKit

protocol MapSearch {
    func showDiveSiteSelected(diveSite: DiveMapItems)
}


class MapViewController: UIViewController, MKMapViewDelegate, MapSearch {
    
    func showDiveSiteSelected(diveSite: DiveMapItems) {
        var coord = CLLocationCoordinate2D.init(latitude: diveSite.lat,
                                                longitude: diveSite.lng)
        self.setZoomInitialLocation(location: coord)
    }

    var diveItemsObjects: [DiveMapItems] = []
    var selectedDetailItem: DetailDiveSite?
    var locationManager = CLLocationManager()
    let droppedPin = MKPointAnnotation()
    var searchController: UISearchController!
    var spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var loadingView: UIView = UIView()
    
    var lastCoordinateTouched = CLLocationCoordinate2D()
    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewOutlet.showsUserLocation = true
        mapViewOutlet.delegate = self
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        setUPSearchBar()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.notifyObservers(notification:)),
                                               name: NSNotification.Name(rawValue: notificationIDs.diveItemID),
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MapViewController.notifyDetailObservers(notification:)),
                                               name: NSNotification.Name(rawValue: notificationIDs.urlItemID),
                                               object: nil)
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func LongPressLocation(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        let touchLocation = sender.location(in: self.mapViewOutlet)
        let touchedCoordinate = mapViewOutlet.convert(touchLocation, toCoordinateFrom: self.mapViewOutlet)
        
        // create an annotion point
        droppedPin.title = "Dropped Pin"
        droppedPin.coordinate = touchedCoordinate
        
        // creat pin view change colour
        let droppedPinView = MKAnnotationView.init(annotation: droppedPin, reuseIdentifier: "droppedPin")
        droppedPinView.tintColor = UIColor.cyan
        
        // add the annotation that bleongs to the pin view in the map
        self.mapViewOutlet.addAnnotation(droppedPinView.annotation!)
        
        DiveMapService.sharedInstance.getDiveMapInfo(lat: touchedCoordinate.latitude,
                                                     lng: touchedCoordinate.longitude,
                                                     dist: distances.distance25)
        setZoomInitialLocation(location: touchedCoordinate)
    }
    
    func setZoomInitialLocation(location: CLLocationCoordinate2D) {
        let regionRadius : CLLocationDistance = distances.distance25
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location,
                                                                  regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mapViewOutlet.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func notifyObservers(notification: NSNotification) {
        
        var DiveItemDict = notification.userInfo as! Dictionary<String , [DiveMapItems]>
        diveItemsObjects = DiveItemDict[dictKey.diveItemKey]!
        
        var annotations: [DiveMapAnnotation] = []
        for site in diveItemsObjects {
            
            let coordinate = CLLocationCoordinate2D.init(latitude: site.lat,
                                                         longitude: site.lng)
            let annotation = DiveMapAnnotation.init(diveSite: site,
                                                    coordinate: coordinate,
                                                    title: site.name)
            annotations.append(annotation)
        }
        self.mapViewOutlet.showAnnotations(annotations, animated: true)
        
    }
    
    @objc func notifyDetailObservers(notification: NSNotification) {
        
        var DiveItemDict = notification.userInfo as! Dictionary<String , DetailDiveSite>
        selectedDetailItem = DiveItemDict[dictKey.diveURLKey]!
        
        performSegue(withIdentifier: segues.pinSegue , sender: self)
        
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
        } else if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "droppedPin") {
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView.pinTintColor = UIColor.blue
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            pinView.canShowCallout = true
            pinView.animatesDrop = true
            return pinView
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.pinSegue {
            
            let detailView = segue.destination as! DetailViewController
            detailView.selectedDiveItem = self.selectedDetailItem
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Hier schrijf je wat moet geproberen als er op "i" geklikt wordt
        
        if let mapAnnotation = view.annotation as? DiveMapAnnotation {
            DetailDiveSiteMapService.sharedInstance.diveSearchDetail(id: mapAnnotation.diveSite.id)
        }
    }
   
    func setUPSearchBar () {
        let diveSearchTable = self.storyboard!.instantiateViewController(withIdentifier: "diveSearchID") as! SearchTableViewController
        diveSearchTable.delegate = self
        self.searchController = UISearchController.init(searchResultsController: diveSearchTable)
        self.searchController.searchBar.delegate = diveSearchTable
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.definesPresentationContext = true
        navigationItem.titleView = searchController?.searchBar
    }
    
//    func isMoreThanTwoCharacter(_ searchBar: UISearchBar) -> Bool {
//        return (searchBar.text?.characters.count)! >= 4
//    }
//
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if isMoreThanTwoCharacter(searchBar) {
//            self.diveItemsObjects = []
//            DiveMapService.sharedInstance.searchDiveMap(searchString: searchBar.text!)
//            self.showActivityIndicator(loadingView: loadingView, spinner: spinner)
//        }
//    }
    

    
}

