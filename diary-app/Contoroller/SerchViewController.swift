//
//  SerchViewController.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2022/01/03.
//

import UIKit
import RxCocoa
import RxSwift
import NendAd

class SerchViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var nadView: NADView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    let disposeBag = DisposeBag()
    let diaryModel = DiaryModel()
    var searchDiaryArray = [[String]]()
    var searchText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    func setting(){
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    @objc func textFieldDidChange(sender: UITextField) {
        searchTextField.rx.text
            .debounce(.milliseconds(500), scheduler:  MainScheduler.instance)
            .subscribe(onNext: { [self]_ in
                searchText = String(searchTextField.text!)
                searchDiaryArray =  diaryModel.searchDiary(text: searchText)
                tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
}

extension SerchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDiaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let DiaryTimelabel = cell.viewWithTag(1) as! UILabel
        let DiaryContentLabel = cell.viewWithTag(2) as! UILabel
        DiaryTimelabel.text = searchDiaryArray[indexPath.row][0]
        DiaryContentLabel.text = searchDiaryArray[indexPath.row][1]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "next") as! NextViewController
        nextVC.timeString =  searchDiaryArray[indexPath.row][0]
        
        navigationController!.pushViewController(nextVC, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}



