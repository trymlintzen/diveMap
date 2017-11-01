//
//  ViewController.swift
//  diveMap
//
//  Created by Trym Lintzen on 01-11-17.
//  Copyright © 2017 Trym. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapViewOutlet: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapViewOutlet.showsUserLocation = true
        mapViewOutlet.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        <#code#>
    }
    
}

