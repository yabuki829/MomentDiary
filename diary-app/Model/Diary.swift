//
//  Diary.swift
//  diary-app
//
//  Created by Yabuki Shodai on 2022/05/15.
//

import Foundation


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


struct diaryV2:Codable,Equatable{
    let id:String
    let created:Date
    var title: String
    var diary:[diaryData]?
}



