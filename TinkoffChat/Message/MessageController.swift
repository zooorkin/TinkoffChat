//
//  MessageController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 10.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class MessageController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
