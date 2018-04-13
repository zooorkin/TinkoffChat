//
//  ProfileDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 13.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

extension ProfileViewController {
    
    
    func profile(numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func profile(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoCell", for: indexPath) as? ProfilePhotoCell
            if let image = appUser.currentUser?.photo {
                cell!.profileImage = UIImage(data: image)
            } else {
                cell!.profileImage = nil
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNameCell", for: indexPath) as? ProfileNameCell
            cell!.profileName.text = appUser.currentUser?.name ?? ""
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell", for: indexPath) as? ProfileDescriptionCell
            cell!.profileDescription.text = appUser.currentUser?.info
            return cell!
        default:
            fatalError()
        }
    }
    
}
