import UIKit

class DiaryModel{
    let userDefaults = UserDefaults.standard
    //日付が入ってる
    var diaryTime = [String]()
    var isTurn = false
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
    //日付の追加
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

//    日付の読み取り
    func readDateData() -> [String]{
        if let diaryList = userDefaults.array(forKey: "diaryList") as? [String] {
            diaryTime = []
            diaryTime.append(contentsOf: diaryList)
            print("diarytime",diaryList)
        }
        return diaryTime
    }
    
    
//    日記の読み取り
    func readDiaryDate() -> [[String]] {
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            data = []
            data.append(contentsOf: TimeAndDiaryList)
            
           return data
        }
        return data
    }
    //日記の削除機能　一日の日記を削除する
    //3月22日の日記を削除する
    func deleteDiary(index:Int){
        let deleteData = data.filter { ($0.first) ==  diaryTime[index]}
      
        data = data.filter { !deleteData.contains($0) }
        diaryTime.remove(at: index)
        userDefaults.set(data, forKey: "TimeAndDiaryList")
        userDefaults.set(diaryTime, forKey: "diaryList")
    }
    
    
    //日記の検索機能
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



/*
 
 配列
 -diaryTimeについて id diaryList
      diaryTime は　日記を投稿した日付が入っている
    ["2022年03月03日(月)","2022年03月04日(火)"]
 
-TimeAndDiaryList について
    　TimeAndDiaryList　は日記の投稿日時 投稿内容　投稿時間が入っている。
 [
     ["2022年03月18日(金)", "ああああ", "16:37"],
     ["2022年03月18日(金)", "いいいいい", "16:37"],
     ["2022年03月18日(金)", "うううう", "16:37"],
     ["2022年03月18日(金)", "ええええ", "16:37"],
    ["2022年03月18日(金)", "画像タイトル", "画像","0"]　　//　投稿日時 画像のタイトル　画像　画像配列の番号
 ]
 
-なぜDate型を使ってないのかというと
    　このアプリは高校生の時に作成したアプリで当時Date型での実装方法がわからなかったためStringの日時を使っている。
    　リリースする時に変更しても良かったが、初めて作った高校生の時に初めて作ったプログラムだったので思い出深く実装に時間がかかったので変更したくなかった。
 
    　今後扱いやすいようにData型で実装し追加機能の画像投稿機能を加えて別のアプリとしてリリースしようと思う。
 
 */
