//
//  ViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//

import UIKit


class ViewController: UIViewController{
    
    
    @IBOutlet var tableView: UITableView!
    
    var diaryTime = [String]()
    
    let userDefaults = UserDefaults.standard
    
    var  filterYear = [[[String]]]()
    var isTurn = false
    var TimeAndDiary = [[String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let appDomain = Bundle.main.bundleIdentifier
        // UserDefaults.standard.removePersistentDomain(forName: appDomain!)

        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        //データの読み込み
        if let diaryList = userDefaults.array(forKey: "diaryList") as? [String] {
            diaryTime.append(contentsOf: diaryList)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            TimeAndDiary = []
            TimeAndDiary.append(contentsOf: TimeAndDiaryList)
            tableView.reloadData()
        }
        tableView.reloadData()
    }
    
    @IBAction func diarytimeButton(_ sender: Any) {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyy年MM月dd日(eee)"
        let date = formatter.string(from: now as Date)
        
        if isTurn {
            if date != diaryTime.first{
                diaryTime.insert(date, at: 0)
                self.userDefaults.set(self.diaryTime, forKey: "diaryList")
                tableView.reloadData()
            }else {
                alert()
            }
        }
        
        else{
            if date != diaryTime.last {
                diaryTime.append(date)
                self.userDefaults.set(self.diaryTime, forKey: "diaryList")
                tableView.reloadData()
                
            }else{
                alert()
            }
        }
        
    }
    
    
    

    @IBAction func reverse(_ sender: Any) {
       
        diaryTime.reverse()
        isTurn = !isTurn
        print(isTurn)
        tableView.reloadData()
    }
    func alert() {
        let alert = UIAlertController(title: "報告", message: "今日のメモ日記は既に作成済み", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) -> Void in
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }    
    
}



extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaryTime.count
    }
    //大きさ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height/10
    }
    //タップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        nextVC.timeString = diaryTime[indexPath.row]
        
        navigationController!.pushViewController(nextVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //セルを作る
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let DiaryTimelabel = cell.viewWithTag(1) as! UILabel
        DiaryTimelabel.text = diaryTime[indexPath.row]
        
        let DiaryContentLabel = cell.viewWithTag(2) as! UILabel
        //diaryTimeのindexpath.row番目で検索する
        
        let filterDiary = TimeAndDiary.filter { ($0.first) ==  diaryTime[indexPath.row]}
        
        if filterDiary.last?[1] == nil {
            print("呼ばれました")
            DiaryContentLabel.text = ""
        }
        
        DiaryContentLabel.text = filterDiary.last?[1]
        
        
        
        return cell
    }
    
}
