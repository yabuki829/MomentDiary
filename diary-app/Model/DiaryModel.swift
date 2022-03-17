import UIKit

class DiaryModel{
    let userDefaults = UserDefaults.standard
    //日付が入ってる
    var diaryTime = [String]()
    var dateArray = [Date]()
    var isTurn = false
    
    // [["2021年10月31日(日)", "ハロウィーン", "14:15"],
//       ["2021年11月02日(火)", "一瞬で日記が書ける", "14:16"],
//       ["2021年11月02日(火)", "だから三日坊主にならない", "14:16"]]
    var data = [[String]]()
    
    func getDate() ->String{
        let locale = Locale.current
        let localeId = locale.identifier
        if localeId == "ja_US"{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyy年MM月dd日(eee)"
            let date = formatter.string(from: NSDate() as Date)
            return date
        }
        else if localeId == "ja_JP"{
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.dateFormat = "yyy年MM月dd日(eee)"
            let date = formatter.string(from: NSDate() as Date)
            return date
        }
        else{
            return convertDateToString(date: Date())
        }
    }
    func convertDateToString(date:Date) -> String{
        let locale = Locale.current
        let localeId = locale.identifier
        print(localeId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
    func convertShortString(date:Date) -> String{
        let locale = Locale.current
        let localeId = locale.identifier
        print(localeId)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
    func saveDate(saveData:String) -> Bool{
        for i in 0..<diaryTime.count{
            if diaryTime[i] == saveData{
                return true
            }
        }
        if isTurn{
            diaryTime.insert(saveData, at: 0)
            userDefaults.set(diaryTime, forKey: "diaryList")
        }
        else{
            diaryTime.append(saveData)
            userDefaults.set(diaryTime, forKey: "diaryList")
        }
       
        return false
    }

    
    func readDateData() -> [String]{
        if let diaryList = userDefaults.array(forKey: "diaryList") as? [String] {
            diaryTime = []
            diaryTime.append(contentsOf: diaryList)
            print("diarytime",diaryList)
        }
        return diaryTime
    }
    
    func readDiaryDate() -> [[String]] {
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            data = []
            data.append(contentsOf: TimeAndDiaryList)
            
           return data
        }
        return data
    }

    func deleteDiary(index:Int){
        let deleteData = data.filter { ($0.first) ==  diaryTime[index]}
      
        data = data.filter { !deleteData.contains($0) }
        diaryTime.remove(at: index)
        userDefaults.set(data, forKey: "TimeAndDiaryList")
        userDefaults.set(diaryTime, forKey: "diaryList")
    }
    func searchDiary(text:String) -> [[String]]{
        data = readDiaryDate()
        var filterDiary = [[String]]()
        print(text,"と同じものを探します")
        for i in 0..<data.count{
            if data[i][1].lowercased().contains(text){
                
                filterDiary.append(data[i])
            }
        }
        return filterDiary
    }
    
    
}




