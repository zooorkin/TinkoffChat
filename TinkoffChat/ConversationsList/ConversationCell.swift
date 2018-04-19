//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    
    @IBOutlet var userCircleView: UserCircle!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var backgroundRectangle: UIView!
    
    private var dateValue: Date?
    
    var name:    String? { get{ return nameLabel.text } set{ nameLabel.text = newValue } }
    private var messageString: String?
    var message: String? { get{ return messageLabel.text }
        set{
            if newValue != nil{
                messageString = newValue
                messageLabel.text = newValue
                messageLabel.font = UIFont.systemFont(ofSize: 17)
                messageLabel.textColor = UIColor.darkGray
            }else{
                messageString = nil
                messageLabel.text = "Нет сообщений"
                messageLabel.font = UIFont.italicSystemFont(ofSize: 17)
                messageLabel.textColor = UIColor.lightGray
            }
        }
    }
    var date: Date? {
        get{ return dateValue }
        set{
            dateValue = newValue
            if let strongDateValue = dateValue{
                dateLabel.text = Date.getTimeStringOrDate(from: strongDateValue)
            }else{
                dateLabel.text = ""
            }
        }
    }
    
    private var onlineValue: Bool = false
    public var online: Bool{
        get{
            return onlineValue
        }
        set{
            onlineValue = newValue
            DispatchQueue.main.async {
                self.onlineValue ? self.setOnline() : self.setOffline()
            }
        }
    }
    public var hasUnreadMessages: Bool = false
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Этот блок нужно перенести, потому что вычисляется всего один раз
//        if hasUnreadMessages{
//            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        }else{
//            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        }
        
        if highlighted{
            UIView.animate(withDuration: 0.3){
                if self.onlineValue {
                    self.backgroundRectangle.backgroundColor = DesignConstants.pink
                    self.nameLabel.textColor = UIColor.white
                    self.dateLabel.textColor = UIColor.white
                    self.messageLabel.textColor = UIColor.white
                }else{
                    self.backgroundRectangle.backgroundColor = UIColor.white
                }
                self.backgroundRectangle.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                
            }
        }else{
            UIView.animate(withDuration: 0.3){
                if self.hasUnreadMessages {
                    self.backgroundRectangle.backgroundColor = DesignConstants.lightPink
                }else if self.onlineValue {
                    self.backgroundRectangle.backgroundColor = UIColor.white
                }else{
                    self.backgroundRectangle.backgroundColor = UIColor.clear
                }
                self.nameLabel.textColor = UIColor.darkText
                self.dateLabel.textColor = UIColor.darkGray
                if self.messageString != nil {
                    self.messageLabel.textColor = UIColor.darkGray
                } else {
                    self.messageLabel.textColor = UIColor.lightGray
                }
                self.backgroundRectangle.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            // Здесь анимация не нужна! Они должны перекрыть UNHIGHLIGHTNING
            if self.onlineValue {
                self.backgroundRectangle.backgroundColor = DesignConstants.pink
                self.nameLabel.textColor = UIColor.white
                self.dateLabel.textColor = UIColor.white
                self.messageLabel.textColor = UIColor.white
            } else {
                self.backgroundRectangle.backgroundColor = UIColor.white
            }
        } else {
            UIView.animate(withDuration: 0.3){
                if self.hasUnreadMessages {
                    self.backgroundRectangle.backgroundColor = DesignConstants.lightPink
                }else if self.onlineValue {
                    self.backgroundRectangle.backgroundColor = UIColor.white
                }else{
                    self.backgroundRectangle.backgroundColor = UIColor.clear
                }
                self.nameLabel.textColor = UIColor.darkText
                self.dateLabel.textColor = UIColor.darkGray
                if self.messageString != nil {
                    self.messageLabel.textColor = UIColor.darkGray
                } else {
                    self.messageLabel.textColor = UIColor.lightGray
                }
            }
        }
    }
    
    func setOnline(){
        UIView.animate(withDuration: 0.5){
            self.userCircleView.setOnline()
            self.backgroundRectangle.backgroundColor = self.hasUnreadMessages ? DesignConstants.lightPink : UIColor.white
        }
    }
    
    func setOffline(){
        UIView.animate(withDuration: 0.5){
            self.userCircleView.setOffline()
            self.backgroundRectangle.backgroundColor = self.hasUnreadMessages ? DesignConstants.lightPink : UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
