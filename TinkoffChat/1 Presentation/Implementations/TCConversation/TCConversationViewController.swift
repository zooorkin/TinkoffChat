//
//  TCConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ITCConversationModelDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var gestureTap: UITapGestureRecognizer!
    
    
    private let presentationAssembly: ITCPresentationAssembly
    
    internal let model: ITCConversationModel
    
    internal var dataSource: [TCConversationCellModel] = []
    
    private var isUserOnlineValue: Bool = false
    var isUserOnline: Bool{
        get{
            return isUserOnlineValue
        }
        set{
            isUserOnlineValue = newValue
            
            DispatchQueue.main.async {
                if !self.isUserOnlineValue{
                    // При первоначальной настройке sendButton ещё nil
                    self.sendButton?.isEnabled = false
                    // При первоначальной настройке inputTextField ещё nil
                }else if let text = self.inputTextField?.text{
                    if text != ""{
                        // При первоначальной настройке sendButton ещё nil
                        self.sendButton?.isEnabled = true
                    }
                }
            }
        }
    }
    
    // MARK: - init
    
    init(presentationAssembly: ITCPresentationAssembly, model: ITCConversationModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: TCNibName.TCConversation.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = "Conversation"
        super.viewDidLoad()
        model.fetchUpdate()
        tableView.reloadData()
        registerNibs()
        sendButton.isEnabled = false
        inputTextField.returnKeyType = .default
        inputTextField.enablesReturnKeyAutomatically = true
        self.tableView.addGestureRecognizer(gestureTap)
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        inputTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: animated)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !dataSource.isEmpty {
            let indexPath = IndexPath(row: dataSource.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Keyboard
    
    var isKeyboardShown = false
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardShown{
                self.view.frame.size.height -= keyboardSize.height
            }
            isKeyboardShown = true
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if isKeyboardShown {
                self.view
                    .frame.size.height += keyboardSize.height
            }
            isKeyboardShown = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func send(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.sendButton.isEnabled = false
            if let text = self.inputTextField.text {
                self.inputTextField.text = nil
            if text == "" {
                return
            } else {
                self.model.send(text: text)
                
            }
        }
        }
    }
    
    @IBAction func gestureTapped(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let message = textField.text, let stringRange = Range(range, in: message) {
            let newMessage = message.replacingCharacters(in: stringRange, with: string)
            sendButton.isEnabled = isUserOnline && newMessage != "" ? true : false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isUserOnline{
            send(UIButton())
        }
        return false
    }

    func showNewMessage(isIncomming: Bool) {
        if isIncomming {
            if self.dataSource.count == 1 {
                let index = IndexPath(row: self.dataSource.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: self.dataSource.count-1, section: 0)
                
                self.tableView.insertRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                
            }
        } else {
            if self.dataSource.count == 1 {
                let index = IndexPath(row: self.dataSource.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: self.dataSource.count-1, section: 0)
                self.tableView.insertRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.isEmpty{
            return 1
        }else{
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TCMessageCell
        if dataSource.isEmpty{
            return tableView.dequeueReusableCell(withIdentifier: TCNibName.TCNoMessagesCell.rawValue)!
        }
        if dataSource[indexPath.row].incomming{
            cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInputMessageCell.rawValue) as! TCMessageCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCOutputMessageCell.rawValue) as! TCMessageCell
        }
        let message = dataSource[indexPath.row]
        cell.message = message.text
        cell.isIncoming = message.incomming
        cell.isUnread = message.unread
        cell.time = message.date
        
        return cell
    }
    
    // MARK: - ITCConversationModelDelegate
    
    func update(dataSource: [TCConversationCellModel]) {
        self.dataSource = dataSource
    }
    
    func didRecieveNewMessage() {
        showNewMessage(isIncomming: true)
    }
    
    func didSendNewMessage() {
        showNewMessage(isIncomming: false)
    }
    
    func userBecome(online: Bool) {
        isUserOnline = online
    }
    
    func showAlertMessage(text: String) {
        let alertController = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - PRIVATE
    
    private func registerNibs() {
        let nib1 = UINib(nibName: TCNibName.TCNoMessagesCell.rawValue, bundle: nil)
        let nib2 = UINib(nibName: TCNibName.TCNewMessagesCell.rawValue, bundle: nil)
        let nib3 = UINib(nibName: TCNibName.TCInputMessageCell.rawValue, bundle: nil)
        let nib4 = UINib(nibName: TCNibName.TCOutputMessageCell.rawValue, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TCNibName.TCNoMessagesCell.rawValue)
        tableView.register(nib2, forCellReuseIdentifier: TCNibName.TCNewMessagesCell.rawValue)
        tableView.register(nib3, forCellReuseIdentifier: TCNibName.TCInputMessageCell.rawValue)
        tableView.register(nib4, forCellReuseIdentifier: TCNibName.TCOutputMessageCell.rawValue)
    }
    
}
