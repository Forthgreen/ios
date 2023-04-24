//
//  AskLoginPopupVC.swift
//  forthgreen
//
//  Created by ARIS Pvt Ltd on 11/04/23.
//  Copyright © 2023 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils

public enum AskLoginType: String {
    case login
}

public protocol AskLoginPopupDelegate {
    func userSelectedLoginSignup(selectionType: AskLoginType)
}

class AskLoginPopupVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewLogin: UIView!
    var image = UIImage()
    var context = CIContext(options: nil)
    var delegate:AskLoginPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     //   self.viewLogin.setCornerRadius(10)
        self.applyShadowOnView(self.viewLogin)
        self.imageView.image = self.image
        self.imageView.contentMode = .scaleToFill
        self.blurEffect()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tapGesture.numberOfTapsRequired = 1
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 15
    }
    
    @objc func dismissView(gesture: UITapGestureRecognizer) {
        self.dismiss(animated: false)
    }
    

    func blurEffect() {

        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: imageView.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(15, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imageView.image = processedImage
    }
    
    
    @IBAction func btnLoginAction(_ sender: Any) {
       // self.delegate?.userSelectedLoginSignup(selectionType: .login)
        (UIApplication.shared.delegate as? AppDelegate)?.logoutUser()
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

