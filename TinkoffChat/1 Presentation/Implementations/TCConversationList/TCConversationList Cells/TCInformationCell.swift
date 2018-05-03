//
//  TCInformationCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCInformationCell: UITableViewCell {

    @IBOutlet var informationText: UILabel!
    
    public var information: String{
        get{
            return informationText.text ?? ""
        }
        set{
            informationText.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
