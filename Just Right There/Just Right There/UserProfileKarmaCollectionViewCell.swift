//
//  UserProfileKarmaCollectionViewCell.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/4/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase

class UserProfileKarmaCollectionViewCell: HomeFeedImageCollectionViewCell {
    weak var userProfileDelegate: UserProfileCellDelegate?
    
    override func upvoteTapped() {
        
    }
    
    override func downvoteTapped() {
        
    }
    
    override func displayOptions() {
        if let title = dream?.title,
            let author = dream?.author,
            let text = dream?.text,
            let id = dream?.id,
            let date = dream?.date {
            
            userProfileDelegate?.shareTapped(title, author: author, text: text, id: id, date: date)
        }
    }
}
