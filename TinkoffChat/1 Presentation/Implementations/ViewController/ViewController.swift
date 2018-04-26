//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.02.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let AppDelegate = UIApplication.shared.delegate as? AppDelegate

    override func loadView() {
        super.loadView()
        AppDelegate?.log.viewsState(from: .none, to: .none, method: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate?.log.viewsState(from: .none, to: .none, method: #function)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate?.log.viewsState(from: .disappeared, to: .appearing, method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate?.log.viewsState(from: .appearing, to: .appeared, method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        AppDelegate?.log.viewsState(from: .appearing, to: .appearing, method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        AppDelegate?.log.viewsState(from: .appearing, to: .appearing, method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate?.log.viewsState(from: .appeared, to: .disappearing, method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate?.log.viewsState(from: .disappearing, to: .disappeared, method: #function)
    }
    
}

