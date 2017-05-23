//
//  CommentViewModel.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 5/11/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class CommentViewModel: NSObject {
    var dream: Dream
    var comments: [Comment] = []
    var delegate: CommentViewModelDelegate?
    
    init(dream: Dream) {
        self.dream = dream
        super.init()
        requestComments()
    }
    
    func requestComments() {
        FIRDatabase.database().reference().child("/feed/\(dream.id)/comments").observe(.value, with: { snapshot in
            self.comments.removeAll()
            if let commentData = snapshot.value as? [String:[String:AnyObject]] {
                for (id, commentData) in commentData {
                    if let author = commentData["author"] as? String , author != "by Test test ",
                        let text = commentData["text"] as? String,
                        let date = commentData["date"] as? String{
                        
                        let comment = Comment(author: author, text: text, date: date, id: id)
                        self.comments.append(comment)
                    }
                }
            }
            self.delegate?.commentsDidLoad()
        })
    }
}

protocol CommentViewModelDelegate {
    func commentsDidLoad()
}
