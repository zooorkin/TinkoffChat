//
//  nibNames.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

enum TCNibName: String {
    
    // ViewControllers
    case TCConversationList
    case TCConversation
    case TCProfile
    case TCThemes
    case TCInternetImages
    
    // Cells for ConversationListVC
    case TCConversationCell
    case TCInformationCell
    
    // Cells for ConversationVC
    case TCNoMessagesCell
    case TCInputMessageCell
    case TCOutputMessageCell
    case TCNewMessagesCell
    
    // Cells for ProfileVC
    case TCProfilePhotoCell
    case TCProfileNameCell
    case TCProfileDescriptionCell
    case TCProfileEdittingPhotoCell
    case TCProfileEdittingNameCell
    case TCProfileEdittingDescriptionCell
    case TCProfileHeaderCell
    
    //
    case TCInternetImagesCell
    
}
