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
    var data = [diaryV2]()
    var diaryModel = Diary()
    var isSeach = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        seachBar.delegate = self
        seachBar.setShowsCancelButton(false, animated: true)
        tableView.layer.cornerRadius = 10
        setNavBarBackgroundColor()
//        addAD()
//        setting()
        changeDiaryData()
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = []
        data = diaryModel.readV2()
        tableView.reloadData()
    }
    

    //createDiaryという名前の方がいいかも
    @IBAction func diarytimeButton(_ sender: Any) {
        diaryModel.create()
        data = diaryModel.readV2()
        tableView.reloadData()
        if data.count > 0 {
            let indexPath = IndexPath(row: data.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
       
    }
    
    
    func changeDiaryData(){
        //構造が古いやつだったら変更する
        let data = diaryModel.read()
        print("データ構造の変更をします")
        if data.isEmpty == false{
            print("データ構造の変更を開始します")
            var newData = [diaryV2]()
            for i in 0..<data.count{
                print("変更中",i+1,"回目")
                let a = diaryV2(id:data[i].id, created: data[i].created, title: "", diary: data[i].diary)
                newData.append(a)
            }
            
            diaryModel.save(data: newData)
            self.data = newData
            tableView.reloadData()
            print("終了しました。")
            
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

        seachBar.searchTextField.inputAccessoryView = toolbar
        seachBar.inputAccessoryView = toolbar

    }
    @objc func didTapDoneButton() {
        seachBar.searchTextField.resignFirstResponder()
        seachBar.setShowsCancelButton(false, animated: true)
     }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar){
        searchBar.setShowsCancelButton(true, animated: true)
    }

    // キャンセルボタンでキャセルボタン非表示
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}



extension ViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diaryCount =  diaryModel.readV2().count
        if isSeach {
            print("サーチモード")
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
        tableView.deselectRow(at: indexPath, animated: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        nextVC.diarydata = data[indexPath.row]
        nextVC.index = indexPath.row
        navigationController!.pushViewController(nextVC, animated: true)

        isSeach = false
        seachBar.text = ""
        seachBar.searchTextField.resignFirstResponder()

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        print(indexPath.row)
        let DiaryTimelabel = cell.viewWithTag(1) as! UILabel
        let DiaryContentLabel = cell.viewWithTag(2) as! UILabel
       
        
        if isSeach {
            DiaryTimelabel.text = data[indexPath.row].created.covertString()
            DiaryContentLabel.text = data[indexPath.row].diary![0].text
        }
        else{
            
            DiaryTimelabel.text = data[indexPath.row].created.covertString()
            
            if data[indexPath.row].title == "" {
                DiaryContentLabel.text = data[indexPath.row].diary?.last?.text
            }
            else{
                DiaryContentLabel.text = data[indexPath.row].title
            }
           

           
        }
        return cell
      
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            diaryModel.deleteDiary(id: data[indexPath.row].id)
            data = diaryModel.readV2()
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
            data = diaryModel.readV2()
        }
        else{
            data = diaryModel.search(text: searchText)
            isSeach = true

            
        }
          tableView.reloadData()
    }

}
