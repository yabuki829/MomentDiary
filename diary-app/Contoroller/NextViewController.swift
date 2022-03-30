//
//  NextViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//

import UIKit
import NendAd

class NextViewController: UIViewController,UITextFieldDelegate ,UINavigationControllerDelegate{
   
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nadView: NADView!
    //日付
    var timeString = String()
    let postModel = PostDiaryModel()
    let photo = Photo()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        navigationController?.delegate = self
        self.navigationItem.title = timeString
        setNavBarBackgroundColor()
        postModel.readDiary()
        postModel.filterDiary(date: timeString)
        setting()
        addAD()
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
        textField.resignFirstResponder()
      }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
       }
    @IBAction func reverse(_ sender: Any) {
        postModel.isTurn = !postModel.isTurn
        postModel.filterDiaryArray.reverse()
        tableView.reloadData()
    }
    
    @IBAction func selectImage(_ sender: Any) {
        //画像ライブラリーを開く
        
        photo.checkPermission()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.salmon())
        self.navigationController?.navigationBar.barTintColor = .salmon()
            self.navigationController?.navigationBar.tintColor = .white
            // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        }
    func setting(){
        let toolbar = UIToolbar()
        //完了ボタンを右寄せにする為に、左側を埋めるスペース作成
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                          target: nil,
                                          action: nil)
        let done = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapDoneButton))
        //toolbarのitemsに作成したスペースと完了ボタンを入れる。実際にも左から順に表示される。
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        textField.inputAccessoryView = toolbar

    }
    @objc func didTapDoneButton() {
        textField.resignFirstResponder()
     }
    func deleteAlert(){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) -> Void in
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension NextViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.filterDiaryArray.count

    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aa = postModel.filterDiaryArray[indexPath.row][1]
        if aa.utf16.count > 20  || postModel.filterDiaryArray[indexPath.row][2] == "画像" {
            return  UITableView.automaticDimension
        }
        return  view.frame.height/12
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            textField.resignFirstResponder()
            return true
        }
        let time = postModel.getPostTime()
        postModel.postDiary(time: time, date: timeString, diary: textField.text!)
        textField.text = ""
        tableView.reloadData()
        
        return true
    }
    //セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if postModel.filterDiaryArray[indexPath.row][2] == "画像"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            cell.backgroundColor = .black
            let imageView = cell.viewWithTag(1) as! UIImageView
            let i = Int(postModel.filterDiaryArray[indexPath.row][3])
            imageView.image = UIImage(data: photo.getImage()[i ?? 0] as Data)?.resized(toWidth: view.bounds.size.width)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            let timeCelllabel = cell.viewWithTag(3) as! UILabel
            let diaryTextlabel = cell.viewWithTag(2) as! UILabel
           
            diaryTextlabel.text = postModel.filterDiaryArray[indexPath.row][1]
            timeCelllabel.text = postModel.filterDiaryArray[indexPath.row][2]
            return cell
        }

        
    }
    //セルが選択されたら
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: true)
        if postModel.filterDiaryArray[indexPath.row][2] == "画像"{
            print("画像")
        }
        else{
        
            print("日記")
        }
          
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            postModel.deleteSentence(row: indexPath.row, date: timeString)
            tableView.reloadData()
           
        }
    }
}





extension NextViewController:NADViewDelegate{
    func addAD(){
        //本番広告
        nadView.setNendID(1046091, apiKey: "8d695dbd2fcbbb62629e9317d17bc366029d00a4")
        //テスト広告
//        nadView.setNendID(3172, apiKey: "a6eca9dd074372c898dd1df549301f277c53f2b9")
        nadView.delegate = self
        nadView.load()
    }
}


extension NextViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            
            photo.saveImage(image: image)
            let i = photo.getImage().count - 1
            postModel.postDiaryWithImage(date:timeString, title: textField.text!, imgInt: String(i))
            textField.text = ""
            tableView.reloadData()
            
        }
        else{
            print("画像の取得に失敗しました")
        }
        picker.dismiss(animated: true, completion:nil )
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("キャンセル")
        picker.dismiss(animated: true, completion:nil )
    }
}

