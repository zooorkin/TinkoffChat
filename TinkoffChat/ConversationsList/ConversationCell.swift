//
//  ConversationCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConversationCellConfiguration {
    
    @IBOutlet weak var onlineCircleView: CircleView!
    @IBOutlet weak var profileImage: RoundImage!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    private var dateValue: Date?
    private var onlineValue: Bool = false
    private var hasUnreadMessagesValue: Bool = false
    
    var name: String? { get{ return nameLabel.text } set{ nameLabel.text = newValue } }
    var message: String? { get{ return messageLabel.text }
        set{
            if newValue != nil{
                messageLabel.text = newValue
                messageLabel.font = UIFont.systemFont(ofSize: 17)
                messageLabel.textColor = UIColor.darkGray
            }else{
                messageLabel.text = "No messages yet"
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
                dateLabel.text = getTimeStringOrDate(from: strongDateValue)
            }else{
                dateLabel.text = ""
            }
        }
    }
    var online: Bool {
        get{
            return onlineValue
        }
        set{
            onlineValue = newValue
            if onlineValue == true{
                onlineCircleView.isHidden = false
            }else{
                onlineCircleView.isHidden = true
            }
        }
    }
    var hasUnreadMessages: Bool {
        get{ return hasUnreadMessagesValue }
        set{ hasUnreadMessagesValue = newValue }
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted{
            backgroundColor = UIColor.groupTableViewBackground
        }else{
            if hasUnreadMessages{
                backgroundColor = DesignConstants.lightPink
            }else{
                backgroundColor = UIColor.clear
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            backgroundColor = UIColor.groupTableViewBackground
        }else{
            if hasUnreadMessages{
                backgroundColor = DesignConstants.lightPink
            }else{
                backgroundColor = UIColor.clear
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
