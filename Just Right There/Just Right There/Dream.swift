//
//  Dream.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class Dream: NSObject {
    var title: String
    var author: String
    var text: String
    var id: String
    var date: String
    var upvotes: Int
    var downvotes: Int
    
    init(title: String, author: String, text: String, date: String, id: String, upvotes: Int, downvotes: Int) {
        self.title = title
        self.author = author
        self.text = text
        self.date = date
        self.id = id
        self.upvotes = upvotes
        self.downvotes = downvotes
        
        super.init()
    }
}
