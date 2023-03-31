//
//  RestaurantDetailCell.swift
//  forthgreen
//
//  Created by MACBOOK on 01/10/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import ImageSlideshow
import SainiUtils
import MapKit

class RestaurantDetailCell: UITableViewCell {

    @IBOutlet weak var copyLocationBtn: UIButton!
    @IBOutlet weak var heightConstraintOfViewMoreBtnView: NSLayoutConstraint!
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var viewMoreBtnView: UIView!
    @IBOutlet weak var viewMoreBtn: UIButton!
    @IBOutlet weak var addressLine2: UILabel!
    @IBOutlet weak var addressLine1: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var dishImageView: ImageSlideshow!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var dishTypeLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var restaurantNameLbl: UILabel!
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var bookmarkBtn: UIButton!
    
    @IBOutlet weak var writeReviewBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - configUI
    private func configUI() {
        mapView.delegate = self
        restaurantImageView.sainiCornerRadius(radius: 4)
        followBtn.sainiCornerRadius(radius: 4)
        reviewBtn.sainiCornerRadius(radius: 4)
        websiteBtn.sainiCornerRadius(radius: 4)
        mapView.isHidden = true
    }
    
}

//MARK: - MKMapViewDelegate
extension RestaurantDetailCell: MKMapViewDelegate {
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
