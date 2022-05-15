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
    var diarydata = diaryV2(id: "", created: Date(), title: "", diary: nil)
    var index = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        setNavBarBackgroundColor()
        //diaryDataのタイトルを表示する
        if diarydata.title == ""{
            navigationItem.title  = diarydata.created.covertString()
        }
        else{
            navigationItem.title = diarydata.title
        }
       
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
    
    @IBAction func setDiaryTitle(_ sender: Any) {
       alert()
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
    func setting(){
        tableView.keyboardDismissMode = .none
        tableView.contentInsetAdjustmentBehavior = .never
     
        
        tableView.delegate = self
        tableView.dataSource = self
        
        textField.delegate = self
        textField.becomeFirstResponder()
        textField.borderStyle = .roundedRect
        
        navigationController?.delegate = self
        self.navigationItem.title =  diarydata.created.covertString()
    }
    func setNavBarBackgroundColor(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        return diarydata.diary!.count

    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aa = diarydata.diary![indexPath.row].text
        if aa.utf16.count > 20  || diarydata.diary![indexPath.row].image!.isEmpty == false {
            return  UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            textField.resignFirstResponder()
            return true
        }
        let data = diaryData(id: diaryModel.generateID(5), date: Date(), text: textField.text!, image: Data())
        diarydata.diary!.append(data)
        
        var array = diaryModel.readV2()
        array[index].diary = diarydata.diary
        diaryModel.save(data: array)
        
        textField.text = ""
        tableView.reloadData()
        
        let indexPath = IndexPath(row: diarydata.diary!.count - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
        return true
    }
    //セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if diarydata.diary![indexPath.row].image!.isEmpty == false{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            let imageView = cell.viewWithTag(1) as! UIImageView
           
            let image_data = diarydata.diary![indexPath.row].image
            imageView.image = UIImage(data: image_data!)?.resized(toWidth: view.bounds.size.width)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
            cell.selectionStyle = .none
            let timeCelllabel = cell.viewWithTag(3) as! UILabel
            let diaryTextlabel = cell.viewWithTag(2) as! UILabel
           
            if indexPath.row == 0 {
                
                
                diaryTextlabel.text = diarydata.diary![indexPath.row].text
                timeCelllabel.text = diarydata.diary![indexPath.row].date.convert_short()
                return cell
            }
            else{
                let timeA = diarydata.diary![indexPath.row].date.convert_short()
                let timeB = diarydata.diary![indexPath.row - 1].date.convert_short()
                if timeA == timeB{
                    
                    //一個前の投稿時間と同じなら時間を表示しない
                    diaryTextlabel.text = diarydata.diary![indexPath.row].text
                    timeCelllabel.text = ""
                    return cell
                }
                else{
                    diaryTextlabel.text = diarydata.diary![indexPath.row].text
                    timeCelllabel.text = diarydata.diary![indexPath.row].date.convert_short()
                    return cell
                }
                
            }
            
        }

        
    }
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
            textField.resignFirstResponder()
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            diarydata.diary!.remove(at: indexPath.row)
            var data = diaryModel.readV2()
            data[index].diary = diarydata.diary
            diaryModel.save(data: data)
            tableView.reloadData()
           
        }
    }
    
    func alert(){
        let alert = UIAlertController(title: "日記のタイトルを決める", message: "", preferredStyle: .alert)
                var alertTextField: UITextField?
                alert.addTextField { (textField) in
                    alertTextField = textField
                    let text =  self.diarydata.title
                    alertTextField?.text = text
                    textField.placeholder = "タイトル"
                 }
             
                
                 
            let selectAction = UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
                    
                var array = diaryModel.readV2()
                array[index].title = (alertTextField?.text)!
                navigationItem.title = alertTextField?.text
                if alertTextField?.text == ""{
                    navigationItem.title = diarydata.created.covertString()
                    array[index].title = ""
                }
                
                
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { [self] _ in
                navigationItem.title = diarydata.created.covertString()
                var array = diaryModel.readV2()
                array[index].title = ""
            })

                 alert.addAction(selectAction)
                 alert.addAction(cancelAction)

                 present(alert, animated: true)
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
                diarydata.diary?.append(a)
            }
            else{
                let a = diaryData(id: diaryModel.generateID(8), date: Date(), text: textField.text ?? "画像", image: photo.convert_data(image))
                diarydata.diary?.append(a)
            }
           
            var array = diaryModel.readV2()
            array[index].diary = diarydata.diary
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
        picker.dismiss(animated: true, completion:nil )
    }
}

