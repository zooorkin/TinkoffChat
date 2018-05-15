//
//  TCProfileTableView.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

extension TCProfileViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch dataSource[indexPath.row] {
        case .profilePhoto (let photo):
            let identifier = TCNibName.TCProfilePhotoCell.rawValue
            typealias T = TCProfilePhotoCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.profileImage = photo
            return cell
            
        case .profileName (let name):
            let identifier = TCNibName.TCProfileNameCell.rawValue
            typealias T = TCProfileNameCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.name = name
            return cell
            
        case .profileDescription (let description):
            let identifier = TCNibName.TCProfileDescriptionCell.rawValue
            typealias T = TCProfileDescriptionCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.info = description
            return cell
            
        case .profileEdittingPhoto (let photo):
            let identifier = TCNibName.TCProfileEdittingPhotoCell.rawValue
            typealias T = TCProfileEdittingPhotoCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.profileViewController = self
            cell.profileImage = photo
            cell.model = model
            return cell
            
        case .profileEdittingName (let name):
            let identifier = TCNibName.TCProfileEdittingNameCell.rawValue
            typealias T = TCProfileEdittingNameCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.name = name
            cell.model = model
            return cell
            
        case .profileEdittingDescription (let description):
            let identifier = TCNibName.TCProfileEdittingDescriptionCell.rawValue
            typealias T = TCProfileEdittingDescriptionCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
            cell.info = description
            cell.model = model
            return cell
            
        case .profileHeader (let header):
            let identifier = TCNibName.TCProfileHeaderCell.rawValue
            typealias T = TCProfileHeaderCell
            guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
                fatalError()
            }
             cell.header = header
            return cell
        }
    }
}
