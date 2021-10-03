import UIKit

class DiaryModel{
    var alertController: UIAlertController!
    let userDefaults = UserDefaults.standard
    var diaryTime = [String]()
    var isTurn = false
    
    
    var data = [[String]]()
    
    func getDate() ->String{
       
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyy年MM月dd日(eee)"
        let date = formatter.string(from: NSDate() as Date)
        return date
    }
    
    
    func saveDate(saveData:String) -> Bool{

        if isTurn {
            if saveData != diaryTime.first{
                diaryTime.insert(saveData, at: 0)
                userDefaults.set(diaryTime, forKey: "diaryList")
                print("完了")

                return false
            }
            else{
                //trueの場合アラートを出す
               return true
            }
        }else{
            if saveData == diaryTime.first{
                return true
            }
            else{
                diaryTime.append(saveData)
                userDefaults.set(diaryTime, forKey: "diaryList")
                  
                print("完了")
                return false
            }
        }
      
       
    }
    func readDateData() {
        if let diaryList = userDefaults.array(forKey: "diaryList") as? [String] {
            diaryTime.append(contentsOf: diaryList)
        }
    }
    
    func readDiaryDate() -> [[String]] {
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            data = []
            data.append(contentsOf: TimeAndDiaryList)
        }
        return data
    }
    
}




