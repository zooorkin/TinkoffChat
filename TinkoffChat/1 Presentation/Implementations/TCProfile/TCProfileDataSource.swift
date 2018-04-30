//
//  TCProfileDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

extension TCProfileViewController {
    
    
    func profile(numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func profile(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfilePhotoCell.rawValue, for: indexPath) as? TCProfilePhotoCell
            if let image = appUser.user?.photo {
                cell!.profileImage = UIImage(data: image)
            } else {
                cell!.profileImage = nil
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileNameCell.rawValue, for: indexPath) as? TCProfileNameCell
            cell!.profileName.text = appUser.user?.fullName ?? ""
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileDescriptionCell.rawValue, for: indexPath) as? TCProfileDescriptionCell
            cell!.profileDescription.text = appUser.user?.info
            return cell!
        default:
            fatalError()
        }
    }
    
}
