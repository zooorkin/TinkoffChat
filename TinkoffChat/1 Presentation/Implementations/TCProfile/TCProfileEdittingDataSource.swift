//
//  TCProfileEdittingDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

extension TCProfileViewController {
    
    
    func profileEditting(numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func profileEditting(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileEdittingPhotoCell.rawValue, for: indexPath) as? TCProfileEdittingPhotoCell
            if let image = appUser.user?.photo {
                cell!.profileImage = UIImage(data: image)
            } else {
                cell!.profileImage = nil
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileHeaderCell.rawValue, for: indexPath) as? TCProfileHeaderCell
            cell?.header = "Имя пользователя"
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileEdittingNameCell.rawValue, for: indexPath) as? TCProfileEdittingNameCell
            cell!.profileName.text = appUser.user?.fullName ?? ""
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileHeaderCell.rawValue, for: indexPath) as? TCProfileHeaderCell
            cell?.header = "Описание"
            return cell!
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCProfileEdittingDescriptionCell.rawValue, for: indexPath) as? TCProfileEdittingDescriptionCell
            cell!.profileDescription.text = appUser.user?.info
            return cell!
        default:
            fatalError()
        }
    }
    
}
