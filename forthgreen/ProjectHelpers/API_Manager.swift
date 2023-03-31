//
//  API_Helper.swift
//  Trouvaille-ios
//
//  Created by MACBOOK on 01/04/20.
//  Copyright © 2020 SukhmaniKaur. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire

//MARK: - UploadImageInfo
struct UploadImageInfo {
    var name: String
    var data: Data?
    var image: UIImage?
    var url : URL?
    
    init() {
        name = ""
        data = nil
        image = nil
        url = nil
    }
}

public class APIManager {
    
    static let sharedInstance = APIManager()
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    func getMultipartHeader() -> [String:String]{
        return ["Content-Type":"multipart/form-data"]
    }
    
    func getJsonHeader() -> [String:String]{
        return ["Content-Type":"application/json"]
    }
    
    func getJsonHeaderWithToken() -> [String:String]{
        return ["Content-Type":"application/json", "Authorization":AppModel.shared.token]
    }
    
    func getMultipartHeaderWithToken() -> [String:String]{
        return ["Content-Type":"multipart/form-data", "Authorization":AppModel.shared.token]
    }
    
    
    func getx_www_orm_urlencoded() -> [String:String]{
        return ["Content-Type":"x-www-form-urlencoded", "Authorization":AppModel.shared.token]
    }
    
    func networkErrorMsg()
    {
        log.error("You are not connected to the internet")/
        displayToast(message: "You are not connected to the internet")
    }
    
    //MARK:- ERROR CODES
    func handleError(errorCode: Int) -> String {
        switch errorCode {
        case 101:
            return "Missing Required Properties"
        case 102:
            return "Connection Error"
        case 103:
            return "Requested user not found"
        case 104:
            return "Username/Password error"
        case 105:
            return "Nothing Modified/ No changes Made"
        case 106:
            return "Invalid Access Token"
        case 107:
            return "This Email id is already registered."
        case 108:
            return "Invalid OTP type."
        case 109:
            return "Token not verified."
        case 110:
            return "Email id already verified."
        case 111:
            return "Verficiation code try has been expired. Request a new token."
        case 112:
            return "verification code has been expired. Token expires in 24 hours."
        case 113:
            return "Invlid URL provided for verification."
        case 114:
            return "Broken reference found."
        case 115:
            return "Profile seems to have missing region data or you are trying to post in wrong region."
        case 400:
            return "Malformed Authorization token error when token in invalid or has been expired."
        case 500:
            return "Generic error or some default error"
            
        default:
            return ""
        }
    }
    
    //MARK:- MULTIPART_IS_COOL
    func MULTIPART_IS_COOL(_ imageData : Data,param: [String: Any],api: String,login: Bool, _ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.view.sainiShowLoader(loaderColor: AppColors.LoaderColor)
        }
        var headerParams :[String : String] = [String : String]()
        if login == true{
            headerParams = getMultipartHeaderWithToken()
        }
        else{
            headerParams = getMultipartHeader()
        }
        var params :[String : Any] = [String : Any] ()
        
        params["data"] = toJson(param)//Converting Array into JSON Object
        log.info("HEADERS: \(Log.stats()) \(headerParams)")/
        log.info("PARAMS: \(Log.stats()) \(params)")/
        log.info("API: \(Log.stats()) \(api)")/
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData.count != 0
            {
                multipartFormData.append(imageData, withName: "image", fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: api, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    log.inprocess("Upload Progress: \(Progress.fractionCompleted)")/
                })
                upload.responseJSON { response in
                    
                    DispatchQueue.main.async {
                        UIViewController.top?.view.sainiRemoveLoader()
                    }
                    
                    log.result("\(String(describing: response.result.value))")/
                    log.ln("prettyJSON Start \n")/
                    log.result("\(String(describing: response.data?.prettyPrintedJSONString))")/
                    log.ln("prettyJSON End \n")/
                    if let result = response.result.value as? [String:Any]{
                        if let code = result["code"] as? Int{
                            if(code == 100){
                                if login == true{
                                    log.success("\(Log.stats()) User Logged In Successfully!")/
                                }
                                else{
                                    log.success("\(Log.stats()) User register Successfully!")/
                                }
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                return
                            }
                            else if code == 401{
                                if let message = result["message"] as? String{
                                    self.logout()
                                    AppDelegate().sharedDelegate().showErrorToast(message: message)
                                }
                            }
                            else{
                                if let message = result["message"] as? String{
                                    log.error("\(Log.stats()) \(message)")/
                                    displayToast(message: message)
                                }
                                return
                            }
                        }
                        if let message = result["message"] as? String{
                            log.error("\(Log.stats()) \(message)")/
                            AppDelegate().sharedDelegate().showErrorToast(message: message)
                            return
                        }
                    }
                    if let error = response.result.error
                    {
                        log.error("\(Log.stats()) \(error)")/
                        AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                        return
                    }
                }
                
            case .failure(let error):
                
                log.error("\(Log.stats()) \(error)")/
//                UIViewController.top?.view.sainiShowToast(message:"Server Error please check server logs.")
                break
            }
        }
    }
    
    //MARK:- MULTIPART_IS_COOL
    func MULTIPART_IS_COOL(_ imageArr: [UploadImageInfo], param: [String: Any],api: String,login: Bool, _ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork() {
            APIManager().networkErrorMsg()
            return
        }
        
        DispatchQueue.main.async {
            UIViewController.top?.view.sainiShowLoader(loaderColor: AppColors.LoaderColor)
        }
        var headerParams :[String : String] = [String : String]()
        if login == true {
            headerParams = getMultipartHeaderWithToken()
        }
        else{
            headerParams = getMultipartHeader()
        }
        var params :[String : Any] = [String : Any] ()
        
        params["data"] = toJson(param)//Converting Array into JSON Object
        log.info("HEADERS: \(Log.stats()) \(headerParams)")/
        log.info("API: \(Log.stats()) \(api)")/
        log.info("PARAMS: \(Log.stats()) \(params)")/
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageArr.count != 0 {
                for image in imageArr {
                    if image.url != nil {
                        multipartFormData.append(image.url!, withName: image.name)
                    }else if image.data != nil {
                        multipartFormData.append(image.data!, withName: image.name, fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
                    }
                    
                }
            }
            
        }, usingThreshold: UInt64.init(), to: api, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    log.inprocess("Upload Progress: \(Progress.fractionCompleted)")/
                })
                upload.responseJSON { response in
                    
                    DispatchQueue.main.async {
                        UIViewController.top?.view.sainiRemoveLoader()
                    }
                    
                 //   log.result("\(String(describing: response.result.value))")/
                    log.ln("prettyJSON Start \n")/
                    log.result("\(String(describing: response.data?.sainiPrettyJSON))")/
                    log.ln("prettyJSON End \n")/
                    if let result = response.result.value as? [String:Any]{
                        if let code = result["code"] as? Int{
                            if(code == 100){
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                return
                            }
                            else if code == 401{
                                if let message = result["message"] as? String{
                                    log.error("\(Log.stats()) \(message)")/
                                    self.logout()
                                    //                            displayToast(message)
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                if let message = result["message"] as? String{
                                    displayToast(message: message)
                                }
                                return
                            }
                        }
                        if let message = result["message"] as? String{
                            displayToast(message: message)
                            return
                        }
                    }
                    if let error = response.result.error {
                        AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                        return
                    }
                    AppDelegate().sharedDelegate().showErrorToast(message: "error")
                }
                
            case .failure(let error):
                print(error)
                AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                break
            }
        }
    }
    
    func uploadVideoWithProgress(_ imageArr: [UploadImageInfo], param: [String: Any],api: String,login: Bool, _ completionProgress: @escaping (_ progress : Double) -> Void, _ completion: @escaping (_ dictArr: Data?) -> Void) {
        
        if !APIManager.isConnectedToNetwork() {
            APIManager().networkErrorMsg()
            return
        }
        
        DispatchQueue.main.async {
//            UIViewController.top?.view.sainiShowLoader(loaderColor: AppColors.LoaderColor)
        }
        var headerParams :[String : String] = [String : String]()
        if login == true {
            headerParams = getMultipartHeaderWithToken()
        }
        else{
            headerParams = getMultipartHeader()
        }
        var params :[String : Any] = [String : Any] ()
        
        params["data"] = toJson(param)//Converting Array into JSON Object
        log.info("HEADERS: \(Log.stats()) \(headerParams)")/
        log.info("API: \(Log.stats()) \(api)")/
        log.info("PARAMS: \(Log.stats()) \(params)")/
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            print(multipartFormData)
            if imageArr.count != 0 {
                for image in imageArr {
                    if image.url != nil {
                        multipartFormData.append(image.url!, withName: image.name)
                    }else if image.data != nil {
                        multipartFormData.append(image.data!, withName: image.name, fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
                    }
                }
            }            
        }, usingThreshold: UInt64.init(), to: api, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    log.inprocess("Upload Progress: \(Progress.fractionCompleted)")/
                    completionProgress(Progress.fractionCompleted)
                })
                upload.responseJSON { response in
                    
                    DispatchQueue.main.async {
//                        UIViewController.top?.view.sainiRemoveLoader()
                    }
                    
                 //   log.result("\(String(describing: response.result.value))")/
                    log.ln("prettyJSON Start \n")/
                    log.result("\(String(describing: response.data?.sainiPrettyJSON))")/
                    log.ln("prettyJSON End \n")/
                    if let result = response.result.value as? [String:Any]{
                        if let code = result["code"] as? Int{
                            if(code == 100){
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                return
                            }
                            else if code == 401{
                                if let message = result["message"] as? String{
                                    log.error("\(Log.stats()) \(message)")/
                                    self.logout()
                                    //                            displayToast(message)
                                }
                            }
                            else{
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                if let message = result["message"] as? String{
                                    displayToast(message: message)
                                    NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: nil)
                                }
                                return
                            }
                        }
                        if let message = result["message"] as? String{
                            AppDelegate().sharedDelegate().showErrorToast(message: message)
                            NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: nil)
                            return
                        }
                    }
                    if let error = response.result.error {
                        AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                        NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: nil)
                        return
                    }
                    AppDelegate().sharedDelegate().showErrorToast(message: "error")
                }
                
            case .failure(let error):
                print(error)
                AppDelegate().sharedDelegate().showErrorToast(message: "OOPS, THERE IS A PROBLEM. Videos can only be a maximum of 150mb and only 1 minute long.")
                NotificationCenter.default.post(name: NOTIFICATIONS.AddPostProgress, object: nil)
                break
            }
        }
    }
    
    //MARK:- MULTIPART_IS_COOL
    func MULTIPART_IS_COOL_With_Pictures(_ imageData : Data,_ imageData2: Data,param: [String: Any],api: String,login: Bool, _ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        DispatchQueue.main.async {
            UIViewController.top?.view.sainiShowLoader(loaderColor: AppColors.LoaderColor)
        }
        var headerParams :[String : String] = [String : String]()
        if login == true{
            headerParams = getMultipartHeaderWithToken()
        }
        else{
            headerParams = getMultipartHeader()
        }
        var params :[String : Any] = [String : Any] ()
        
        params["data"] = toJson(param)//Converting Array into JSON Object
        log.info("PARAMS: \(Log.stats()) \(params)")/
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if imageData.count != 0
            {
                multipartFormData.append(imageData, withName: "picture", fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
                
                multipartFormData.append(imageData2, withName: "picture2", fileName: getCurrentTimeStampValue() + ".png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: api, method: .post
        , headers: headerParams) { (result) in
            switch result{
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    log.inprocess("Upload Progress: \(Progress.fractionCompleted)")/
                })
                upload.responseJSON { response in
                    
                    DispatchQueue.main.async {
                        UIViewController.top?.view.sainiRemoveLoader()
                    }
                    
                    log.result("\(String(describing: response.result.value))")/
                    log.ln("prettyJSON Start \n")/
                    log.result("\(String(describing: response.data?.prettyPrintedJSONString))")/
                    log.ln("prettyJSON End \n")/
                    if let result = response.result.value as? [String:Any]{
                        if let code = result["code"] as? Int{
                            if(code == 100){
                                
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                return
                            }
                            else{
                                DispatchQueue.main.async {
                                    completion(response.data)
                                }
                                if let message = result["message"] as? String{
                                    AppDelegate().sharedDelegate().showErrorToast(message:"SOMETHING WENT WRONG.\n" + message)
                                }
                                return
                            }
                        }
                        if let message = result["message"] as? String{
                            displayToast(message: message)
                            return
                        }
                    }
                    if let error = response.result.error
                    {
                        AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                        return
                    }
                    AppDelegate().sharedDelegate().showErrorToast(message: "error")
                    
                    
                }
                
            case .failure(let error):
                
                print(error)
//                UIViewController.top?.view.sainiShowToast(message:"Server Error please check server logs.")
                break
            }
        }
    }
    
    //MARK:- I AM COOL
    func I_AM_COOL(params: [String: Any],api: String,Loader: Bool,isMultipart:Bool,_ completion: @escaping (_ dictArr: Data?) -> Void){
        if !APIManager.isConnectedToNetwork()
        {
            APIManager().networkErrorMsg()
            return
        }
        
        if Loader == true{
            DispatchQueue.main.async {
                
                showLoader()
            }
        }
        
        var headerParams :[String : String] = [String: String]()
        var Params:[String: Any] = [String: Any]()
        if isMultipart == true{
            headerParams = getMultipartHeaderWithToken()
            Params["data"] = toJson(params)
        }
        else{
            headerParams  = getJsonHeaderWithToken()
            Params = params
        }
        log.info("HEADERS: \(Log.stats()) \(headerParams)")/
        log.info("API: \(Log.stats()) \(api)")/
        log.info("PARAMS: \(Log.stats()) \(Params)")/
        
        
        Alamofire.request(api, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headerParams).responseJSON { (response) in
            
            DispatchQueue.main.async {
                removeLoader()
            }
            
            switch response.result {
            case .success:
//                log.result("\(String(describing: response.result.value))")/
                log.ln("prettyJSON Start \n")/
                log.result("\(String(describing: response.data?.prettyPrintedJSONString))")/
                log.ln("prettyJSON End \n")/
                if let result = response.result.value as? [String:Any]{
                    if let code = result["code"] as? Int{
                        if(code == 100){
                            log.success("\(Log.stats()) SUCCESS")/
                            DispatchQueue.main.async {
                                completion(response.data)
                            }
                            return
                        }
                        else if code == 401{
                            if (result["message"] as? String) != nil{
                                self.logout()
//                                UIViewController.top?.view.sainiShowToast(message:message)
                                
                            }
                        }
                        else if code == 302 {
                            log.success("\(Log.stats()) NO NOTIFICATION EXISTS")/
                            DispatchQueue.main.async {
                                completion(response.data)
                            }
                            return
                        }
                        else{
                            if let message = result["message"] as? String{
                                log.error("\(Log.stats()) \(message)")/
                                displayToast(message: message)
                            }
                            return
                        }
                    }
                    if let message = result["message"] as? String{
                        log.error("\(Log.stats()) \(message)")/
//                        UIViewController.top?.view.sainiShowToast(message:message)
                        return
                    }
                }
                if let error = response.result.error
                {
                    log.error("\(Log.stats()) \(error)")/
                    
                    AppDelegate().sharedDelegate().showErrorToast(message: error.localizedDescription)
                    return
                }
            case .failure(let error):
                log.error("\(Log.stats()) \(error)")/
//                UIViewController.top?.view.sainiShowToast(message:"Server Error please check server logs.")
                break
            }
        }
    }
    
    func logout(){
        KeychainItem.deleteUserIdentifierFromKeychain()
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.removeObject(forKey: "currentUser")
        AppModel.shared.guestUserType = .none
        AppModel.shared.token = ""
        let loginVC = STORYBOARD.MAIN.instantiateViewController(withIdentifier: "LoginNavigation") as! UINavigationController
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
