//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit


class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicatorDelegate2 {

    var withUserID: String = ""
    var messages: [(message: String, isIncoming: Bool, date: Date)] = []
    weak var communicator: TinkoffCommunicator?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: animated)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if messages[indexPath.row].1{
            cell = tableView.dequeueReusableCell(withIdentifier: "InputMessage", for: indexPath) as! MessageCell
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "OutputMessage", for: indexPath) as! MessageCell
        }
        let message = messages[indexPath.row]
        cell.message = message.message
        cell.isIncoming = message.isIncoming
        //cell.isUnread = ?
        cell.time = message.2
        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if messages.count == 0{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let MessageStoryboard = UIStoryboard(name: "MessageController", bundle: nil)
        let MessageController = MessageStoryboard.instantiateViewController(withIdentifier: "MessageController") as! MessageController
        MessageController.message = messages[indexPath.row].message
        navigationController?.pushViewController(MessageController, animated: true)
    }
    
    func didReceiveMessage(text: String) {
        messages += [(text, true, Date())]
        DispatchQueue.main.sync {
            if self.messages.count == 1 {
                let index = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.insertRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        }
    }

    @IBAction func send(_ sender: UIButton) {
        let text = sender.titleLabel?.text ?? "???"
        messages += [(text, false, Date())]
        //DispatchQueue.main.async {
            if self.messages.count == 1 {
                let index = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.reloadRows(at: [index], with: .left)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }else{
                let index = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.insertRows(at: [index], with: .right)
                self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
            }
        //}
        communicator?.sendMessage(string: text, to: withUserID, completionHandler: nil)
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
