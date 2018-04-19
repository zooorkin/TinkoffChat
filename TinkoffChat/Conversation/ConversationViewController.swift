//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit
import CoreData

enum ConversationState {
    case online
    case offline
}

class ConversationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: -
    
    var withFriend: User?
     var communicator: TinkoffCommunicator?
      var storageManager = StorageManager()
       private var context: NSManagedObjectContext? {
        return storageManager.mainContext
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
    private var fetchedResultController: NSFetchedResultsController<Message>?
    
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
           setupFRC()
            fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: Notification.Name.UIKeyboardWillHide, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
          if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: animated)
        } else {
            //fatalError()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        storageManager.performSave(context: storageManager.mainContext, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        if let messages = manager.conversation?.messages{
//            if !messages.isEmpty {
//                let indexPath = IndexPath(row: messages.count - 1, section: 0)
//                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//            }
//        }
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
    
    private func setupFRC() {
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        let predicate = NSPredicate(format: "fromConversation.id = %@", withFriend!.conversation!.id!)
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        
        guard let context = context else { return }
        
        fetchedResultController = NSFetchedResultsController<Message>(fetchRequest: fetchRequest,
                                                                      managedObjectContext: context,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
        
        fetchedResultController?.delegate = self
    }
    
    private func fetchData() {
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("Error - \(error), function:" + #function)
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

    
    /// Генерация уникального ID для сообщений
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    // MARK: - Actions
    
    
    @IBAction func send(_ sender: UIButton) {
        
        sendButton.isEnabled = false
        let text = inputTextField.text ?? "???"
        inputTextField.text = nil
        let newMessage = Message.insertConversation(in: storageManager.mainContext)
        newMessage.date = Date()
        newMessage.text = text
        newMessage.incomming = false
        newMessage.id = generateMessageId()
        withFriend?.conversation?.addToMessages(newMessage)
        if let userID = withFriend?.userId {
        communicator?.sendMessage(string: text, to: userID){
            (success: Bool, error: Error?) in
            if !success{
                let alertController = UIAlertController(title: "Ошибка", message: "Не удалось отправить сообщение \"\(text)\"", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
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
    
    // MARK: - ConversationProtocol
    
    public func didChangeState(state: ConversationState) {
        switch state {
        case .offline: isUserOnline = false
        case .online: isUserOnline = true
        }
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchedResultController?.sections?.count else {
            return 0
        }
        
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutputMessage") as? MessageCell else {
            fatalError()
        }
        
        if let message = fetchedResultController?.object(at: indexPath) {
            cell.message = message.text
        }
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


