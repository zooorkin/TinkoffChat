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
    
    public func getIsUserOnline() -> Bool {
        return isUserOnlineValue
    }
    public func setIsUser(online newValue: Bool, animating: Bool = true){
        isUserOnlineValue = newValue
        
        DispatchQueue.main.async {
            if newValue {
                self.titleBecomesIn(online: true, animating: animating)
            } else {
                self.titleBecomesIn(online: false, animating: animating)
            }
            if !self.isUserOnlineValue{
                // При первоначальной настройке sendButton ещё nil
                self.sendButtonBecomes(enabled: false, animating: animating)
                // При первоначальной настройке inputTextField ещё nil
            }else if let text = self.inputTextField?.text{
                if text != ""{
                    // При первоначальной настройке sendButton ещё nil
                    self.sendButtonBecomes(enabled: true, animating: animating)
                }
            }
        }
    }
    
    private func sendButtonBecomes(enabled: Bool, animating: Bool = true){
        if enabled != sendButton.isEnabled {
            if animating {
                UIView.animate(withDuration: 0.25, animations: {
                    self.sendButton?.isEnabled = enabled
                    self.sendButton?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                }) { (completed) in
                    UIView.animate(withDuration: 0.25){
                        self.sendButton?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                }
            } else {
                self.sendButton?.isEnabled = enabled
            }
        }
    }
    
    private func titleBecomesIn(online: Bool, animating: Bool = true){
        if online {
            if let label = titleLabel {
                if animating {
                    UIView.animate(withDuration: 1) {
                        label.textColor = UIColor.green
                        label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }
                } else {
                    label.textColor = UIColor.green
                    label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            }
        } else {
            if let label = titleLabel{
                if animating {
                    UIView.animate(withDuration: 1) {
                        label.textColor = UIColor.black
                        label.transform = CGAffineTransform(scaleX: 1, y: 1)
                    }
                } else {
                    label.textColor = UIColor.black
                    label.transform = CGAffineTransform(scaleX: 1, y: 1)
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
    
    private var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel = UILabel()
        if let label = titleLabel {
            label.backgroundColor = UIColor.clear
            label.textColor = UIColor.red
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.text = title
            label.sizeToFit()
            self.navigationItem.titleView = label
        }
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
        self.tableView.rowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        inputTextField.delegate = self
        tinkoffAnimation.setView(view: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
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
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: - Keyboard
    
    var isKeyboardShown = false
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardShown{
                self.view.frame.size.height -= keyboardSize.height
            }
            isKeyboardShown = true
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
            self.sendButtonBecomes(enabled: false)
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
            
            if getIsUserOnline() {
                if newMessage == "" {
                    sendButtonBecomes(enabled: false)
                } else {
                    sendButtonBecomes(enabled: true)
                }
            } else {
                sendButtonBecomes(enabled: false)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if getIsUserOnline(){
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
        print("func userBecome(online: Bool) { \(online)")
        setIsUser(online: online)
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
    
    //
    
    let tinkoffAnimation = TCTinkoffAnimation()
    
    //
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesBegan(touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesMoved(touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffAnimation.touchesEnded(touches, with: event)
    }
    
}
