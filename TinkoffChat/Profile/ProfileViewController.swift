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
    @IBOutlet weak var operationButton: EditButton!
    @IBOutlet weak var GCDButton: EditButton!
    @IBOutlet weak var changePhotoButton: ChangeProfileImageButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var log = false
    
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
        activityIndicator.isHidden = true
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
        //printEditButtonFrame(method: #function)
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
    
    var isFirst = true
    
    func printEditButtonFrame(method: String){
        if log{
        if isFirst{
            print("Строение frame: (x, y, width, height)")
        }
        if let strongEditButton = GCDButton{
            print("Кнопка \"Редактировать\", cвойство frame: \(strongEditButton.frame) во время выполнения метода \(method)")
        }else{
            print("Кнопка \"Редактировать\" ещё не инициализирована во время выполнения \(method)")
        }
        }
        isFirst = false
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func changeEditState(){
        profileName.isEdit = !profileName.isEdit
        profileName.isEditable = !profileName.isEditable
        profileDescription.isEdit = !profileDescription.isEdit
        profileDescription.isEditable = !profileDescription.isEditable
        GCDButton.isHidden = !GCDButton.isHidden
        operationButton.isHidden = !operationButton.isHidden
        changePhotoButton.isHidden = !changePhotoButton.isHidden
        //GCDButton.isEdit = !GCDButton.isEdit
        //GCDButton.isEnabled = !GCDButton.isEnabled
        //operationButton.isEdit = !operationButton.isEdit
        //operationButton.isEnabled = !operationButton.isEnabled
    }
    
    private func scrollToTop(){
        let top = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(top, animated: true)
    }
    private func scrollToBottom(){
        let bottomOffset = CGPoint(x: 0, y: 64)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
    @IBAction func editProfile(_ sender: Any) {
        changeEditState()
        if GCDButton.isHidden{
            scrollToTop()
        }else{
            scrollToBottom()
        }
    }
    
    private func save(nameString: String, descriptionString: String, image: UIImage?){
        let fileManager = FileManager()
        let homeDirectory = NSHomeDirectory()
        
        let pathName = URL(fileURLWithPath: homeDirectory + "/" + fileName, isDirectory: false)
        let pathDescription = URL(fileURLWithPath: homeDirectory + "/" + fileDescription, isDirectory: false)
        let pathImage = URL(fileURLWithPath: homeDirectory + "/" + fileImage, isDirectory: false)
       do{
            try nameString.write(to: pathName, atomically: true, encoding: .utf8)
            try descriptionString.write(to: pathDescription, atomically: true, encoding: .utf8)
            if let strongProfileImage = image{
                try UIImagePNGRepresentation(strongProfileImage)?.write(to: pathImage)
            }else{
                if fileManager.fileExists(atPath: homeDirectory + "/" + fileImage){
                    try FileManager().removeItem(at: pathImage)
                }
            }
        }catch{
            print("SAVE CAUGHT!!!")
        }

    }
    
    @IBAction func GCD(_ sender: Any) {
        let queue = DispatchQueue.global(qos: .default)
        let name = profileName.text ?? ""
        let desc = profileDescription.text ?? ""
        let image = profileImage
        queue.async {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.changeEditState()
            }
            self.save(nameString: name, descriptionString: desc, image: image)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.scrollToTop()
            }
        }
    }
    
    @IBAction func Operation(_ sender: Any) {
        let operationQueue = OperationQueue()
        let mainOperationQueue = OperationQueue.main
        let name = profileName.text ?? ""
        let desc = profileDescription.text ?? ""
        let image = profileImage
        operationQueue.addOperation {
            mainOperationQueue.addOperation {
                self.activityIndicator.startAnimating()
                self.activityIndicator.isHidden = false
                self.changeEditState()
            }
            self.save(nameString: name, descriptionString: desc, image: image)
            mainOperationQueue.addOperation {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.scrollToTop()
            }
        }
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
