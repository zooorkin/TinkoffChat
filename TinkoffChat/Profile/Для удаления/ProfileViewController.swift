//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 02.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileName: EditTextView!
    @IBOutlet weak var profileDescription: EditTextView!
    @IBOutlet weak var changePhotoButton: ChangeProfileImageButton!
    
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
    
    private let fileName = "name.txt"
    private let fileDescription = "description.txt"
    private let fileImage = "image.png"
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //printEditButtonFrame(method: #function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /* На момент инициализации экземпляра ProfileViewController кнопка "Редактировать"
        ещё не была инициализирована */
        //printEditButtonFrame(method: #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        //printEditButtonFrame(method: #function)
        // Do any additional setup after loading the view.
    }
    
    private func loadUserData(){
        let fileManager = FileManager()
        let homeDirectory = NSHomeDirectory()
        let pathName = URL(fileURLWithPath: homeDirectory + "/" + fileName)
        let pathDescription = URL(fileURLWithPath: homeDirectory + "/" + fileDescription)
        //let pathImage = URL(fileURLWithPath: homeDirectory + "/" + fileImage)
        do{
            if fileManager.fileExists(atPath: homeDirectory + "/" + fileName){
                profileName.text = try String(contentsOf: pathName, encoding: .utf8)
            }
            if fileManager.fileExists(atPath: homeDirectory + "/" + fileDescription){
                profileDescription.text = try String(contentsOf: pathDescription, encoding: .utf8)
            }
            if fileManager.fileExists(atPath: homeDirectory + "/" + fileImage){
                profileImage = UIImage(contentsOfFile: homeDirectory + "/" + fileImage)
            }
        }catch{
            print("READ CAUGHT!!!")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        profileView.layer.cornerRadius = DesignConstants.profileImageRadius
        profileView.layer.masksToBounds = true
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
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
