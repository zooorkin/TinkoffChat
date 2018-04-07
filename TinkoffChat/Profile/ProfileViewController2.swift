//
//  ProfileViewController2.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfileViewController2: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet var editButton: UIBarButtonItem!
    /*
    @IBOutlet var profileImageView: RoundImage!
    @IBOutlet var profileName: EditTextView!
    @IBOutlet var profileDescription: EditTextView!
    @IBOutlet var GCDButton: EditButton!
    @IBOutlet var operationButton: EditButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var changeProfileImageButton: ChangeProfileImageButton!
    
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var aboutMe: UILabel!
    @IBOutlet var userNameCell: UITableViewCell!
    
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
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        profileName.delegate = self
        profileDescription.delegate = self
        userName.text = ""
        aboutMe.text = ""
        loadUserData()
        activityIndicator.isHidden = true
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
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
*/
    var editting = false
    
    @IBAction func edit(_ sender: Any) {
        isEdittingMode = !isEdittingMode
        let index = IndexSet(integer: 0)
        tableView.reloadSections(index, with: .automatic)
        /*
        editting = !editting
        if editting{
            profileName.isEditable = true
            profileDescription.isEditable = true
            GCDButton.isHidden = false
            operationButton.isHidden = false
            changeProfileImageButton.isHidden = false
        }else{
            profileName.isEditable = false
            profileDescription.isEditable = false
            GCDButton.isHidden = true
            operationButton.isHidden = true
            changeProfileImageButton.isHidden = true
        }
        if !editting{
            userName.text = ""
            aboutMe.text = ""
        }else{
            userName.text = "Имя пользователя"
            aboutMe.text = "О себе"
        }
        let indices = [IndexPath(row: 1, section: 0), IndexPath(row: 3, section: 0)]
        tableView.reloadRows(at: indices, with: .none)
        if editting{
            profileName.isEdit = true
            profileDescription.isEdit = true
        }else{
            profileName.isEdit = false
            profileDescription.isEdit = false
        }
 */
    }
    /*
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
            informationNotChanged = false
            self.textViewDidBeginEditing(profileName)
        }
        dismiss(animated: true, completion: nil)
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
            let alertController = UIAlertController(title: "Сохранено", message: "Данные успешно сохранены", preferredStyle: .alert)
            let ok  = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }catch{
            print("SAVE CAUGHT!!!")
            let alertController = UIAlertController(title: "Ошибка", message: "Не удалось сохранить данные", preferredStyle: .alert)
            let ok  = UIAlertAction(title: "OK", style: .default, handler: nil)
            let retry = UIAlertAction(title: "Повторить", style: .default){ _ in
                self.save(nameString: nameString, descriptionString: descriptionString, image: image)
            }
            alertController.addAction(ok)
            alertController.addAction(retry)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func GCD(_ sender: Any) {
        let queue = DispatchQueue.global(qos: .default)
        let name = profileName.text ?? ""
        let desc = profileDescription.text ?? ""
        let image = profileImage
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.GCDButton.isEnabled = false
        self.operationButton.isEnabled = false
        queue.async {
            self.save(nameString: name, descriptionString: desc, image: image)
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.edit(self)
                self.editButton.isEnabled = true
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
                self.GCDButton.isEnabled = false
                self.operationButton.isEnabled = false
            }
            self.save(nameString: name, descriptionString: desc, image: image)
            mainOperationQueue.addOperation {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.edit(self)
                self.editButton.isEnabled = true
            }
        }
    }
    */
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 && editting{
            return 256
        }else{
            return UITableViewAutomaticDimension
        }
    }*/
    
    /*
    private var informationNotChanged = false
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !informationNotChanged{
            self.GCDButton.isEnabled = true
            self.operationButton.isEnabled = true
            editButton.isEnabled = false
        }
        informationNotChanged = true
    }
 */
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var isEdittingMode = false
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEdittingMode{
            return 6
        }else{
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isEdittingMode{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoCell", for: indexPath) as? ProfilePhotoCell
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNameCell", for: indexPath) as? ProfileNameCell
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell", for: indexPath) as? ProfileDescriptionCell
                return cell!
            default:
                fatalError()
            }
        }else{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingPhotoCell", for: indexPath) as? ProfileEdittingPhotoCell
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingNameCell", for: indexPath) as? ProfileEdittingNameCell
                return cell!
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
                return cell!
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingDescriptionCell", for: indexPath) as? ProfileEdittingDescriptionCell
                return cell!
            case 5:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSaveCell", for: indexPath) as? ProfileSaveCell
                return cell!
            default:
                fatalError()
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
