//
//  ViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//

import UIKit


class ViewController: UIViewController{
    
    
    @IBOutlet var tableView: UITableView!
    var data = [[String]]()
    var diaryModel = DiaryModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//                 let appDomain = Bundle.main.bundleIdentifier
//                 UserDefaults.standard.removePersistentDomain(forName: appDomain!)

        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white,
               NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
        tableView.layer.cornerRadius = 10
        diaryModel.readDateData()
        tableView.reloadData()
      
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = diaryModel.readDiaryDate()
        tableView.reloadData()
    }
    
    //createDiaryという名前の方がいいかも
    @IBAction func diarytimeButton(_ sender: Any) {
        let date = diaryModel.getDate()
        //日記を作成する。一度作成されていたらアラートを出す
        let doAlertCheck: Bool = diaryModel.saveDate(saveData: date)
        
        if doAlertCheck {
            alreadyCreated()
        }
        tableView.reloadData()
        
    }
    
    
    
    @IBAction func reverse(_ sender: Any) {
        diaryModel.isTurn = !diaryModel.isTurn
        diaryModel.diaryTime.reverse()  
        tableView.reloadData()
    }
    func alreadyCreated() {
        let alert = UIAlertController(title: "報告", message: "1日1度しか作成できません", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) -> Void in
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}



extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryModel.diaryTime.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        nextVC.timeString =  diaryModel.diaryTime[indexPath.row]
        
        navigationController!.pushViewController(nextVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    
        
        
        
        
        
        
        let DiaryTimelabel = cell.viewWithTag(1) as! UILabel
        DiaryTimelabel.text =  diaryModel.diaryTime[indexPath.row]
        
        let DiaryContentLabel = cell.viewWithTag(2) as! UILabel
        //diaryTimeのindexpath.row番目でfilter
        
        let filterDiary = data.filter { ($0.first) ==  diaryModel.diaryTime[indexPath.row]}
        
        if filterDiary.last?[1] == nil {
            print("呼ばれました")
            DiaryContentLabel.text = ""
        }
        
        DiaryContentLabel.text = filterDiary.last?[1]
        return cell
    }
    
}




