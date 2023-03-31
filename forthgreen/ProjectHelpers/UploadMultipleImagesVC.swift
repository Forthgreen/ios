//
//  UploadMultipleImagesVC.swift
//  forthgreen
//
//  Created by MACBOOK on 03/05/21.
//  Copyright © 2021 SukhmaniKaur. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MobileCoreServices

class UploadMultipleImagesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imgPicker = UIImagePickerController()
    var imageCount: Int = Int()
    var maxSelection: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgPicker.delegate = self
        
    }
    
    // MARK: - Upload Image
    /**
     *
     * This function is use for upload image.
     * User can select image from gallery or camera.
     * Using onCaptureImageThroughCamera function user can capture image through camera.
     * Using onCaptureImageThroughGallery function user can select image from gallery.
     * imagePickerController is delegate methode of image picker controller.
     *
     * @param
     */
    func uploadImage()
    {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.black
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelButton)
        
        let cameraButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            print("Camera")
            self.onCaptureImageThroughCamera()
        }
        actionSheet.addAction(cameraButton)
        
        let galleryButton = UIAlertAction(title: "Upload Image", style: .default)
        { _ in
            print("Gallery")
            self.onCaptureImageThroughGallery()
        }
        actionSheet.addAction(galleryButton)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
                
            }
        }
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @objc open func onCaptureImageThroughCamera()
    {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.view.sainiShowToast(message: "Your device has no camera")
        }
        else {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            imgPicker.sourceType = .camera
            imgPicker.mediaTypes = ["public.image"]
            UIViewController.top?.present(imgPicker, animated: true, completion: {() -> Void in
            })
        }
    }
    
    @objc open func onCaptureImageThroughGallery()
    {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = maxSelection
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true
        
        let start = Date()
        self.presentImagePicker(imagePicker, select: { (asset) in
            print("Selected: \(asset)")
        }, deselect: { (asset) in
            print("Deselected: \(asset)")
        }, cancel: { (assets) in
            print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            print("Finished with selections: \(assets)")
            assets.forEach { (asset) in
                let image = getAssetThumbnail(asset: asset)
                let imageData = compressImage(image: image)
                self.imageCount += 1
                var selectedImagesArray: [UploadImageInfo] = [UploadImageInfo]()
                var selectedImage = UploadImageInfo.init()
                selectedImage.name = "image\(self.imageCount)"
                selectedImage.data = imageData
                selectedImage.image = image
                selectedImagesArray.append(selectedImage)
                self.selectedImages(selectedImages: selectedImagesArray)
            }
            self.maxSelection = self.maxSelection - assets.count
        }, completion: {
            let finish = Date()
            print(finish.timeIntervalSince(start))
        })
    }
    
    func selectedImages(selectedImages: [UploadImageInfo]) {
        
    }
    
    func clickedViaCamera(selectedImages: [UploadImageInfo]) {
        
    }
    
    func uploadVideo()
    {
        let actionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.black
        
        let cancelButton = UIAlertAction(title: getTranslate("Cancel"), style: .cancel) { _ in
            
        }
        actionSheet.addAction(cancelButton)

        let cameraButton = UIAlertAction(title: getTranslate("Camera"), style: .default)
        { _ in
            self.onCaptureVideoThroughCamera()
        }
        actionSheet.addAction(cameraButton)

        let galleryButton = UIAlertAction(title: getTranslate("Upload Video"), style: .default)
        { _ in
            self.onCapturevideoThroughGallery()
        }
        actionSheet.addAction(galleryButton)

        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []

            }
        }
        self.present(actionSheet, animated: true, completion: nil)
    }

    @objc open func onCaptureVideoThroughCamera()
    {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.view.sainiShowToast(message: "Your device has no camera")
        }
        else {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = false
            imgPicker.sourceType = .camera
            imgPicker.mediaTypes = [kUTTypeMovie as String]
            imgPicker.videoMaximumDuration = 60
            self.present(imgPicker, animated: true, completion: {() -> Void in
            })
        }
    }

    @objc open func onCapturevideoThroughGallery()
    {
        DispatchQueue.main.async {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.allowsEditing = true
            imgPicker.sourceType = .photoLibrary
            imgPicker.mediaTypes = [kUTTypeMovie as String]
            imgPicker.videoMaximumDuration = 60
            self.present(imgPicker, animated: true, completion: {() -> Void in
                
            })
        }
    }
    
    func selectedImage(choosenImage : UIImage) {
        
    }
    
    func selectedVideo(_ video : URL) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imgPicker.dismiss(animated: true, completion: {() -> Void in
        })
        if let choosenImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let croppedImage1 = compressImageView(choosenImage, to: CGSize(width: 800, height: 800))
            selectedImage(choosenImage: croppedImage1)
            self.imageCount += 1
            let imageData = compressImage(image: croppedImage1)
            
            var selectedImage = UploadImageInfo.init()
            selectedImage.name = "image\(self.imageCount)"
            selectedImage.data = imageData
            selectedImage.image = croppedImage1
            clickedViaCamera(selectedImages: [selectedImage])
            self.maxSelection = self.maxSelection - 1
            self.dismiss(animated: true) {
                
            }
        }
        else if let videoUrl : URL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            print("Video Size: \(videoUrl.fileSize())")
            if videoUrl.fileSize() > 150 {
                displayToast(message: "Videos can only be a maximum of 150mb.")
                return
            }
            if videoUrl.fileDuration() > 60 {
                displayToast(message: "Videos can only 1 minute long.")
                return
            }
            selectedVideo(videoUrl)
            self.dismiss(animated: true) {

            }
        }
        else if let res = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            res.getURL { (tempPath) in
                print("Video Size: \(tempPath!.fileSize())")
                if tempPath!.fileSize() > 150 {
                    displayToast(message: "Videos can only be a maximum of 150mb.")
                    return
                }
                if tempPath!.fileDuration() > 60 {
                    displayToast(message: "Videos can only 1 minute long.")
                    return
                }
                self.selectedVideo(tempPath!)
                self.dismiss(animated: true) {

                }
            }
        }
        else if let ref = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            print("Video Size: \(ref.fileSize())")
            if ref.fileSize() > 150 {
                displayToast(message: "Videos can only be a maximum of 150mb.")
                return
            }
            if ref.fileDuration() > 60 {
                displayToast(message: "Videos can only 1 minute long.")
                return
            }
            self.selectedVideo(ref)
            self.dismiss(animated: true) {

            }
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension PHAsset {

    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}

extension URL {
    func fileSize() -> Double {
        var fileSize: Double = 0.0
        var fileSizeValue = 0.0
        try? fileSizeValue = (self.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
        if fileSizeValue > 0.0 {
            fileSize = (Double(fileSizeValue) / (1024 * 1024))
        }
        return fileSize
    }
    
    func fileDuration() -> Int {
        let asset = AVAsset(url: self)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        return Int(durationTime)
    }
}
