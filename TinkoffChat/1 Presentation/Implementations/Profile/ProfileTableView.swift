//
//  ProfileData.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 13.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

extension ProfileViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEdittingMode {
            return profileEditting(numberOfRowsInSection: section)
        } else {
            return profile(numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isEdittingMode {
            return profileEditting(cellForRowAt: indexPath)
        } else {
            return profile(cellForRowAt: indexPath)
        }
    }
}
