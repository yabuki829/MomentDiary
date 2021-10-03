//
//  NextViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//

import UIKit

class NextViewController: UIViewController,UITextFieldDelegate ,UINavigationControllerDelegate {
   
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //日付
    var timeString = String()

    let postModel = PostDiaryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        navigationController?.delegate = self
        self.navigationItem.title = timeString
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        tableView.layer.cornerRadius = 10
        postModel.readDiary()
        postModel.filterDiary(date: timeString)
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
}

extension NextViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postModel.filterDiaryArray.count

    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let aa = postModel.filterDiaryArray[indexPath.row][1]
        if aa.utf16.count > 20 {
            return  UITableView.automaticDimension
        }
        return  view.frame.height/12
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)

        
        
        
        let timeCelllabel = cell.viewWithTag(3) as! UILabel
        let diaryTextlabel = cell.viewWithTag(2) as! UILabel
       
        diaryTextlabel.text = postModel.filterDiaryArray[indexPath.row][1]
        timeCelllabel.text = postModel.filterDiaryArray[indexPath.row][2]
        timeCelllabel.layer.shadowColor = UIColor.darkGray.cgColor
        timeCelllabel.layer.shadowRadius = 1
        timeCelllabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        timeCelllabel.layer.shadowOpacity = 0.5
        return cell
    }
    //セルが選択されたら
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
            textField.resignFirstResponder()
            tableView.deselectRow(at: indexPath, animated: true)
       }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            postModel.deleteSentence(row: indexPath.row, date: timeString)
            tableView.reloadData()
           
        }
    }
}




