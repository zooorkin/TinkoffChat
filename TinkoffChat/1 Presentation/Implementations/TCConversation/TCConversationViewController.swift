//
//  TCConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ITCManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var gestureTap: UITapGestureRecognizer!
    
    var messages: [Message]
    
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
    
    private let presentationAssembly: ITCPresentationAssembly
    private var manager: ITCManager
    private let user: User
    
    private let log = Log(hideLogs: false)
    
    // MARK: - ITCManagerDelegate
    
    var childDelegate: ITCManagerDelegate?
    
    func userDidBecomeOnline(userId: String) {
        if user.id == userId {
            isUserOnline = true
        }
        childDelegate?.userDidBecomeOnline(userId: userId)
    }
    
    func userDidBecomeOffine(userId: String) {
        if user.id == userId {
            isUserOnline = false
        }
        childDelegate?.userDidBecomeOffine(userId: userId)
    }
    
    func didReceiveMessage(fromUserWithId: String) {
        childDelegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
        showNewMessage(isIncomming: true, userId: fromUserWithId)
    }
    
    
    func didSendMessage(toUserWithId: String) {
        childDelegate?.didSendMessage(toUserWithId: toUserWithId)
        showNewMessage(isIncomming: false, userId: toUserWithId)
    }
    
    // MARK: - init
    
    init(presentationAssembly: ITCPresentationAssembly, manager: ITCManager, user: User) {
        self.presentationAssembly = presentationAssembly
        self.manager = manager
        self.user = user
        self.messages =  {
            if let conversation = manager.getConversation(with: user) {
                return manager.getMessages(from: conversation)
            } else {
                return []
            }
        }()
        super.init(nibName: TCNibName.TCConversation.rawValue, bundle: nil)
        log.logTime(#function)
        print("----TCConversationViewController has been initialized")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    override func viewDidLoad() {
        log.logTime(#function)
        title = "Conversation"
        super.viewDidLoad()
        log.logTime(#function)
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
        log.logTime(#function)
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
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
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
        sendButton.isEnabled = false
        if let text = inputTextField.text {
            inputTextField.text = nil
            if text == "" {
                return
            }
            manager.send(message: text, toUserWithUserId: user.id){
                (success: Bool, error: Error?) in
                if !success{
                    let alertController = UIAlertController(title: "Ошибка", message: "Не удалось отправить сообщение \"\(text)\"", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
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

    func showNewMessage(isIncomming: Bool, userId: String) {
        DispatchQueue.main.async {
            if self.user.id == userId, let conversation = self.manager.getConversation(with: self.user) {
                self.messages = self.manager.getMessages(from: conversation)
            } else {
                return
            }
            if isIncomming {
                if self.messages.count == 1 {
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    self.tableView.reloadRows(at: [index], with: .right)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }else{
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    
                    self.tableView.insertRows(at: [index], with: .left)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                    
                }
            } else {
                if self.messages.count == 1 {
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    self.tableView.reloadRows(at: [index], with: .left)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }else{
                    let index = IndexPath(row: self.messages.count-1, section: 0)
                    self.tableView.insertRows(at: [index], with: .right)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
    }

    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages.isEmpty{
            return 1
        }else{
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TCMessageCell
        if messages.isEmpty{
            return tableView.dequeueReusableCell(withIdentifier: TCNibName.TCNoMessagesCell.rawValue)!
        }
        if messages[indexPath.row].incomming{
            cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInputMessageCell.rawValue) as! TCMessageCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCOutputMessageCell.rawValue) as! TCMessageCell
        }
        let message = messages[indexPath.row]
        cell.message = message.text
        cell.isIncoming = message.incomming
        cell.isUnread = message.unread
        cell.time = message.date!
        
        return cell
    }
    
}
