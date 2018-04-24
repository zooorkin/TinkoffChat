//
//  ProfileEdittingDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 13.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

extension ProfileViewController {

   
    func profileEditting(numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func profileEditting(cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingPhotoCell", for: indexPath) as? ProfileEdittingPhotoCell
            if let image = appUser.user?.photo {
                cell!.profileImage = UIImage(data: image)
            } else {
                cell!.profileImage = nil
            }
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
            cell?.header = "Имя пользователя"
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingNameCell", for: indexPath) as? ProfileEdittingNameCell
            cell!.profileName.text = appUser.user?.fullName ?? ""
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
            cell?.header = "Описание"
            return cell!
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingDescriptionCell", for: indexPath) as? ProfileEdittingDescriptionCell
            cell!.profileDescription.text = appUser.user?.info
            return cell!
        default:
            fatalError()
        }
    }
    
}
