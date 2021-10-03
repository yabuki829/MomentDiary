
import Foundation

class PostDiaryModel{
    var userDefaults = UserDefaults.standard
    var DiaryArray = [[String]]()   //0 -> 投稿日,　1 -> 投稿内容, 2 -> 投稿時間
    var filterDiaryArray = [[String]]()
    var isTurn = false
    
    func getPostTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = formatter.string(from: NSDate() as Date)
        return date
    }
    
    //投稿する time:投稿時間　date:投稿日　diary:投稿内容
    func postDiary(time:String,date:String,diary:String){
        let num = DiaryArray.count
        DiaryArray.append([])
        DiaryArray[num].append(date)
        DiaryArray[num].append(diary)
        DiaryArray[num].append(time)
        filterDiary(date: date)
        saveDiary()
    }
    func saveDiary(){
        userDefaults.set(DiaryArray, forKey: "TimeAndDiaryList")
    }
//    全ての日記を読み込む
    func readDiary(){
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            DiaryArray.append(contentsOf: TimeAndDiaryList)
        }
    }
    
    func filterDiary(date:String){
        filterDiaryArray = DiaryArray.filter { ($0.first) ==  date }
        if  isTurn == true {
            filterDiaryArray.reverse()
        }
    }
    
    func deleteSentence(row:Int,date:String){
        for num in 0..<DiaryArray.count{
            if filterDiaryArray[row][1] == DiaryArray[num][1] {
                DiaryArray.remove(at: num)
                break
            }
        }
        filterDiaryArray = DiaryArray.filter { ($0.first) ==  date }
        if  isTurn == true{
            filterDiaryArray.reverse()
        }
        userDefaults.set(DiaryArray, forKey: "TimeAndDiaryList")
    }
}

