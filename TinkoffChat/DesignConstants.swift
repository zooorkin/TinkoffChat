//
//  ProfileConstants.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

struct ColorScheme{
    var barColor: UIColor
    var textColor: UIColor
    var backgroundHighlited: UIColor
    var backgroundOnlineCell: UIColor
}

struct DesignConstants{
    static let profileImageRadius = CGFloat(40)
    static let bordedButtonRadius = CGFloat(16)
    
    static let bordedButtonBorderWidth = CGFloat(1)
    
    static let lightPink = UIColor(red: 1, green: 0.937, blue: 0.957, alpha: 1)
    static let pink = UIColor(red:1.00, green:0.16, blue:0.42, alpha:1.0)
    static let darkPink = UIColor(red:0.76, green:0.13, blue:0.32, alpha:1.0)
    static let blue = UIColor(red:0.25, green:0.47, blue:0.94, alpha:1.0)
    static let darkBlue = UIColor(red:0.20, green:0.40, blue:0.80, alpha:1.0)
    
    static let lightYellow = UIColor(red:1.00, green:0.97, blue:0.90, alpha:1.0)
    static let mediumYellow = UIColor(red:1.00, green:0.84, blue:0.40, alpha:1.0)
    static let yellow = UIColor(red:1.00, green:0.73, blue:0.00, alpha:1.0)
    static let darkYellow = UIColor(red:0.84, green:0.61, blue:0.16, alpha:1.0)
    static let messageYellow = UIColor(red:0.97, green:0.67, blue:0.00, alpha:1.0)
    
    static let darkTextYellow = UIColor(red:0.60, green:0.46, blue:0.16, alpha:1.0)
    static let darkDarkTextYellow = UIColor(red:0.37, green:0.30, blue:0.12, alpha:1.0)
    static let lightTextYellow = UIColor(red:0.84, green:0.79, blue:0.67, alpha:1.0)
    
    static let salatGreen = UIColor(red:0.88, green:0.96, blue:0.30, alpha:1.0)
    
    static func isDark(_ color: UIColor) -> Bool {
        if let strongComponents = color.cgColor.components{
            if strongComponents.count == 0{
                return false
            }else if strongComponents.count == 2{
                return strongComponents[0] < 0.6
            }else if strongComponents.count == 4{
            let red = strongComponents[0]
            let green = strongComponents[1]
            let blue = strongComponents[2]
            let sum = red + green + blue
            return sum < 1.6
            }else{
                print("???")
                return false
            }
        }else{
            return false
        }
    }
    static func isLight(_ color: UIColor) -> Bool {
        return isDark(color) ? false : true
    }
}

let yellowScheme = ColorScheme(barColor: DesignConstants.mediumYellow,
                               textColor: DesignConstants.darkTextYellow,
                               backgroundHighlited: DesignConstants.mediumYellow,
                               backgroundOnlineCell: DesignConstants.lightYellow)
let whiteScheme = ColorScheme(barColor: UIColor.white,
                              textColor: UIColor.darkGray,
                              backgroundHighlited: UIColor.lightGray,
                              backgroundOnlineCell: UIColor.groupTableViewBackground)
let pinkScheme = ColorScheme(barColor: DesignConstants.lightPink,
                               textColor: UIColor.gray,
                               backgroundHighlited: DesignConstants.lightPink,
                               backgroundOnlineCell: DesignConstants.lightPink)
