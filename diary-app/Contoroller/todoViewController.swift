//
//  todoViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/28.
//

import UIKit

class todoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let userDefaults = UserDefaults.standard
    var dreamList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        if let dream = userDefaults.array(forKey: "dreamList") as? [String] {
            dreamList.append(contentsOf: dream)
            }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cometrueButton(_ sender: Any) {
        let alertController = UIAlertController(title: "絶対に叶える夢を入力してください。", message: "-----------注意-----------\n1.宣言した夢は絶対に取り消すことはできません。", preferredStyle: UIAlertController.Style.alert)
           alertController.addTextField(configurationHandler: nil)
           let okAction = UIAlertAction(title: "叶える", style: UIAlertAction.Style.default) { (acrion: UIAlertAction) in
               // 追加：OKをタップした時の処理
               if let textField = alertController.textFields?.first {
                if textField.text?.isEmpty == true  {
                        return
                }
                self.dreamList.append(textField.text!)
                print(self.dreamList)
                self.tableView.reloadData()
                self.userDefaults.set(self.dreamList, forKey: "dreamList")
               }
           }
           alertController.addAction(okAction)
           let cancelButton = UIAlertAction(title: "今はやめておく", style: UIAlertAction.Style.cancel, handler: nil)
           alertController.addAction(cancelButton)
           present(alertController, animated: true, completion: nil)
    }
    

  
}

extension todoViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dreamList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dreamCell", for: indexPath)
        let dreamLabel = cell.viewWithTag(1) as! UILabel
        
        dreamLabel.text = "\(indexPath.row + 1). \( dreamList[indexPath.row])"
       
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return view.frame.height/12
     }
}
