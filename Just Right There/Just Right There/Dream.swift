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
    var formatDate: Date
    var upvotes: Int
    var downvotes: Int
    var comments: [Comment] = []
    
    init(title: String, author: String, text: String, date: String, id: String, upvotes: Int, downvotes: Int) {
        self.title = title
        self.author = author
        self.text = text
        self.date = date
        self.id = id
        self.upvotes = upvotes
        self.downvotes = downvotes
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let sendFormatter = DateFormatter()
        sendFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        sendFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let sendDate = sendFormatter.date(from: date) {
            formatDate = sendDate
        } else if let sendDate = dateFormatter.date(from: date) {
            formatDate = sendDate
        } else {
            formatDate = Date.distantPast
        }
        
        super.init()
    }
}
