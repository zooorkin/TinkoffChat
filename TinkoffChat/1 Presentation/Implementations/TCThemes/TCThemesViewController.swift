//
//  TCThemesViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCThemesViewController: UIViewController {

    @IBOutlet var colorButton1: ColorButton!
    @IBOutlet var colorButton2: ColorButton!
    @IBOutlet var colorButton3: ColorButton!
    
    private let presentationAssembly: ITCPresentationAssembly
    private var manager: ITCManager
    private let colors: (UIColor, UIColor, UIColor)
    
    public var delegate: ITCThemesViewControllerDelegate?
    
    init(presentationAssembly: ITCPresentationAssembly, manager: ITCManager, colors: (UIColor, UIColor, UIColor)) {
        self.presentationAssembly = presentationAssembly
        self.manager = manager
        self.colors = colors
        super.init(nibName: TCNibName.TCThemes.rawValue, bundle: nil)
    }
    
    
    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        adjustNavigationBar()
        super.viewDidLoad()
        colorButton1.backgroundColor = colors.0
        colorButton2.backgroundColor = colors.1
        colorButton3.backgroundColor = colors.2
        // Do any additional setup after loading the view.
    }

    
    // MARK: -
    
    private func adjustNavigationBar(){
        title = "Мой профиль"
        navigationController?.navigationBar.tintColor = UIColor.black
        if let topItem = navigationController?.navigationBar.topItem {
            let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
            let rightButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(close))
            topItem.leftBarButtonItem = leftButton
            topItem.rightBarButtonItem = rightButton
        } else {
            fatalError()
        }
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        switch sender.tag {
        case 0: delegate?.didSelectThemeWith(color: colors.0)
            self.view.backgroundColor = colors.0
        case 1: delegate?.didSelectThemeWith(color: colors.1)
            self.view.backgroundColor = colors.1
        case 2: delegate?.didSelectThemeWith(color: colors.2)
            self.view.backgroundColor = colors.2
        default: fatalError()
            
        }
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
