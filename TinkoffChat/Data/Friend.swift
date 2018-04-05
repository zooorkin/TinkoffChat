//
//  data.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

struct Friend {
    var id: String
    var name: String
    var lastMessage: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
//    static func getDate() -> Date?{
//        let f = DateFormatter()
//        f.dateFormat = "dd.MM.yyyy HH:mm"
//        let dd = String(format: "%02d", arc4random_uniform(30)+1)
//        let MM = String(format: "%02d", arc4random_uniform(12)+1)
//        let yyyy = String(format: "%04d", arc4random_uniform(2)+2017)
//        let HH = String(format: "%02d", arc4random_uniform(24))
//        let mm = String(format: "%02d", arc4random_uniform(60))
//        let s = "\(dd).\(MM).\(yyyy) \(HH):\(mm)"
//        let date = f.date(from: s)
//
//        assert(date != nil)
//        return date
//    }
//    static var date = Date()
//    static var isFirst = true
//
//    // Субмартингал
//    static func getDate2() -> Date{
//        if isFirst{
//            isFirst = false
//            return date
//        }
//        // Мат. ожидание = 6 часов
//        date = date.addingTimeInterval(-Double(arc4random_uniform(12*60*60)))
//        return date
//    }
//
//    static func getMessage() -> String?{
//        return messages[Int(arc4random_uniform(UInt32(messages.count)))]
//    }
//
//    static func getBool() -> Bool{
//        return arc4random_uniform(2) > 0
//    }
//
//    static func returnFriends() -> [Friend]{
//        var friends: [Friend] = []
//        let bools = [true, false]
//        // Генерация всевозможных состояний
//        for isOnline in bools{
//            for isMessage in bools{
//                for isUnread in bools{
//                    let message = isMessage ? getMessage() : nil
//                    let friend = Friend(name: "",
//                                        lastMessage: message,
//                                        date: getDate2(),
//                                        online: isOnline,
//                                        hasUnreadMessages: isUnread
//                    )
//                    friends.append(friend)
//                    for _ in 1...2{
//                        let friend2 = Friend(name: "",
//                                             lastMessage: getMessage(),
//                                             date: getDate2(),
//                                             online: isOnline,
//                                             hasUnreadMessages: getBool()
//                        )
//                        friends.append(friend2)
//
//                    }
//                }
//            }
//        }
//        for i in 0..<friends.count{
//            friends[i].name = names[i%names.count]
//        }
//        return friends
//    }
}




