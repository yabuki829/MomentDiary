
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
    //画像があるときの投稿機能
    func postDiaryWithImage(date:String,title:String,imgInt:String){
        let num = DiaryArray.count
        DiaryArray.append([])
        if title == ""{
            DiaryArray[num].append(date)
            DiaryArray[num].append("画像")//画像の名前
            DiaryArray[num].append("画像")
            DiaryArray[num].append(imgInt)
        }
        else{
            DiaryArray[num].append(date)
            DiaryArray[num].append(title)
            DiaryArray[num].append("画像")
            DiaryArray[num].append(imgInt)
        }
       
        filterDiary(date: date)
        saveDiary()
    }
    func saveDiary(){
        userDefaults.set(DiaryArray, forKey: "TimeAndDiaryList")
    }
//    全ての日記を読み込む
    func readDiary(){
        if let TimeAndDiaryList = userDefaults.array(forKey: "TimeAndDiaryList") as? [[String]]{
            print("読み込みました")
            print(TimeAndDiaryList)
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
        print("削除します")
        for num in 0..<DiaryArray.count{
            //削除するのが画像の場合
            if filterDiaryArray[row][2] == "画像" && DiaryArray[num][2] == "画像"{
                print("--------------------------")
                print(filterDiaryArray[row])
                print(filterDiaryArray[num])
                print("--------------------------")
                if filterDiaryArray[row][3]  == DiaryArray[num][3]{
                    DiaryArray.remove(at: num)
                    break
                }
            }
            //画像でない場合
            else{
                if filterDiaryArray[row][1] == DiaryArray[num][1] {
                    DiaryArray.remove(at: num)
                    break
                }
            }
            
        }
        filterDiaryArray = DiaryArray.filter { ($0.first) ==  date }
        if  isTurn == true{
            filterDiaryArray.reverse()
        }
        userDefaults.set(DiaryArray, forKey: "TimeAndDiaryList")
    }
}
