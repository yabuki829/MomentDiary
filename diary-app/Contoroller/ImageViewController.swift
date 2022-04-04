//
//  ImageViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2022/04/04.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
     
    }


}


extension ImageViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photo.getImage().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        cell.selectionStyle = .none
        imageView.image = UIImage(data: photo.getImage()[indexPath.row] as Data)?.resized(toWidth: view.bounds.size.width)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == UITableViewCell.EditingStyle.delete {
//            var imageArray = photo.getImage()
//            imageArray[indexPath.row] = Data()
//            photo.save(array: imageArray)
//            tableView.reloadData()
//
//        }
//    }
    
    
}
