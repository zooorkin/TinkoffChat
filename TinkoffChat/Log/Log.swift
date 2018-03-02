//
//  AppDelegateLog.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 25.02.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import UIKit

class LogTime{
    
    var time: Double = 0
    
    init(){
        time = NSDate().timeIntervalSince1970;
    }
    
    func print(){
        // Переполнится через ~ 24 суток со времени запуска
        // (2^32/2)/(1000*60*60*24)
        let ms = Int(1_000*(NSDate().timeIntervalSince1970 - time))
        // Количество миллисекунд будет укладываться в 6 символов ~ 16 минут
        Swift.print("\(String(format: "%06d", ms))" + "ms  ", terminator:"")
    }
}

enum AppState: String {
    case NotRunning = "Not Running "
    case Inactive =   "Inactive    "
    case Active =     "Active      "
    case Background = "Background  "
    case Suspended =  "Suspended   "
}

enum ViewsState: String{
    case disappeared  = "Disappeared "
    case appeared     = "Appeared    "
    case disappearing = "Disappearing"
    case appearing    = "Appearing   "
    case none         = "–           "
}

func printAppState(from previousState: AppState,
                   now currentState: UIApplicationState,
                   to nextState: AppState,
                   method: String){
    let currentStateString: String
    switch currentState {
    case .active: currentStateString = AppState.Active.rawValue
    case .inactive: currentStateString = AppState.Inactive.rawValue
    case .background: currentStateString = AppState.Background.rawValue
    }
    print("APP     \(previousState.rawValue)  \(currentStateString)  \(nextState.rawValue)  \(method)")
}

func printViewsState(from previousState: ViewsState, to currentState: ViewsState, method: String){
    print("VIEW    \(previousState.rawValue)  \(ViewsState.none.rawValue)  \(currentState.rawValue)  \(method)")
}

func printAppDelegateHeader(){
    print("TIME      OBJECT  FROM STATE    CURR STATE    TO STATE      METHOD\n")
}

func printAppDelegateInfromation(){
    print("""
                APPLICATION STATES     – Not Running
                                       – Inactive
                                       – Active
                                       – Background
                                       – Suspended

                VIEW CONTROLLER'S      – Appearing
                VIEW'S STATES          – Appeared
                                       – Disappearing
                                       – Disappeared

                Состояние Appearing    – уточнённое состояние Appeared
                Состояние Disappearing – уточнённое состояние Disappeared

                Таким образом, когда View находится в состоянии Appearing (Disappearing), то он
                находится в состоянии Appeared (Disappeared), что соответствует [1].

                Процесс запуска приложения (launching) соответствует состоянию
                приложения Inactive

                [1] Apple: UIViewController
                    https://developer.apple.com/documentation/uikit/uiviewcontroller

                """)
}
