import UIKit


class Diary:diaryProtcol{

    

    
    var diaryArray = [diary]()
    
    let userDefaults = UserDefaults.standard
    
    func save(data: [diary]) {
        userDefaults.setCodable(data, forKey: "dairy")
    }
    
    func create() {
        diaryArray = read()
        let a = diary(id: generateID(5), created: Date(), diary: [diaryData]())
        diaryArray.append(a)
        save(data: diaryArray)
    }
    
    func read() -> [diary] {
        if let data:[diary] = userDefaults.codable(forKey: "dairy"){
            diaryArray = data
        }
        return diaryArray
    }
  
    
    
    func deleteDiary(id: String) {
        diaryArray = read()
        for i in 0..<diaryArray.count{
            if id == diaryArray[i].id{
                diaryArray.remove(at: i)
                save(data: diaryArray)
                break
            }
        }
    }
    
    func deleteText(id: String, index: Int) {
        diaryArray = read()
        for i in 0..<diaryArray[index].diary!.count{
            if id == diaryArray[index].diary![i].id{
                save(data: diaryArray)
                break
            }
        }
    }
    func search(text: String) -> [diary] {
        diaryArray = read()
        var searchArray = [diary]()
        
        for i in 0..<diaryArray.count{
            for j in 0..<diaryArray[i].diary!.count{
                if diaryArray[i].diary![j].text.lowercased().contains(text){
                    
                    let data = diaryArray[i].diary![j]
                    
                    searchArray.append(diary(id:diaryArray[i].id, created: diaryArray[i].created, diary:[diaryData(id:data.id , date:data.date , text: data.text, image: data.image)])
                
                )}
            }
            
        }
        return searchArray
    }
    func filter(date: Date) -> [diary] {
        let day = dateFormat(date: date)
        diaryArray = read()
        var fileterArray = [diary]()
        
        for i in 0..<diaryArray.count{
            if day == dateFormat(date: diaryArray[i].created){
                fileterArray.append(diaryArray[i])
            }
        }
        return fileterArray
       
    }
    private func dateFormat(date: Date) -> String {
        let format = DateFormatter()
        format.dateStyle = .long
        format.timeStyle = .none
        return format.string(from: date)
       
     }
    
    func generateID(_ length: Int) -> String {
               let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
               var randomString = ""
               for _ in 0 ..< length {
                   randomString += String(string.randomElement()!)
               }
               return randomString
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


struct diary:Codable,Equatable{
    let id:String
    let created:Date
    var diary:[diaryData]?
}
struct diaryData:Codable,Equatable{
    let id:String
    let date:Date
    let text:String
    let image:Data?
}


protocol diaryProtcol {
    func read()->[diary]
    func save(data:[diary])
    func create()
    func deleteText(id:String,index:Int)
    func deleteDiary(id:String)
    func search(text:String)->[diary]
    func filter(date:Date)->[diary]
    
}
