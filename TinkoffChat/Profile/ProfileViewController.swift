//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 02.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDescription: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    private let defaultProfileImage = UIImage(named: "placeholder-user")
    var profileImage: UIImage?{
        get{
            if let strongProfileImage = profileImageView.image, strongProfileImage.isEqual(defaultProfileImage){
                return nil
            }
            return profileImageView.image
        }
        set(newImage){
            if let strongNewImage = newImage{
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.image = strongNewImage
            } else {
                profileImageView.image = defaultProfileImage
                profileImageView.contentMode = .scaleAspectFit
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        printEditButtonFrame(method: #function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /* На момент инициализации экземпляра ProfileViewController кнопка "Редактировать"
        ещё не была инициализирована */
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
        let alertController = UIAlertController()
        let select = UIAlertAction(title: "Установить из галереи", style: .default){ _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        alertController.addAction(select)
        let shot = UIAlertAction(title: "Сделать фото", style: .default){ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(shot)
        if profileImage != nil{
            let destroy = UIAlertAction(title: "Удалить фотографию", style: .destructive){ _ in
                // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
                self.profileImage = nil
            }
            alertController.addAction(destroy)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
            profileImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
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
