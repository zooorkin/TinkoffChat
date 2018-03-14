//
//  Date.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 10.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

func getTimeString(from date: Date) -> String{
    let calendar = Calendar.current
    let hour = calendar.component(.hour, from: date)
    let minute = String(format: "%02d", calendar.component(.minute, from: date))
    return "\(hour):\(minute)"
}

func getTimeStringOrDate(from date: Date) -> String{
    let calendar = Calendar.current
    var nowDate = Date()
    nowDate = calendar.date(bySetting: .hour, value: 3, of: nowDate)!
    nowDate = calendar.date(bySetting: .minute, value: 0, of: nowDate)!
    nowDate = calendar.date(bySetting: .second, value: 0, of: nowDate)!
    let dateUTC = date.addingTimeInterval(3*60*60)
    if dateUTC > nowDate{
        let hour = calendar.component(.hour, from: date)
        let minute = String(format: "%02d", calendar.component(.minute, from: date))
        return "\(hour):\(minute)"
    }else{
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let monthString: String
        switch month{
            case 1: monthString = "янв"
            case 2: monthString = "фев"
            case 3: monthString = "мар"
            case 4: monthString = "апр"
            case 5: monthString = "май"
            case 6: monthString = "июн"
            case 7: monthString = "июл"
            case 8: monthString = "авг"
            case 9: monthString = "сен"
            case 10: monthString = "окт"
            case 11: monthString = "ноя"
            case 12: monthString = "дек"
            default: monthString = "..."
        }
        return "\(day) \(monthString.uppercased())"
    }
}


