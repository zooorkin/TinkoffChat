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
                dateLabel.text = Date.getTimeStringOrDate(from: strongDateValue)
            }else{
                dateLabel.text = ""
            }
        }
    }
    
    public var online: Bool = false
    public var hasUnreadMessages: Bool = false
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Этот блок нужно перенести, потому что вычисляется всего один раз
        if hasUnreadMessages{
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        }else{
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        }
        if highlighted{
            backgroundRectangle.backgroundColor = colorScheme.backgroundHighlited
            messageLabel.textColor = colorScheme.textColor
            dateLabel.textColor = colorScheme.textColor
        }else{
            if online{
                backgroundRectangle.backgroundColor = colorScheme.backgroundOnlineCell
                messageLabel.textColor = colorScheme.textColor
                dateLabel.textColor = colorScheme.textColor
            }else{
                backgroundRectangle.backgroundColor = UIColor.groupTableViewBackground
                messageLabel.textColor = UIColor.darkGray
                dateLabel.textColor = UIColor.darkGray
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            setHighlighted(selected, animated: animated)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
