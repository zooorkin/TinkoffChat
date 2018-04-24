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
    
    var communicator: TinkoffCommunicator?
    var dataManager: CommunicationDataManager!
    
    var withUser: TCUser!
    var messages: [TCMessage] = []
    
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
        if messages.isEmpty{
            return 1
        }else{
            return messages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell
        if messages.isEmpty{
            return tableView.dequeueReusableCell(withIdentifier: "NoMessages", for: indexPath)
        }
        if messages[indexPath.row].incomming{
            cell = tableView.dequeueReusableCell(withIdentifier: "InputMessage", for: indexPath) as! MessageCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "OutputMessage", for: indexPath) as! MessageCell
        }
        let message = messages[indexPath.row]
        cell.message = message.text
        cell.isIncoming = message.incomming
        cell.isUnread = message.unread
        cell.time = message.date!

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
        if let userId = withUser.userId {
            communicator?.sendMessage(text: text, to: userId){
                (success: Bool, error: Error?) in
                if !success{
                    let alertController = UIAlertController(title: "Ошибка", message: "Не удалось отправить сообщение \"\(text)\"", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }else{
            //
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
    
    func showNewMessage(isIncomming: Bool) {
        if let conversation = dataManager.getConversation(with: withUser) {
            messages = dataManager.getMessages(from: conversation)
        }
        
        if isIncomming {
            if messages.count == 1 {
                let index = IndexPath(row: messages.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: messages.count-1, section: 0)
                self.tableView.insertRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        } else {
            if messages.count == 1 {
                let index = IndexPath(row: messages.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: messages.count-1, section: 0)
                self.tableView.insertRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }
    
    
}
