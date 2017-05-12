//
//  Comment.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 5/11/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var author: String
    var text: String
    var id: String
    var date: String
    
    init(author: String, text: String, date: String, id: String) {
        self.author = author
        self.text = text
        self.date = date
        self.id = id
        
        super.init()
    }
}
