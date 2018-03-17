//
//  MessageInCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, MessageCellConfiguration {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: Message!
    @IBOutlet weak var tail: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    public var message: String? {
        get{ return messageLabel.text }
        set{ messageLabel.text = newValue }
    }
    public var isIncoming: Bool = true
    public var isUnread: Bool{
        get{
            return isUnreadValue
        }
        set{
            isUnreadValue = newValue
            if isUnreadValue{
                messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            }else{
                messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            }
        }
    }
    public var time: Date{
        get{ return timeOfMessage }
        set{ timeOfMessage = newValue
            timeLabel.text = getTimeString(from: timeOfMessage)
        }
    }
   
    private var isUnreadValue: Bool = false
    private var timeOfMessage: Date = Date()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let myImage = tail.image{
            let tintableImage = myImage.withRenderingMode(.alwaysTemplate)
            tail.image = tintableImage
            tail.tintColor = messageView.backgroundColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        // Этот блок нужно перенести, потому что вычисляется всего один раз
        if isIncoming{
            messageLabel.textColor = UIColor.darkText
            timeLabel.textColor = UIColor.lightGray
        }else{
            messageLabel.textColor = DesignConstants.darkDarkTextYellow
            timeLabel.textColor = DesignConstants.lightTextYellow
        }
        if highlighted{
            messageView.backgroundColor = isIncoming ? UIColor.lightGray : DesignConstants.mediumYellow
        }else{
            messageView.backgroundColor = isIncoming ? UIColor.groupTableViewBackground : DesignConstants.lightYellow
        }
        // Теперь необходимо покрасить хвостик цветом сообщения
        tail.tintColor = messageView.backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        setHighlighted(selected, animated: animated)
    }
}
