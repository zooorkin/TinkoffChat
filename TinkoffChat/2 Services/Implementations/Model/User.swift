//
//  ITCDataModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class User: IUser {
    
    let data: TCUser
    
    init(user: TCUser) {
        self.data = user
    }
    
    init?(user: TCUser?) {
        if let strongUser = user {
            self.data = strongUser
        } else {
            return nil
        }
    }
    
    var id: String {
        return data.userId!
    }
    
    var name: String? {
        return data.fullName
    }
    
    var info: String? {
        return data.info
    }
    
    var online: Bool {
        return data.online
    }
    
    var photo: UIImage? {
        if let data = data.photo {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
    
}


