//
//  UploadFileModel.swift
//  HkConcept
//
//  Created by MacOs14 on 14/09/19.
//  Copyright © 2019 MayurMacmini. All rights reserved.
//

import UIKit

class UploadFileModel: NSObject {
    
    var strTitle : String?
    var attachmentName : String?
    var fileSize  : String?
    var fileType : String?
    var fileExtension : String?
    var filepath : String?
    var fileUrl : String?
    var image : UIImage?
    var fileSizeDouble : Double?
    
    override init() {
        
    }    
    
    class func getModel(fileUrl : String? = nil,image: UIImage? = nil) -> UploadFileModel {
        
        let model = UploadFileModel()
        model.filepath = fileUrl
        model.image = image
        
        return model
    }

        func toJson() -> [[String : Any]] {
            return [["strTitle" : strTitle, "attachmentName" : attachmentName, "fileSize" : fileSize, "fileType" : fileType, "fileExtension" : fileExtension, "filepath" : filepath, "fileUrl" : fileUrl, "image" : image, "fileSizeDouble" : fileSizeDouble]];
        }
}
