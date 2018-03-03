//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 02.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        printEditButtonFrame(method: #function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        printEditButtonFrame(method: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        printEditButtonFrame(method: #function)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*  Расположение и размер кнопки "Редактировать" в вызовах методов viewDidLoad() и
         viewDidAppear(:) отличаются, потому что до layout кнопка хранит значение frame резуль-
         тата вычесления layout времени компиляции.
            Layout происходит между viewDidLoad() и viewDidAppear(:), потому что между временем
         их выполнения вызываются методы viewWillLayoutSubviews() и viewDidLayoutSubviews(). То
         есть:
         
         TIME               METHOD                      FRAME
         ---------------------------------------------------------------------------------------
                            viewDidLoad()               frame времени компиляции
         Layout process     viewWillLayoutSubviews()    вычисление frame
         Layout process     viewDidLayoutSubviews()     вычисление frame
                            viewDidAppear(:)            frame времени выполнения (после layout)
         
         */
        printEditButtonFrame(method: #function)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        print("Выберите изображение профиля")
    }
    
    var isFirst = true
    
    func printEditButtonFrame(method: String){
        
        if isFirst{
            print("Строение frame: (x, y, width, height)")
        }
        
        if let strongEditButton = editButton{
            print("Кнопка \"Редактировать\", cвойство frame: \(strongEditButton.frame) во время выполнения метода \(method)")
        }else{
            print("Кнопка \"Редактировать\" ещё не инициализирована во время выполнения \(method)")
        }
        isFirst = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
