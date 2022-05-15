import UIKit

protocol diaryProtcol {
    func read()->[diary]
    func save(data:[diaryV2])
    func create()
    func deleteText(id:String,index:Int)
    func deleteDiary(id:String)
    func search(text:String)->[diaryV2]
    func filter(date:Date)->[diaryV2]
    
}

class Diary:diaryProtcol{
    
    
  
    var diaryArray = [diaryV2]()
    
    let userDefaults = UserDefaults.standard
    
    func save(data: [diaryV2]) {
        print("V2",data.count)
        userDefaults.setCodable(data, forKey: "diaryV2")
    }
    
    func create() {
        diaryArray = readV2()
        let a = diaryV2(id: generateID(5), created: Date(), title: ""
                        , diary: [diaryData]())
        diaryArray.append(a)
        save(data: diaryArray)
    }
    
    func read() -> [diary] {
        var array = [diary]()
        if let data:[diary] = userDefaults.codable(forKey: "dairy"){
            //dairyはもう使わないから削除する
            userDefaults.removeObject(forKey: "dairy")
            array = data
        }
        
        return array
    }
    
    func readV2() -> [diaryV2]{
        var array = [diaryV2]()
        if let data:[diaryV2] = userDefaults.codable(forKey: "diaryV2"){
            array = data
        }
        return array
    }
  
    
    
    func deleteDiary(id: String) {
        var array = readV2()
        for i in 0..<array.count{
            if id == array[i].id{
                array.remove(at: i)
                save(data: array)
                break
            }
        }
    }
    
    func deleteText(id: String, index: Int) {
        var array = readV2()
        for i in 0..<array[index].diary!.count{
            if id == array[index].diary![i].id{
                save(data: array)
                break
            }
        }
    }
    func search(text: String) -> [diaryV2] {
        diaryArray = readV2()
        var searchArray = [diaryV2]()
        
        for i in 0..<diaryArray.count{
            for j in 0..<diaryArray[i].diary!.count{
                if diaryArray[i].diary![j].text.lowercased().contains(text){
                    
                    let data = diaryArray[i].diary![j]
                    
                    searchArray.append(diaryV2(id:diaryArray[i].id, created: diaryArray[i].created, title:diaryArray[i].title , diary:[diaryData(id:data.id , date:data.date , text: data.text, image: data.image)])
                
                )}
            }
            
        }
        return searchArray
    }
    func filter(date: Date) -> [diaryV2] {
        let day = dateFormat(date: date)
        var array = readV2()
        var fileterArray = [diaryV2]()
        
        for i in 0..<array.count{
            if day == dateFormat(date: array[i].created){
                fileterArray.append(array[i])
            }
        }
        return array
       
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



