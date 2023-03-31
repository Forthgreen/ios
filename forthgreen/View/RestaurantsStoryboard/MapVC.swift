//
//  MapVC.swift
//  forthgreen
//
//  Created by MACBOOK on 10/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    private var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var selectedLocation: RestaurantDetail!

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLbl.text = selectedLocation.name
//        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: true)
    }
    
    //MARK: - configUI
    private func configUI() {
        mapView.delegate = self
        beginLocationUpdates(locationManager: locationManager)
        
        let location = CLLocationCoordinate2D(latitude: selectedLocation.location?.coordinates[0] ?? 0 , longitude: selectedLocation.location?.coordinates[1] ?? 0)
        zoomToLatestLocation(with: location)
        addCustomAnnotation()
    }
    
    //MARK: - beginLocationUpdates
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //MARK: - addCustomAnnotation
    func addCustomAnnotation() {
        
        mapView.removeAnnotations(mapView.annotations)
        
        let Annotation = RestaurantAnnotation()
        Annotation.title = selectedLocation.name
        Annotation.subtitle = ""
        Annotation.coordinate = CLLocationCoordinate2D(latitude: selectedLocation.location?.coordinates[0] ?? 0 , longitude:selectedLocation.location?.coordinates[1] ?? 0)
        mapView.addAnnotation(Annotation)
    }
    
    //MARK: - zoomToLatestLocation
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D) {
        let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(zoomRegion, animated: true)
    }
    
    //MARK: - closeBtnIsPressed
    @IBAction func closeBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK: - MKMapViewDelegate
extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is RestaurantAnnotation) {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom pin")
        annotationView.image =  UIImage(named: "regular_pin")
        annotationView.canShowCallout = false
        return annotationView
    }
    
}
