//
//  DocumentPickerHelper.swift
//  Bank2Grow
//
//  Created by Vish on 19/05/18.
//  Copyright © 2018 Coruscate. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos

class DocumentPickerHelper: NSObject{
    
    static let sharedInstance = DocumentPickerHelper()
    var model = UploadFileModel()
    var isDocumentGet : ((_ image : UIImage? , _ dictInfo : UploadFileModel) -> ())?
    var dictData = [String:Any]()
    
    var themeColor : UIColor = UIColor.black
    
    class func getRootController() -> UIViewController {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    func openImagePicker(){
        DocumentPickerHelper.open_galley_or_camera(delegate: self,mediaType: ["public.image"])
    }
    
    func openVideoPicker(){
        DocumentPickerHelper.openVideoPicker(delegate: self)
    }    
    
    func openDocumentPicker(){
        
        let alert = UIAlertController(title: "Pick Document", message: "Choose option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Pick Image", style: .default, handler: { (alert) in            
            DocumentPickerHelper.open_galley_or_camera(delegate: self,mediaType: ["public.image"])
        }))
        
        alert.addAction(UIAlertAction(title: "Pick Document from Files", style: .default, handler: { (alert) in
            
            let types = [String(kUTTypePDF), String(kUTTypeJPEG), String(kUTTypePNG)]
            let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
            documentPicker.delegate = self
            DocumentPickerHelper.getRootController().present(documentPicker, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (alert) in
            
        }))
        
        alert.popoverPresentationController?.sourceView = DocumentPickerHelper.getRootController().view
        DocumentPickerHelper.getRootController().present(alert, animated: true, completion: nil)
    }
    
    //MARK: Imagepicker controller
    class func open_galley_or_camera(delegate : UIImagePickerControllerDelegate,mediaType:[String], sender:UIView = DocumentPickerHelper.getRootController().view){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose option", message: nil, preferredStyle: UI_USER_INTERFACE_IDIOM() == .pad ? .alert : .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            
            if(  UIImagePickerController.isSourceTypeAvailable(.camera))
            {
                let myPickerController = UIImagePickerController()
                myPickerController.navigationBar.isTranslucent = false
                myPickerController.navigationBar.barTintColor = DocumentPickerHelper.sharedInstance.themeColor // Background color
                myPickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
                myPickerController.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor : UIColor.white
                ]
                
                let BarButtonItemAppearance = UIBarButtonItem.appearance()
                
                BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
                BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
                myPickerController.delegate = (delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                myPickerController.sourceType = .camera
                myPickerController.mediaTypes = mediaType
                DocumentPickerHelper.getRootController().present(myPickerController, animated: true, completion: nil)
            }
            else
            {
                let actionController: UIAlertController = UIAlertController(title: "Camera is not available", message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void     in
                    //Just dismiss the action sheet
                }
                
                actionController.addAction(cancelAction)
                actionController.popoverPresentationController?.sourceView = sender
                DocumentPickerHelper.getRootController().present(actionController, animated: true, completion: nil)
                
            }
        }
        actionSheetController.addAction(takePictureAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = (delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate);
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = mediaType
            
            myPickerController.navigationBar.barTintColor = DocumentPickerHelper.sharedInstance.themeColor // Background color
            myPickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
            myPickerController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            
            let BarButtonItemAppearance = UIBarButtonItem.appearance()
            
            BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
            
            DocumentPickerHelper.getRootController().present(myPickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        actionSheetController.popoverPresentationController?.sourceView = sender
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100);

        //Present the AlertController
        DocumentPickerHelper.getRootController().present(actionSheetController, animated: true, completion: nil)        
    }    
    
    //MARK: VideoPicker controller
    class func openVideoPicker(delegate : UIImagePickerControllerDelegate){
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Choose option", message: nil, preferredStyle: .actionSheet)
        actionSheetController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 100, height: 100);

        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title:"Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            if(  UIImagePickerController.isSourceTypeAvailable(.camera))
                
            {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = (delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                myPickerController.sourceType = .camera
                myPickerController.mediaTypes = [kUTTypeMovie as String]
                myPickerController.navigationBar.barTintColor = DocumentPickerHelper.sharedInstance.themeColor // Background color
                myPickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
                myPickerController.navigationBar.titleTextAttributes = [
                    NSAttributedString.Key.foregroundColor : UIColor.white
                ]
                
                let BarButtonItemAppearance = UIBarButtonItem.appearance()
                
                BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
                BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
                DocumentPickerHelper.getRootController().present(myPickerController, animated: true, completion: nil)
            }
            else
            {
                let actionController: UIAlertController = UIAlertController(title: "Camera is not available", message: "", preferredStyle: .alert)
                let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void     in
                    //Just dismiss the action sheet
                }
                
                actionController.addAction(cancelAction)
                actionController.popoverPresentationController?.sourceView = DocumentPickerHelper.getRootController().view
                DocumentPickerHelper.getRootController().present(actionController, animated: true, completion: nil)
                
            }
        }
        actionSheetController.addAction(takePictureAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose From Gallery", style: .default) { action -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = (delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate);
            myPickerController.sourceType = .photoLibrary
            myPickerController.mediaTypes = [kUTTypeMovie as String]
            myPickerController.navigationBar.barTintColor = DocumentPickerHelper.sharedInstance.themeColor // Background color
            myPickerController.navigationBar.tintColor = UIColor.white // Cancel button ~ any UITabBarButton items
            myPickerController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
            
            let BarButtonItemAppearance = UIBarButtonItem.appearance()
            
            BarButtonItemAppearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            BarButtonItemAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
            DocumentPickerHelper.getRootController().present(myPickerController, animated: true, completion: nil)
        }
        actionSheetController.addAction(choosePictureAction)
        
        //Present the AlertController
        actionSheetController.popoverPresentationController?.sourceView = DocumentPickerHelper.getRootController().view
        DocumentPickerHelper.getRootController().present(actionSheetController, animated: true, completion: nil)
        
    }
}


extension DocumentPickerHelper : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)    
        model = UploadFileModel()
        
//        if let pickedImage = info[.originalImage] as? UIImage {
//            model.image = pickedImage
//            if let documentPicked = isDocumentGet {
//                documentPicked(pickedImage , model)
//            }
//        }
        
        do {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let data = image.jpegData(compressionQuality: 0.7)!

                var imageName = "test.jpeg"
                if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL {
                    imageName = imageURL.lastPathComponent!
                }
                
                let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
                let localPath = URL(fileURLWithPath: documentDirectory.appending("/\(imageName)"))
                try data.write(to: localPath)
                model.fileUrl = localPath.path
                
                if let documentPicked = isDocumentGet {
                    documentPicked(nil , model)
                }
            }
        }
        catch {
            
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        self.fetchLastImage { (value) in
            model = UploadFileModel()
            model.fileType = "image"
            model.fileSize = "\(DocumentPickerHelper.toDouble(value: image.sizePerMB())) MB"
            model.attachmentName = value?.fileName()
            model.fileExtension = value?.fileExtension()
            model.fileSizeDouble = image.sizePerMB()
            
            if let documentPicked = isDocumentGet {
                documentPicked(image , model)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension DocumentPickerHelper : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let myURL = url as URL
        
        let size =  DocumentPickerHelper.toDouble(value: myURL.sizePerMB())
        
        model = UploadFileModel()
        
        model.fileType = "PDF"
        model.fileSize = "\(size) MB"
        model.attachmentName = (myURL.absoluteString as NSString).lastPathComponent
        model.fileUrl = myURL.path
        model.fileExtension = myURL.pathExtension
        model.fileSizeDouble = myURL.sizePerMB()
        
        if let documentPicked = isDocumentGet {
            documentPicked(nil , model)
        }
    }
    
    class func toDouble(value : Double) -> String{
        
        //let disValue = dis.toDouble()
        let disValue = String(format: "%0.2f",value)
        if disValue != "0.0" && disValue != "0.00"{
            
            return "\(disValue)"
        }
        
        return "-"
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension DocumentPickerHelper{
    func fetchLastImage(completion: (_ localIdentifier: String?) -> Void)
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if (fetchResult.firstObject != nil)
        {
            let lastImageAsset: PHAsset? = fetchResult.firstObject
            completion(lastImageAsset?.localIdentifier)
        }
        else
        {
            completion(nil)
        }
    }
}

extension URL{
    
    func sizePerMB() -> Double {
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: self.path)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return size.doubleValue / 1000000.0
            }
        } catch {
            print("Error: \(error)")
        }
        return 0.0
    }
    
    func convertToBase64() -> String? {
        
        do {
            let fileData = try Data (contentsOf: self)
            let imageString = fileData.base64EncodedString ()
            return imageString
            
        } catch let error as NSError {
            print(error)
        }
        return nil
    }
}

extension UIImage {
    
    func sizePerMB() -> Double {
        
        let image = self
        let imgData: NSData = NSData(data: image.jpegData(compressionQuality: 1) ?? Data())
        
        let imageSize: Int = imgData.length
        let size =  (Double(imageSize) / 1024.0)/1024.0
        return size
    }
    
    public func convertToBase64(formats: String) -> String? {
        var imageData: Data?
        
        if formats == "PNG" || formats == "png" {
            imageData = self.pngData()
        }
        else if formats == "JPEG" || formats == "JPG" || formats == "jpeg" || formats == "jpg"{
            imageData = self.jpegData(compressionQuality: 0.5)
        }
        return imageData?.base64EncodedString()
    }
}

extension String {
    
    func fileExtension() -> String {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
    
    func fileName() -> String {
        
        if let fileNameWithoutExtension = NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent {
            return fileNameWithoutExtension
        } else {
            return ""
        }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
