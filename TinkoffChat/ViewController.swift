//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.02.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

enum StateOfView: String{
    case disappeared  = "Disappeared "
    case appeared     = "Appeared    "
    case disappearing = "Disappearing"
    case appearing    = "Appearing   "
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        logItView(from: StateOfView.disappeared.rawValue, to: StateOfView.appearing.rawValue, method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logItView(from: StateOfView.appearing.rawValue, to: StateOfView.appeared.rawValue, method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        logItView(from: StateOfView.appearing.rawValue, to: StateOfView.appearing.rawValue, method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        logItView(from: StateOfView.appearing.rawValue, to: StateOfView.appearing.rawValue, method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        logItView(from: StateOfView.appeared.rawValue, to: StateOfView.disappearing.rawValue, method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        logItView(from: StateOfView.disappearing.rawValue, to: StateOfView.disappeared.rawValue, method: #function)
    }
    
}

