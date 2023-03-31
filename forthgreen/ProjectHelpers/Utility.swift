//
//  Utility.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import UIKit
import SainiUtils
import SDWebImage
import Photos
import DropDown

//MARK: - UIViewController
extension UIViewController {
    
    func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        scrollToTop(view: view)
    }
    
    var isScrolledToTop: Bool {
        for subView in view.subviews {
            if let scrollView = subView as? UIScrollView {
                return (scrollView.contentOffset.y == 0)
            }
        }
        return true
    }
    
    static var top: UIViewController? {
        get {
            return topViewController()
        }
    }
    
    static var root: UIViewController? {
        get {
            return UIApplication.shared.windows.first?.rootViewController
        }
    }
    
    static func topViewController(from viewController: UIViewController? = UIViewController.root) -> UIViewController? {
        if let tabBarViewController = viewController as? UITabBarController {
            return topViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
}

struct DEVICE {
    static var IS_IPHONE_X = (fabs(Double(SCREEN.HEIGHT - 812)) < Double.ulpOfOne)
}

extension UIWindow{
    //MARK: - visibleViewController
    var visibleViewController:UIViewController?{
        return UIWindow.visibleVC(vc:self.rootViewController)
    }
    static func visibleVC(vc: UIViewController?) -> UIViewController?{
        if let navigationViewController = vc as? UINavigationController{
            return UIWindow.visibleVC(vc:navigationViewController.visibleViewController)
        }
        else if let tabBarVC = vc as? UITabBarController{
            return UIWindow.visibleVC(vc:tabBarVC.selectedViewController)
        }
        else{
            if let presentedVC = vc?.presentedViewController{
                return UIWindow.visibleVC(vc:presentedVC)
            }
            else{
                return vc
            }
        }
    }
}

public func visibleViewController() -> UIViewController?{
    return UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.visibleViewController
}

//MARK:- toJson
func toJson(_ dict:[String:Any]) -> String{
    let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: [])
    let jsonString = String(data: jsonData!, encoding: .utf8)
    return jsonString!
}

//MARK: - getCurrentTimeStampValue
func getCurrentTimeStampValue() -> String
{
    return String(format: "%0.0f", Date().timeIntervalSince1970*1000)
}

//MARK: - DataExtension
extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString
    }
    
}

//MARK: - Image Compression to 10th
func compressImage(image: UIImage) -> Data {
    let originalImage = image
    // Reducing file size to a 10th
    var actualHeight : CGFloat = image.size.height
    var actualWidth : CGFloat = image.size.width
    let maxHeight : CGFloat = 1920.0
    let maxWidth : CGFloat = 1080.0
    var imgRatio : CGFloat = actualWidth/actualHeight
    let maxRatio : CGFloat = maxWidth/maxHeight
    var compressionQuality : CGFloat = 0.5
    if (actualHeight > maxHeight || actualWidth > maxWidth) {
        if (imgRatio < maxRatio) {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        } else if (imgRatio > maxRatio) {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        } else {
            actualHeight = maxHeight
            actualWidth = maxWidth
            compressionQuality = 1
        }
    }
    let rect = CGRect(x: 0.0, y: 0.0, width:actualWidth, height:actualHeight)
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    if img == nil {
        let imageData = originalImage.jpegData(compressionQuality: compressionQuality)!
        UIGraphicsEndImageContext();
        return imageData
    }else{
        let imageData = img!.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext();
        return imageData!
    }
    
}

//MARK:- Image Function
func compressImageView(_ image: UIImage, to toSize: CGSize) -> UIImage {
    var actualHeight: Float = Float(image.size.height)
    var actualWidth: Float = Float(image.size.width)
    let maxHeight: Float = Float(toSize.height)
    //600.0;
    let maxWidth: Float = Float(toSize.width)
    //800.0;
    var imgRatio: Float = actualWidth / actualHeight
    let maxRatio: Float = maxWidth / maxHeight
    //50 percent compression
    if actualHeight > maxHeight || actualWidth > maxWidth {
        if imgRatio < maxRatio {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight
            actualWidth = imgRatio * actualWidth
            actualHeight = maxHeight
        }
        else if imgRatio > maxRatio {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth
            actualHeight = imgRatio * actualHeight
            actualWidth = maxWidth
        }
        else {
            actualHeight = maxHeight
            actualWidth = maxWidth
        }
    }
    let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
    UIGraphicsBeginImageContext(rect.size)
    image.draw(in: rect)
    let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    let imageData1: Data? = img?.jpegData(compressionQuality: 1.0)//UIImageJPEGRepresentation(img!, CGFloat(1.0))//UIImage.jpegData(img!)
    UIGraphicsEndImageContext()
    return  imageData1 == nil ? image : UIImage(data: imageData1!)!
}

extension String {
    
    //MARK: - height of a label
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    //MARK: - isValidEmail
    var isValidEmail: Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var trimmed:String{
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

//MARK: - displaySubViewtoParentView
func displaySubViewtoParentView(_ parentview: UIView! , subview: UIView!)
{
    if subview == nil {
        return
    }
    subview.translatesAutoresizingMaskIntoConstraints = false
    parentview.addSubview(subview);
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
    parentview.addConstraint(NSLayoutConstraint(item: subview!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parentview, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
    parentview.layoutIfNeeded()
}

//MARK: - MyTextFieldDelegate
protocol MyTextFieldDelegate: class {
    func textFieldDidDelete()
}

// subclass UITextField and create protocol for it to know when the backButton is pressed
class MyTextField: UITextField {
    
    weak var myDelegate: MyTextFieldDelegate? // make sure to declare this as weak to prevent a memory leak/retain cycle
    
    override func deleteBackward() {
        super.deleteBackward()
        myDelegate!.textFieldDidDelete()
    }
    
    // when a char is inside the textField this keeps the cursor to the right of it. If the user can get on the left side of the char and press the backspace the current char won't get deleted
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        let beginning = self.beginningOfDocument
        let end = self.position(from: beginning, offset: self.text?.count ?? 0)
        return end
    }
}

class NavController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

//MARK:- Loader
func showLoader() {
    AppDelegate().sharedDelegate().showLoader()
}
// MARK: - removeLoader
func removeLoader() {
    AppDelegate().sharedDelegate().removeLoader()
}

//MARK: - downloadCachedImage
extension UIImageView{
    //MARK: - downloadCachedImage
    func downloadCachedImage(placeholder: String,urlString: String){
        //Progressive Download
        //This flag enables progressive download, the image is displayed progressively during download as a browser would do. By default, the image is only displayed once completely downloaded.
        //so this flag provide a better experience to end user
        let options: SDWebImageOptions = [.progressiveDownload,.scaleDownLargeImages]
        let placeholder = UIImage(named: placeholder)
        DispatchQueue.global().async {
            self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholder, options: options) { (image, _, cacheType,_ ) in
                guard image != nil else {
                    return
                }
                //Loading cache images for better and fast performace
                guard cacheType != .memory, cacheType != .disk else {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.image = image
                }
                return
            }
        }
    }
    
    //MARK: - downloadCachedImageWithLoader
    func downloadCachedImageWithLoader(placeholder: String,urlString: String){
        let options: SDWebImageOptions = [.scaleDownLargeImages]
        let placeholder = UIImage(named: placeholder)
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                self.sainiRemoveLoader()
                self.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
                self.sainiShowLoader(loaderColor: .gray)
            }
            
            self.sd_setImage(with: URL(string: urlString), placeholderImage: placeholder, options: options) { (image, _, cacheType,_ ) in
                guard image != nil else {
                    return
                }
                //Loading cache images for better and fast performace
                guard cacheType != .memory, cacheType != .disk else {
                    DispatchQueue.main.async {
                        self.sainiRemoveLoader()
                        self.image = image
                        self.backgroundColor = .white
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.sainiRemoveLoader()
                    self.image = image
                    self.backgroundColor = .white
                }
                return
            }
        }
    }
}

//MARK:- UICollectionView
extension UICollectionView {
    //MARK:- setEmptyMessage
    public func sainiSetEmptyMessageCV(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel;
    }
    //MARK:- sainiRestore
    public func restore() {
        self.backgroundView = nil
    }
}

extension UITapGestureRecognizer {
    //MARK: - didTapAttributedTextInLabel
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                                                        locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

//MARK: - getDateDiff
func getDateDiff(start: Date, end: Date) -> Int  {
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([Calendar.Component.second], from: start, to: end)
    
    let seconds = dateComponents.second
    return Int(seconds!)
}

//MARK: - underline
func underline(string: String) -> NSMutableAttributedString{
    return NSMutableAttributedString(string: string, attributes:
                                        [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue ,NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.6470588235, blue: 0.662745098, alpha: 1)])
}

//MARK: - underline
func underlineWithColor(string: String, color: UIColor) -> NSMutableAttributedString{
    return NSMutableAttributedString(string: string, attributes:
                                        [NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue ,NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: color])
}


//MARK: - RoundedView
class RoundedView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assert(bounds.height == bounds.width, "The aspect ratio isn't 1/1. You can never round this image view!")
        layer.cornerRadius = bounds.height / 2
    }
}

//MARK: - RoundedImageView
class RoundedImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        assert(bounds.height == bounds.width, "The aspect ratio isn't 1/1. You can never round this image view!")
        layer.cornerRadius = bounds.height / 2
    }
}

extension Encodable {
    //MARK: - Converting object to postable JSON
    func toJSON(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any] {
        guard let data = try? encoder.encode(self) else { return [:] }
        guard let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else { return [:] }
        guard let json = object as? [String: Any] else { return [:] }
        return json
    }
}

extension NSAttributedString {
    //MARK: - getAttributedString
    func getAttributedString(count: Int) -> NSAttributedString {
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: "$$$", attributes: [NSAttributedString.Key.font:UIFont(name: "BuenosAires-Bold", size: 14.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.turqoiseGreen, range: NSRange(location:0,length:count))
        return myMutableString
    }
    
}

extension String {
    //MARK: - htmlToAttributedString
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    //MARK: - htmlToString
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    //MARK: - convertToAttributedString
    func convertToAttributedString() -> NSAttributedString? {
        let modifiedFontString = "<span style=\"font-family: BuenosAires-Book; font-size: 14; color: rgb(30, 37, 38)\">" + self + "</span>"
        return modifiedFontString.htmlToAttributedString
    }
}

extension UILabel {
    //MARK: - increaseLineSpacing
    func increaseLineSpacing(text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 5 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        // *** Set Attributed String to your label ***
        self.attributedText = attributedString
    }
    
    //MARK: - calculateMaxLines
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}

//MARK: - getAttributedStringForLogin
func getAttributedStringForLogin() -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: "Do you have an account? ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 14)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)])
    attributedText.append(NSAttributedString(string: "LOGIN", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBold.rawValue, size: 12)!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1176470588, green: 0.1450980392, blue: 0.1490196078, alpha: 1)]))
    return attributedText
}

//MARK: - attributedStringForTerms
func attributedStringForTerms() -> NSAttributedString {
    let termsAttributedText = NSMutableAttributedString(string: "By signing up you agree our ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.6470588235, blue: 0.662745098, alpha: 1)])
    let underlineTerms = underline(string: "Terms & Conditions")
    let underlinePrivacy = underline(string: "Private Policy")
    let and = NSMutableAttributedString(string: " and ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5921568627, green: 0.6470588235, blue: 0.662745098, alpha: 1)])
    termsAttributedText.append(underlineTerms)
    termsAttributedText.append(and)
    termsAttributedText.append(underlinePrivacy)
    return termsAttributedText
}

//MARK: - attributedStringForTerms
func attributedStringForTermsWithColor(color: UIColor) -> NSAttributedString {
    let termsAttributedText = NSMutableAttributedString(string: "By signing up you agree our ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: color])
    let underlineTerms = underlineWithColor(string: "Terms & Conditions", color: color)
    let underlinePrivacy = underlineWithColor(string: "Private Policy", color: color)
    let and = NSMutableAttributedString(string: " and ", attributes: [NSAttributedString.Key.font: UIFont(name: APP_FONT.buenosAiresBook.rawValue, size: 12)!,NSAttributedString.Key.foregroundColor: color])
    termsAttributedText.append(underlineTerms)
    termsAttributedText.append(and)
    termsAttributedText.append(underlinePrivacy)
    return termsAttributedText
}


//MARK: - getDateFromDateString
func getDateFromDateString(strDate : String) -> Date   { // Today, 09:56 AM
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let dt = dateFormatter.date(from: strDate)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    let date1 : String = dateFormatter.string(from: dt ?? Date())
    return dateFormatter.date(from: date1)!
}

//MARK: - getDateInCurrentTimeZone
func getDateInCurrentTimeZone(date: String, outGoingFormat: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = outGoingFormat
    return dateFormatter.date(from: date)!
}

//MARK: - getDateStringFromDate
func getDateStringFromDate(date : Date, format : String) -> String {
    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

//MARK: - getDifferenceFromCurrentTimeInHourInDays
func getDifferenceFromCurrentTimeInHourInDays(_ newDate : String) -> String {
    let date = getDateInCurrentTimeZone(date: newDate, outGoingFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
    let interval = Date().timeIntervalSince(date)
    let second : Int = Int(interval)
    let minutes : Int = Int(interval/60)
    let hours : Int = Int(interval/(60*60))
    let days : Int = Int(interval/(60*60*24))
    let week : Int = Int(interval/(60*60*24*7))
    let months : Int = Int(interval/(60*60*24*30))
    let years : Int = Int(interval/(60*60*24*30*12))
    var timeAgo : String = ""
    if  second < 60 {
        timeAgo = "\(second)s"
    }
    else if minutes < 60 {
        timeAgo = String(minutes) + " m"
    }
    else if hours < 24 {
        timeAgo = String(hours) + " h"
    }
    else if days < 30 {
        timeAgo = String(days) + " d"//  + ((days > 1) ? "days ago" : "day ago")
    }
    else if week < 4 {
        timeAgo = String(week) + " w"
    }
    else if months < 12 {
        timeAgo = String(months) + " mo"
    }
    else if years < 1 {
        timeAgo = String(years) + " y"
    }
    else{
        timeAgo = getDateStringFromDate(date: date, format: "dd MMM yyyy")
    }
    return timeAgo
}

//MARK: - getAssetThumbnail
func getAssetThumbnail(asset: PHAsset) -> UIImage {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    var thumbnail = UIImage()
    option.isSynchronous = true
    manager.requestImage(for: asset, targetSize: CGSize(width: 800, height: 800), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
        if let image = result {
            thumbnail = image
        }
    })
    return thumbnail
}

//MARK: - convertToDictionary
func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK:- Delay Features
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

extension UIView {
    //MARK: - hideView
    func hideView() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            self.isHidden = true
        }, completion: nil)
    }
    
    //MARK: - showView
    func showView() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
            self.isHidden = false
        }, completion: nil)
    }
}

//MARK:- Attribute string
func attributedStringWithColor(_ mainString : String, _ strings: [String], color: UIColor, font: UIFont? = nil, lineSpacing: CGFloat? = nil, underline: Bool? = nil, alignment: NSTextAlignment? = nil) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: mainString)
    
    if lineSpacing != nil {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing!
        if alignment != nil {
            paragraphStyle.alignment = .center
        }
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    }
    
    for string in strings {
        let range = (mainString as NSString).range(of: string)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        if font != nil {
            attributedString.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
        }
        if underline != nil {
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: color, range: range)
        }
    }
    
    return attributedString
}

extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
//        print(label.text)
//        print(targetText)
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: 0/*(labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x*/,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
            locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        print(indexOfCharacter)
        print(targetRange)
//        return false
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}


func getTranslate(_ str : String) -> String
{
    return NSLocalizedString(str, comment: "")
}

//MARK:- Color function
func colorFromHex(hex : String) -> UIColor
{
    return colorWithHexString(hex, alpha: 1.0)
}

func colorFromHex(hex : String, alpha:CGFloat) -> UIColor
{
    return colorWithHexString(hex, alpha: alpha)
}

func colorWithHexString(_ stringToConvert:String, alpha:CGFloat) -> UIColor {
    
    var cString:String = stringToConvert.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: alpha
    )
}

func generateThumbnail(_ fileUrl: URL) -> UIImage? {
    let asset = AVAsset(url: fileUrl)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    do{
        let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1,timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumbnailCGImage)
    }
    catch let err{
        print(err)
    }
    return nil
}

func displayToast(message: String) {
    AppDelegate().sharedDelegate().showErrorToast(message: message)
}

func resolutionForVideo(url: URL) -> CGSize? {
    guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
    let size = track.naturalSize.applying(track.preferredTransform)
    return CGSize(width: abs(size.width), height: abs(size.height))
}
