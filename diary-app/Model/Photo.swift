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
 
    func convert_data(_ image:UIImage) -> Data{
        let data = image.pngData() as Data?
        
        return data!
    }
}

