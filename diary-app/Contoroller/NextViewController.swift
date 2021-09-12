//
//  NextViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//

import UIKit

class NextViewController: UIViewController,UITextFieldDelegate ,UINavigationControllerDelegate {
   
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //日記の内容
    var diaryText = [String]()
    //日付
    var timeString = String()
    //投稿時間
    var postTimeText = String()
    //投稿年度
    var postYearText =  String()
    
    //投稿時間と投稿内容
    public var  TimeAndDiary = [[String]]()
    
    var filterDiary = [[String]]()
    var Delete = [[String]]()

    var userDefaults = UserDefaults.standard
    
    var num = 0
    var isReverse = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        
        navigationController?.delegate = self
        self.navigationItem.title = timeString
       

        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            TimeAndDiary.append(contentsOf: TimeAndDiaryList)
            filterDiary = TimeAndDiary.filter { ($0.first) ==  timeString }
            filterDiary.reverse()
        }
        let numCount =  UserDefaults.standard.integer(forKey: "numCount")
        num = numCount
        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          self.view.endEditing(true)
        textField.resignFirstResponder()
      }
    
    

    //リターンを押したら
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        diaryText.append(textField.text!)
        TimeAndDiary.append([])
        getPostTime()
        TimeAndDiary[num].append(timeString)
        TimeAndDiary[num].append(diaryText.last!)
        TimeAndDiary[num].append(postTimeText)
        TimeAndDiary[num].append(postYearText)

        filterDiary = TimeAndDiary.filter { ($0.first) ==  timeString }
        if isReverse == false {
            filterDiary.reverse()
        }
       
        num += 1
        self.userDefaults.set(num, forKey: "numCount")
        textField.text = ""
        tableView.reloadData()
        
        return true
        
    }
   
    //セルを作成
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        let timeCelllabel = cell.viewWithTag(3) as! UILabel
        let diaryTextlabel = cell.viewWithTag(2) as! UILabel
        diaryTextlabel.text = filterDiary[indexPath.row][1]
        timeCelllabel.text = filterDiary[indexPath.row][2]
        self.userDefaults.set(TimeAndDiary, forKey: "TimeAndDiaryList")
        return cell
    }
    //投稿時間を取得してる
    func getPostTime() {
        let now = NSDate()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH時mm分"
        let date = formatter.string(from: now as Date)
        formatter.dateFormat = "yyy年"
        let date2 = formatter.string(from: now as Date)
        
        postTimeText = date
        postYearText = date2
    }

    //セルが削除されたら


    
    @IBAction func reverse(_ sender: Any) {
        isReverse =  !isReverse
        filterDiary.reverse()
        tableView.reloadData()
    }
}

extension NextViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDiary.count

    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var aa = filterDiary[indexPath.row][1]
        if aa.utf16.count > 20 {
            return  UITableView.automaticDimension
        }
        return  view.frame.height/12
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            for num in 0..<TimeAndDiary.count{
                if filterDiary[indexPath.row][1] == TimeAndDiary[num][1] {
                    
                    TimeAndDiary.remove(at: num)
                    break
                }
                else{
                    print("見つかりませんでした")
                }
            }
           
            
            filterDiary = TimeAndDiary.filter { ($0.first) ==  timeString }
            filterDiary.reverse()
            tableView.reloadData()

        
            num = num - 1

            // 追加：削除した内容を保存
            userDefaults.set(TimeAndDiary, forKey: "TimeAndDiaryList")
            userDefaults.set(num, forKey: "numCount")
        }
      
        
    }
    //セルが選択されたら
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
            self.view.endEditing(true)
        textField.resignFirstResponder()
          
       }
}

