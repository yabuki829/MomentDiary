//
//  ViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2021/04/13.
//



//apiKey    8d695dbd2fcbbb62629e9317d17bc366029d00a4
//spotID    1046091
import UIKit
import NendAd

class ViewController: UIViewController{
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var nadView: NADView!
    @IBOutlet weak var seachBar: UISearchBar!
    var data = [[String]]()
    var diaryModel = DiaryModel()
    var isSeach = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        seachBar.delegate = self
        tableView.layer.cornerRadius = 10
        setNavBarBackgroundColor()
        addAD()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        data = []
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
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.salmon())
        self.navigationController?.navigationBar.barTintColor = .salmon()
            self.navigationController?.navigationBar.tintColor = .white
            // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes
            = [NSAttributedString.Key.foregroundColor: UIColor.white,
               NSAttributedString.Key.font: UIFont(name: "Times New Roman", size: 15)!]
          
        }

    func alreadyCreated() {
        let alert = UIAlertController(title: "Report", message: "You can only post once a day", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .cancel, handler: { (action) -> Void in
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func convertDateToString(date:Date) -> String{
        let locale = Locale.current
        let localeId = locale.identifier
        print(localeId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
    
}



extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diaryCount =  diaryModel.readDateData().count
        if isSeach {
            print("サーチモード")
            print(data.count)
            return data.count
        }
        else{
            print("ノーマルモード")
            print(diaryCount)
            return diaryCount
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        nextVC.timeString =  diaryModel.diaryTime[indexPath.row]
        
        navigationController!.pushViewController(nextVC, animated: true)
        
        isSeach = false
        seachBar.text = ""
        seachBar.searchTextField.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let DiaryTimelabel = cell.viewWithTag(1) as! UILabel
        let DiaryContentLabel = cell.viewWithTag(2) as! UILabel
        DiaryContentLabel.text = ""
        
       
        
       
        //diaryTimeのindexpath.row番目でfilter
        if isSeach {
            DiaryTimelabel.text = data[indexPath.row][0]
            DiaryContentLabel.text = data[indexPath.row][1]
        }
        else{
            let filterDiary = data.filter { ($0.first) ==  diaryModel.diaryTime[indexPath.row]}
            DiaryTimelabel.text = diaryModel.diaryTime[indexPath.row]
            if filterDiary.last?[1] == nil {
                DiaryContentLabel.text = ""
            }
            
            DiaryContentLabel.text = filterDiary.last?[1]
           
        }
        return cell
      
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            diaryModel.deleteDiary(index:indexPath.row )
            tableView.reloadData()
        }
    }
    
}


extension ViewController:NADViewDelegate{
    func addAD(){
        //本番広告
        nadView.setNendID(1046091, apiKey: "8d695dbd2fcbbb62629e9317d17bc366029d00a4")
        //テスト広告
//        nadView.setNendID(3172, apiKey: "a6eca9dd074372c898dd1df549301f277c53f2b9")
        nadView.delegate = self
        nadView.load()
    }
}


extension ViewController :UISearchBarDelegate{

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print(searchBar.text!)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count == 0{
            
            isSeach = false
            data = diaryModel.readDiaryDate()
        }
        else{
            data = diaryModel.searchDiary(text: searchText)
            isSeach = true

            
        }
          tableView.reloadData()
    }

}
