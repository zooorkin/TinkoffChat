//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundRectangle: UIView!
    @IBOutlet var onlineCircleView: CircleView!
    
    var colorScheme: ColorScheme = whiteScheme
    
    private var dateValue: Date?
    
    var name:    String? { get{ return nameLabel.text } set{ nameLabel.text = newValue } }
    var message: String? { get{ return messageLabel.text }
        set{
            if newValue != nil{
                messageLabel.text = newValue
                messageLabel.font = UIFont.systemFont(ofSize: 17)
                messageLabel.textColor = UIColor.darkGray
            }else{
                messageLabel.text = "Нет сообщений"
                messageLabel.font = UIFont.italicSystemFont(ofSize: 17)
                messageLabel.textColor = UIColor.groupTableViewBackground
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
                self.backgroundRectangle.backgroundColor = DesignConstants.pink
                self.nameLabel.textColor = UIColor.white
                self.dateLabel.textColor = UIColor.white
                self.messageLabel.textColor = UIColor.white
                self.backgroundRectangle.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                
            }
        }else{
            UIView.animate(withDuration: 0.3){
                self.backgroundRectangle.backgroundColor = self.hasUnreadMessages ? DesignConstants.lightPink : UIColor.white
                self.nameLabel.textColor = UIColor.darkText
                self.dateLabel.textColor = UIColor.darkGray
                self.messageLabel.textColor = UIColor.darkGray
                self.backgroundRectangle.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    func setOnline(){
        UIView.animate(withDuration: 0.5){
            self.profileImage.transform = CGAffineTransform(scaleX: 0.87, y: 0.87)
            self.onlineCircleView.backgroundColor = DesignConstants.pink
        }
    }
    
    func setOffline(){
        UIView.animate(withDuration: 0.5){
            self.profileImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.onlineCircleView.backgroundColor = UIColor.clear
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            // Здесь анимация не нужна! Они должны перекрыть UNHIGHLIGHTNING
            self.backgroundRectangle.backgroundColor = DesignConstants.pink
            self.nameLabel.textColor = UIColor.white
            self.dateLabel.textColor = UIColor.white
            self.messageLabel.textColor = UIColor.white
        }else{
            UIView.animate(withDuration: 0.3){
                self.backgroundRectangle.backgroundColor = UIColor.white
                self.nameLabel.textColor = UIColor.darkText
                self.dateLabel.textColor = UIColor.darkGray
                self.messageLabel.textColor = UIColor.darkGray
            }
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
