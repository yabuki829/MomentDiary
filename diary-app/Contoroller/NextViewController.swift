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
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nadView: NADView!
    @IBOutlet weak var stackViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    //日付
    var timeString = String()
    let diaryModel = Diary()
    let photo = Photo()
    var diaryArray = diary(id: String(), created: Date(), diary: [diaryData]())
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        navigationController?.delegate = self
        self.navigationItem.title =  diaryArray.created.covertString()
        setNavBarBackgroundColor()
        tableView.keyboardDismissMode = .none
        tableView.contentInsetAdjustmentBehavior = .never
        textField.becomeFirstResponder()
        textField.borderStyle = .roundedRect
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
          self,
          selector:#selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
    }
    @objc func keyboardWillShow(_ notification: Notification) {
      
            let info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.stackViewBottomConstraint.constant = keyboardFrame.size.height - self.stackView.frame.size.height
                self.tableViewBottomConstraint.constant = keyboardFrame.size.height
               
                
            })
        
    }
 
    @objc private func keyboardWillHide(_ notification: Notification) {
     //キーボードが閉じたときの処理
        stackViewBottomConstraint.constant = 0
        tableViewBottomConstraint.constant = 0
    }
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
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
        return diaryArray.diary!.count

    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aa = diaryArray.diary![indexPath.row].text
        if aa.utf16.count > 20  || diaryArray.diary![indexPath.row].image!.isEmpty == false {
            return  UITableView.automaticDimension
        }
        return  view.frame.height/12
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            textField.resignFirstResponder()
            return true
        }
        let data = diaryData(id: diaryModel.generateID(5), date: Date(), text: textField.text!, image: Data())
        diaryArray.diary!.append(data)
        
        var array = diaryModel.read()
        array[index].diary = diaryArray.diary
        diaryModel.save(data: array)
        
        textField.text = ""
        tableView.reloadData()
        
        return true
    }
    //セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diaryArray.diary![indexPath.row].image!.isEmpty == false{
            print("画像")
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            let imageView = cell.viewWithTag(1) as! UIImageView
           
            let image_data = diaryArray.diary![indexPath.row].image
            imageView.image = UIImage(data: image_data!)?.resized(toWidth: view.bounds.size.width)
            return cell
        }
        else{
            print(diaryArray.diary![indexPath.row].text)
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            cell.selectionStyle = .none
            let timeCelllabel = cell.viewWithTag(3) as! UILabel
            let diaryTextlabel = cell.viewWithTag(2) as! UILabel
           
            diaryTextlabel.text = diaryArray.diary![indexPath.row].text
            timeCelllabel.text = diaryArray.diary![indexPath.row].date.convert_short()
            return cell
        }

        
    }
    //セルが選択されたら
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
            textField.resignFirstResponder()
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            diaryArray.diary!.remove(at: indexPath.row)
            var data = diaryModel.read()
            data[index].diary = diaryArray.diary
            diaryModel.save(data: data)
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
            
            if textField.text == ""{
                let a = diaryData(id: diaryModel.generateID(8), date: Date(), text: "画像", image: photo.convert_data(image))
                diaryArray.diary?.append(a)
            }
            else{
                let a = diaryData(id: diaryModel.generateID(8), date: Date(), text: textField.text ?? "画像", image: photo.convert_data(image))
                diaryArray.diary?.append(a)
            }
           
           

            var array = diaryModel.read()
            array[index].diary = diaryArray.diary
            diaryModel.save(data: array)
            
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

