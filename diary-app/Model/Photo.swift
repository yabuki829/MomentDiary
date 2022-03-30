//
//  Photo.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2022/03/22.
//

import Foundation
import Photos
import UIKit

class Photo {
    
    var imageArray = [NSData]()
    let userdefalts = UserDefaults.standard
    func checkPermission(){
           let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

           switch photoAuthorizationStatus {
               case .authorized:
                   print("auth")
               case .notDetermined:
                   PHPhotoLibrary.requestAuthorization({
                       (newStatus) in
                       print("status is \(newStatus)")
                       if newStatus ==  PHAuthorizationStatus.authorized {
                           /* do stuff here */
                           print("success")
                       }
                   })
                   print("not Determined")
               case .restricted:
                   print("restricted")
               case .denied:
                   print("denied")
           case .limited:
                print("limit")
           @unknown default:
                print("defalts")
           }
       }
    func saveImage(image:UIImage){
        let data = image.pngData() as NSData?
        print("何バイト？　",data!.count)
    
            if let imageData = data {
                imageArray.append(imageData)
                userdefalts.set(imageArray, forKey: "image")
            }
    }
    func getImage() -> [NSData]{
        if let image = userdefalts.object(forKey: "image"){
            imageArray = image as! [NSData]
            return imageArray
        }
        return [NSData]()
    }
  
}

