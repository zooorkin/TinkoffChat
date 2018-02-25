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
        AppDelegate?.time.print()
        printViewsState(from: .none, to: .none, method: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate?.time.print()
        printViewsState(from: .none, to: .none, method: #function)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate?.time.print()
        printViewsState(from: .disappeared, to: .appearing, method: #function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AppDelegate?.time.print()
        printViewsState(from: .appearing, to: .appeared, method: #function)
    }
    
    override func viewWillLayoutSubviews() {
        AppDelegate?.time.print()
        printViewsState(from: .appearing, to: .appearing, method: #function)
    }
    
    override func viewDidLayoutSubviews() {
        AppDelegate?.time.print()
        printViewsState(from: .appearing, to: .appearing, method: #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate?.time.print()
        printViewsState(from: .appeared, to: .disappearing, method: #function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        AppDelegate?.time.print()
        printViewsState(from: .disappearing, to: .disappeared, method: #function)
    }
    
}

