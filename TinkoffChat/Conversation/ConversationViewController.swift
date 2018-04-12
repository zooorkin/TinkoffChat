//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

enum ConversationState {
    case online
    case offline
}

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationProtocol, UITextFieldDelegate {
    
    // MARK: -
    
    weak var communicator: TinkoffCommunicator?
    weak var manager: CommunicationManager!
    var data: ConversationData {
        return manager
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gestureTap: UITapGestureRecognizer!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
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
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: animated)
        }
        if let friend = data.conversationWithFriend(){
            if friend.lastMessage != nil{
                let message = SimpleMessage(text: friend.lastMessage!, isIncoming: friend.isIncomming!, date: friend.date!)
                manager.conversation!.messages = [message]
            } else {
                manager.conversation!.messages = []
            }
        } else {
            fatalError()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let messages = manager.conversation?.messages{
            if !messages.isEmpty {
                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if data.conversationData.isEmpty{
            return 1
        }else{
            return data.conversationData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell
        if data.conversationData.isEmpty{
            return tableView.dequeueReusableCell(withIdentifier: "NoMessages", for: indexPath)
        }
        if data.conversationData[indexPath.row].isIncoming{
            cell = tableView.dequeueReusableCell(withIdentifier: "InputMessage", for: indexPath) as! MessageCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "OutputMessage", for: indexPath) as! MessageCell
        }
        let message = data.conversationData[indexPath.row]
        cell.message = message.text
        cell.isIncoming = message.isIncoming
        //cell.isUnread = ?
        cell.time = message.date
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func send(_ sender: UIButton) {
        sendButton.isEnabled = false
        let text = inputTextField.text ?? "???"
        inputTextField.text = nil
        let message = SimpleMessage(text: text, isIncoming: false, date: Date())
        data.pushNewMessage(message, toUser: data.conversationWithUser)
        if data.conversationData.count == 1 {
            let index = IndexPath(row: data.conversationData.count-1, section: 0)
            self.tableView.reloadRows(at: [index], with: .left)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }else{
            let index = IndexPath(row: data.conversationData.count-1, section: 0)
            self.tableView.insertRows(at: [index], with: .right)
            self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
        }
        communicator?.sendMessage(string: text, to: data.conversationWithUser){
            (success: Bool, error: Error?) in
            if !success{
                let alertController = UIAlertController(title: "Ошибка", message: "Не удалось отправить сообщение \"\(text)\"", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
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
    
    // MARK: - ConversationProtocol
    
    public func didChangeState(state: ConversationState) {
        switch state {
        case .offline: isUserOnline = false
        case .online: isUserOnline = true
        }
    }
    
    func showNewMessage() {
        DispatchQueue.main.sync {
            if let messages = self.manager.conversation?.messages{
                if messages.count == 1 {
                    let index = IndexPath(row: messages.count-1, section: 0)
                    self.tableView.reloadRows(at: [index], with: .right)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }else{
                    let index = IndexPath(row: messages.count-1, section: 0)
                    self.tableView.insertRows(at: [index], with: .left)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
    }
    
}
