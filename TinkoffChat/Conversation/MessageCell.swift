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
    
    private var isUnreadValue: Bool = false
    private var isIncomingValue: Bool = true
    private var timeOfMessage: Date = Date()
    
    public var message: String? {
        get{ return messageLabel.text }
        set{ messageLabel.text = newValue }
    }
    public var isIncoming: Bool{
        get{
            return isUnreadValue
        }
        set{
            isIncomingValue = newValue
            if isIncomingValue {
                messageView.backgroundColor = DesignConstants.blue
            }else{
                messageView.backgroundColor = DesignConstants.pink
            }
        }
    }
    public var isUnread: Bool{
        get{ return isUnreadValue }
        set{
            if newValue == false{
                backgroundColor = UIColor.clear
            }else{
                backgroundColor = DesignConstants.lightPink
            }
        }
    }
    public var time: Date{
        get{ return timeOfMessage }
        set{ timeOfMessage = newValue
            timeLabel.text = getTimeString(from: timeOfMessage)
        }
    }
    
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
        if highlighted{
            if isIncomingValue {
                messageView.backgroundColor = DesignConstants.darkBlue
            }else{
                messageView.backgroundColor = DesignConstants.darkPink
            }
        }
        else{
            if isIncomingValue {
                messageView.backgroundColor = DesignConstants.blue
            }else{
                messageView.backgroundColor = DesignConstants.pink
            }
        }
        tail.tintColor = messageView.backgroundColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            if isIncomingValue {
                messageView.backgroundColor = DesignConstants.darkBlue
            }else{
                messageView.backgroundColor = DesignConstants.darkPink
            }
        }
        else{
            if isIncomingValue {
                messageView.backgroundColor = DesignConstants.blue
            }else{
                messageView.backgroundColor = DesignConstants.pink
            }
        }
        tail.tintColor = messageView.backgroundColor
    }
}
