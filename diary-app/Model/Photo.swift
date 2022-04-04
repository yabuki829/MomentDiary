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
    
    var imageArray = [Data]()
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
        let data = image.pngData() as Data?
        print("何バイト？　",data!.count)
    
            if let imageData = data {
                imageArray.append(imageData)
                userdefalts.set(imageArray, forKey: "image")
            }
    }
    func save(array:[Data]){
        userdefalts.set(array, forKey: "image")
    }
    func getImage() -> [Data]{
        if let image = userdefalts.object(forKey: "image"){
            imageArray = image as! [Data]
            return imageArray
        }
        return [Data]()
    }
  
}

