//
//  RestaurantMapVC.swift
//  forthgreen
//
//  Created by MACBOOK on 06/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import MapKit
import SainiUtils

class RestaurantMapVC: UIViewController {
    
    private var restaurantDetailVM: RestaurantDetailViewModel = RestaurantDetailViewModel()
    private var restaurantListingVM: RestaurantListingViewModel = RestaurantListingViewModel()
    private var RestaurantMapListVM: RestaurantMapListViewModel = RestaurantMapListViewModel()
    private var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var restaurantListArray: [RestaurantListing] = [RestaurantListing]()
    private var restaurantDetail: RestaurantDetail = RestaurantDetail()
    var selectedLocation: RestaurantListing!
    var longitude: Double = Double()
    var latitude: Double = Double()
    private var category = [Int]()
    private var hasMore:Bool = false
    private var page: Int = 1
    var radius: Int = 81
    
    var mapCenterLongitude: Double = Double()
    var mapCenterLatitude: Double = Double()
    var isCurrentLocation: Bool = false
    
    @IBOutlet weak var bottomConstraintOfSelectedLocationView: NSLayoutConstraint!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dishTypeLbl: UILabel!
    @IBOutlet weak var rateCountLbl: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var restaurantNameView: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedLocationView: UIView!
    @IBOutlet weak var listBtn: UIButton!
    
    @IBOutlet weak var searchBackView: UIView!
//    @IBOutlet weak var searchTxt: UITextField!
    
    @IBOutlet weak var showMoreBackView: sainiCardView!
    @IBOutlet weak var userLocationBtn: UIButton!
    @IBOutlet weak var shimmerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        let tabBar : CustomTabBarController = self.tabBarController as! CustomTabBarController
        tabBar.setTabBarHidden(tabBarHidden: false)
        
        if SCREEN.HEIGHT >= 812 {
            bottomConstraintOfSelectedLocationView.constant = 60
        } else {
            bottomConstraintOfSelectedLocationView.constant = 72
        }
    }
    
    //MARK: - configUI
    private func configUI() {
        listBtn.sainiCornerRadius(radius: 16)
        searchBackView.sainiCornerRadius(radius: 20)
        searchBackView.setShadow(applyShadow: true)
        
//        restaurantListingVM.delegate = self
        restaurantDetailVM.delegate = self
        RestaurantMapListVM.delegate = self
        selectedLocationView.isHidden = true
        searchBackView.isHidden = true
        showMoreBackView.isHidden = true
        
        mapView.delegate = self
        beginLocationUpdates(locationManager: locationManager)
        
        guard let latitude = currentLocation?.latitude else{ return }
        guard let longitude = currentLocation?.longitude else { return }
        self.latitude = latitude
        self.longitude = longitude
        if latitude != DocumentDefaultValues.Empty.double && longitude != DocumentDefaultValues.Empty.double{
            let zoomLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
            let region = MKCoordinateRegion(center: zoomLocation, span: span)
            mapView.setRegion(region, animated: true)
//            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 200, page: page)
//            restaurantListingVM.fetchRestaurantListing(request: request)

            getRestaurantForMap(lat: latitude, long: longitude, radius: radius)
        }
        else {
            self.view.sainiShowToast(message: "Kindly enable your location services.")
        }
        
        // gestures
        selectedViewGesture()
        
//        RestaurantMapListVM.restaurantList.bind { [weak self](_) in
//            guard let `self` = self else { return }
//            DispatchQueue.main.async {
//
//            }
//        }
        
//        if #available(iOS 13.0, *) {
//            mapView.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 3000, // Minimum zoom value
//                maxCenterCoordinateDistance: 30000)
//        } else {
//            // Fallback on earlier versions
//        }
    }
    
    func getRestaurantForMap(lat: Double, long: Double, radius: Int) {
        RestaurantMapListVM.getReataurantByMapList(request: RestaurantMapListRequest(longitude: long, latitude: lat/*, existId: page == 1 ? [] : restaurantListArray.map { ($0.id) }*/, page: page, limit: 30))
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
        
        if restaurantListArray.count == 0 {
//            self.view.sainiShowToast(message: "No data found for this location")
        }
        
        restaurantListArray.forEach { (restaurant) in
            let Annotation = RestaurantAnnotation()
            Annotation.title = restaurant.name
            Annotation.subtitle = ""
            Annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.location?.coordinates[0] ?? 0 , longitude:restaurant.location?.coordinates[1] ?? 0)
            Annotation.data = restaurant
            Annotation.isSelected = restaurant.isSelected
            mapView.addAnnotation(Annotation)
        }
    }
    
    //MARK: - selectedViewGesture
    private func selectedViewGesture() {
        selectedLocationView.sainiAddTapGesture {
            if self.restaurantDetail.id != "" {
                let vc = STORYBOARD.RESTAURANT.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
                vc.restaurantId = self.restaurantDetail.id
                vc.distance = self.restaurantDetail.distance
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - filterBtnIsPressed
    @IBAction func filterBtnIsPressed(_ sender: UIBarButtonItem) {
        let vc = STORYBOARD.HOME.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        vc.delegate = self
        vc.filterType = .restaurants
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: - listBtnIsPressed
    @IBAction func listBtnIsPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: - crossBtnOfPopUpIsPressed
    @IBAction func crossBtnOfPopUpIsPressed(_ sender: UIButton) {
        selectedLocationView.isHidden = true
        for (index,_) in restaurantListArray.enumerated(){
            restaurantListArray[index].isSelected = false
        }
        addCustomAnnotation()
    }
    
    @IBAction func clickToSearchHere(_ sender: Any) {
        page = 1
        getRestaurantForMap(lat: mapCenterLatitude, long: mapCenterLongitude, radius: radius)
        selectedLocationView.isHidden = true
    }
    
    @IBAction func clickToShowMore(_ sender: Any) {
        page = page + 1
        showMoreBackView.isHidden = true
        getRestaurantForMap(lat: mapCenterLatitude, long: mapCenterLongitude, radius: radius)
    }
    
    @IBAction func clickToGetBackToUserLocation(_ sender: Any) {
        guard let latitude = currentLocation?.latitude else{ return }
        guard let longitude = currentLocation?.longitude else { return }
        self.latitude = latitude
        self.longitude = longitude
        if latitude != DocumentDefaultValues.Empty.double && longitude != DocumentDefaultValues.Empty.double{
            let zoomLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
            let region = MKCoordinateRegion(center: zoomLocation, span: span)
            mapView.setRegion(region, animated: true)
            page = 1
            getRestaurantForMap(lat: latitude, long: longitude, radius: radius)
            selectedLocationView.isHidden = true
            
            self.searchBackView.isHidden = true
        }
        else {
            self.view.sainiShowToast(message: "Kindly enable your location services.")
        }
    }
}

//MARK: - UITextFieldDelegate
extension RestaurantMapVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            restaurantListArray = [RestaurantListing]()
            getRestaurantForMap(lat: latitude, long: longitude, radius: radius)
        }
        return true
    }
}


//MARK: - MKMapViewDelegate
extension RestaurantMapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is RestaurantAnnotation) {
            return nil
        }
        let restaurantAnnotation = annotation as! RestaurantAnnotation
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom pin")
        if restaurantAnnotation.isSelected == true {
            annotationView.image =  UIImage(named: "selected_pin")
        } else {
            annotationView.image =  UIImage(named: "regular_pin")
        }
        annotationView.canShowCallout = false
        return annotationView
    }
    
    //didSelect
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for restaurant in 0..<restaurantListArray.count {
            restaurantListArray[restaurant].isSelected = false
        }
        if mapView.centerCoordinate.latitude == currentLocation?.latitude && mapView.centerCoordinate.longitude == currentLocation?.longitude {
            return
        }
        
        let Annotation = view.annotation as? RestaurantAnnotation
        
        if Annotation != nil {
            for (index,_) in restaurantListArray.enumerated(){
                restaurantListArray[index].isSelected = false
                if Annotation?.data?.id == restaurantListArray[index].id{
                    restaurantListArray[index].isSelected = true
                }
            }
            // redering data on pop up
            if let annotation = Annotation {
          //      renderDataOnPopUp(annotation: annotation)
                
                if let restaurantId = Annotation?.data?.id {
                    selectedLocationView.isHidden = false
                    shimmerView.isHidden = false
                    shimmerView.isSkeletonable = true
                    shimmerView.showAnimatedGradientSkeleton()
                    let request = RestaurantDetailRequest(longitude: longitude, latitude: latitude, restaurantId: restaurantId)
                    restaurantDetailVM.fetchRestaurantDetail(request: request)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print(userLocation)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
        print("*********////////////***********")
        print(mapView.currentRadius()/10)
         
        if radius != Int(mapView.currentRadius()/10) {
            radius = 80//Int(mapView.currentRadius()/10)
            searchBackView.isHidden = false
            showMoreBackView.isHidden = true
            mapCenterLatitude = mapView.region.center.latitude
            mapCenterLongitude = mapView.region.center.longitude
            
//            getRestaurantForMap(lat: mapView.region.center.latitude, long: mapView.region.center.longitude, radius: radius)
        }
    }
    
    //MARK: - renderDataOnPopUp
    func renderDataOnPopUp(annotation: RestaurantAnnotation) {
        selectedLocationView.isHidden = false
        selectedLocation = annotation.data
        restaurantImageView.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (annotation.data?.thumbnail ?? DocumentDefaultValues.Empty.string))
        restaurantNameView.text = annotation.data?.name
        starRatingView.rating = annotation.data?.ratings?.averageRating ?? DocumentDefaultValues.Empty.double
        rateCountLbl.text = "\(annotation.data?.ratings?.count ?? DocumentDefaultValues.Empty.int)"
        dishTypeLbl.text = annotation.data?.location?.address ?? "" //annotation.data?.typeOfFood
        let count: Int = annotation.data?.price.count ?? DocumentDefaultValues.Empty.int
        let myString: NSString = "$$$"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
        // set label Attribute
        priceLbl.attributedText = myMutableString
        let distance = (annotation.data?.distance ?? DocumentDefaultValues.Empty.double) * 0.00062137
        distanceLbl.text = String(format: "%0.1f", distance) + " miles"
        addCustomAnnotation()
    }
    
    func renderDataFromDetailOnPopUp(detail: RestaurantDetail) {
        selectedLocationView.isHidden = false
        shimmerView.isHidden = true
//        selectedLocation = annotation.data
        restaurantImageView.downloadCachedImageWithLoader(placeholder: "rectangle", urlString: AppImageUrl.average + (detail.thumbnail))
        restaurantNameView.text = detail.name
        starRatingView.rating = detail.ratings?.averageRating ?? DocumentDefaultValues.Empty.double
        rateCountLbl.text = "\(detail.ratings?.count ?? DocumentDefaultValues.Empty.int)"
        dishTypeLbl.text = detail.location?.address ?? "" //annotation.data?.typeOfFood
        let count: Int = detail.price.count
        let myString: NSString = "$$$"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
        // set label Attribute
        priceLbl.attributedText = myMutableString
        let distance = (detail.distance) * 0.00062137
        distanceLbl.text = String(format: "%0.1f", distance) + " miles"
        addCustomAnnotation()
    }
}

//MARK: - RestaurantDetailDelegate
extension RestaurantMapVC: RestaurantDetailDelegate {
    func didRecieveDetailResponse(response: RestaurantDetailResponse) {
        log.success(response.message)/
        shimmerView.hideSkeleton()
        shimmerView.isHidden = true
        restaurantDetail = response.data ?? RestaurantDetail()
        
        renderDataFromDetailOnPopUp(detail: restaurantDetail)
    }
}


extension MKMapView {
    func topCenterCoordinate() -> CLLocationCoordinate2D {
        return self.convert(CGPoint(x: self.frame.size.width / 2.0, y: 0), toCoordinateFrom: self)
    }

    func currentRadius() -> Double {
        let centerLocation = CLLocation(latitude: self.centerCoordinate.latitude, longitude: self.centerCoordinate.longitude)
        let topCenterCoordinate = self.topCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        return centerLocation.distance(from: topCenterLocation)
    }
}

//MARK: - RestaurantListingDelegate
extension RestaurantMapVC: RestaurantMapListingDelegate {
    func didRecieveRestaurantMapListResponse(response: RestaurantListingResponse) {
        log.success(response.message)/
        
        if response.hasMore {
            hasMore = response.hasMore
            showMoreBackView.isHidden = false
        }
        else{
            hasMore = response.hasMore
            showMoreBackView.isHidden = true
        }
        
        if page == 1 {
            restaurantListArray = [RestaurantListing]()
            addCustomAnnotation()
        }
        restaurantListArray += (response.data)
        searchBackView.isHidden = true
        
        if restaurantListArray.count == 0 && currentLocation != nil {
            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
            let region = MKCoordinateRegion(center: currentLocation!, span: span)
    //        mapView.setRegion(region, animated: true)
        }
        else {
            let latitude = restaurantListArray.first?.location?.coordinates[0] ?? 0.0
            let longitude = restaurantListArray.first?.location?.coordinates[1] ?? 0.0
            
            let zoomLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
            let region = MKCoordinateRegion(center: zoomLocation, span: span)
            
//            if searchTxt.text != "" {
//                mapView.setRegion(region, animated: true)
//            }
 
            if response.data.count != 0 {
                addCustomAnnotation()
            }
        }
    }
    
//    //RestaurantListingDelegate {
//    func didRecieveRestaurantListResponse(response: RestaurantListingResponse) {
//        log.success(response.message)/
//        restaurantListArray = (response.data)
//        if restaurantListArray.count == 0 {
//            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
//            let region = MKCoordinateRegion(center: currentLocation!, span: span)
//            mapView.setRegion(region, animated: true)
//        }
//        else {
//            guard let latitude = restaurantListArray.first?.location?.coordinates[0] else {
//                return
//            }
//            guard let longitude = restaurantListArray.first?.location?.coordinates[1] else {
//                return
//            }
//            let zoomLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            let span = MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13)
//            let region = MKCoordinateRegion(center: zoomLocation, span: span)
//            mapView.setRegion(region, animated: true)
//            addCustomAnnotation()
//        }
//    }
    
}

//MARK: - FilterDelegate
extension RestaurantMapVC: FilterDelegate {
    func didRecieveFilterParams(category: [Int]) {
        self.category = category
        restaurantListArray.removeAll()
        if latitude != DocumentDefaultValues.Empty.double && longitude != DocumentDefaultValues.Empty.double{
            let request = RestaurantListRequest(longitude: longitude, latitude: latitude, categories: category, limit: 200, page: page)
            restaurantListingVM.fetchRestaurantListing(request: request)
        }
    }
}
