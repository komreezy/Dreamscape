//
//  HomeFeedViewModel.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeFeedViewModel: NSObject {
    var username: String?
    var id: String?
    var fromOptions: Bool = false
    var dreamDictionary: [Dream] = []
    var starred: [Dream] = []
    var downvotes: [Dream] = []
    weak var delegate: HomeFeedViewModelDelegate?
    
    var shareTitle = ""
    var shareAuthor = ""
    var shareText = ""
    var shareId = ""
    var shareDate = ""
    
    override init() {
        super.init()
        requestData()
        requestStarredData()
        requestDownvotesData()
    }
    
    func requestData() {
        FIRDatabase.database().reference().child("/feed").queryOrdered(byChild: "stars").observe(.value, with: { snapshot in
            if let feedsData = snapshot.value as? [String:[String:AnyObject]] {
                self.dreamDictionary.removeAll()
                for (id, data) in feedsData {
                    if let title = data["title"] as? String,
                        let author = data["author"] as? String , author != "by Test test ",
                        let text = data["text"] as? String,
                        let date = data["date"] as? String {
                        
                        if let upvotes = data["upvotes"] as? Int {
                            if let downvotes = data["downvotes"] as? Int {
                                let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: upvotes, downvotes: downvotes)
                                
                                var comments: [Comment] = []
                                if let commentData = data["comments"] as? [String:[String:AnyObject]] {
                                    for (id, commentData) in commentData {
                                        if let author = commentData["author"] as? String , author != "by Test test ",
                                            let text = commentData["text"] as? String,
                                            let date = commentData["date"] as? String{
                                            
                                            let comment = Comment(author: author, text: text, date: date, id: id)
                                            comments.append(comment)
                                        }
                                    }
                                    
                                    dream.comments = comments
                                }
                                self.dreamDictionary.append(dream)
                            }
                        } else if let stars = data["stars"] as? Int {
                            let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: stars, downvotes: 0)
                            var comments: [Comment] = []
                            if let commentData = data["comments"] as? [String:[String:AnyObject]] {
                                for (id, commentData) in commentData {
                                    if let author = commentData["author"] as? String , author != "by Test test ",
                                        let text = commentData["text"] as? String,
                                        let date = commentData["date"] as? String{
                                        
                                        let comment = Comment(author: author, text: text, date: date, id: id)
                                        comments.append(comment)
                                    }
                                }
                                
                                dream.comments = comments
                            }
                            self.dreamDictionary.append(dream)
                        } else {
                            let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: 0, downvotes: 0)
                            var comments: [Comment] = []
                            if let commentData = data["comments"] as? [String:[String:AnyObject]] {
                                for (id, commentData) in commentData {
                                    if let author = commentData["author"] as? String , author != "by Test test ",
                                        let text = commentData["text"] as? String,
                                        let date = commentData["date"] as? String{
                                        
                                        let comment = Comment(author: author, text: text, date: date, id: id)
                                        comments.append(comment)
                                    }
                                }
                                
                                dream.comments = comments
                            }
                            self.dreamDictionary.append(dream)
                        }
                    }
                }
                
                self.sortDreams()
            } else {
                print("Feed Data not received")
            }
        })
    }
    
    func requestStarredData() {
        guard let username = username else {
            return
        }
        
        var starredTemp: [Dream] = []
        FIRDatabase.database().reference().child("/users/\(username)/starred").observe(.value, with: { snapshot in
            if let starredData = snapshot.value as? [String:[String:AnyObject]] {
                starredIds.removeAll()
                self.starred.removeAll()
                for (id, data) in starredData {
                    if let title = data["title"] as? String,
                        let author = data["author"] as? String,
                        let text = data["text"] as? String,
                        let date = data["date"] as? String {
                        
                        if let upvotes = data["upvotes"] as? Int,
                            let downvotes = data["downvotes"] as? Int {
                            starredIds.append(id)
                            let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: upvotes, downvotes: downvotes)
                            starredTemp.append(dream)
                        } else if let stars = data["stars"] as? Int {
                            starredIds.append(id)
                            let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: stars, downvotes: 0)
                            starredTemp.append(dream)
                        } else {
                            starredIds.append(id)
                            let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: 0, downvotes: 0)
                            starredTemp.append(dream)
                        }
                        
                        self.starred = starredTemp
                    }
                }
                
                // check for duplicates
                for i in 0 ..< starredTemp.count {
                    for j in 0 ..< starredTemp.count {
                        if starredTemp[i].id == starredTemp[j].id && i != j {
                            starredTemp.remove(at: j)
                        }
                    }
                }
                
                self.starred = starredTemp
                self.delegate?.dataDidLoad()
            } else {
                print("Starred Data not received")
            }
        })
    }
    
    func requestDownvotesData() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            var downvotesTemp: [Dream] = []
            FIRDatabase.database().reference().child("/users/\(username)/downvotes").observe(.value, with: { snapshot in
                if let downvoteData = snapshot.value as? [String:[String:AnyObject]] {
                    downvoteIds.removeAll()
                    self.downvotes.removeAll()
                    for (id, data) in downvoteData {
                        if let title = data["title"] as? String,
                            let author = data["author"] as? String,
                            let text = data["text"] as? String,
                            let date = data["date"] as? String {
                            
                            if let upvotes = data["upvotes"] as? Int,
                                let downvotes = data["downvotes"] as? Int {
                                downvoteIds.append(id)
                                let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: upvotes, downvotes: downvotes)
                                downvotesTemp.append(dream)
                            } else if let stars = data["stars"] as? Int {
                                downvoteIds.append(id)
                                let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: stars, downvotes: 0)
                                downvotesTemp.append(dream)
                            } else {
                                downvoteIds.append(id)
                                let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: 0, downvotes: 0)
                                downvotesTemp.append(dream)
                            }
                            
                            self.downvotes = downvotesTemp
                        }
                    }
                    self.downvotes = downvotesTemp
                    self.delegate?.dataDidLoad()
                } else {
                    print("Starred Data not received")
                }
            })
        }
    }
    
    
    func sortDreams() {
        dreamDictionary = quicksort(dreamDictionary)
        delegate?.dataDidLoad()
    }
    
    func sortByDate() {
        dreamDictionary = datesort(dreamDictionary)
        delegate?.dataDidLoad()
    }
    
    func quicksort(_ array: [Dream]) -> [Dream] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count / 2]
        let less = array.filter({($0.upvotes - $0.downvotes) < (pivot.upvotes - pivot.downvotes)})
        let equal = array.filter({($0.upvotes - $0.downvotes) == (pivot.upvotes - pivot.downvotes)})
        let more = array.filter({($0.upvotes - $0.downvotes) > (pivot.upvotes - pivot.downvotes)})
        
        return quicksort(more) + equal + quicksort(less)
    }
    
    func datesort(_ array: [Dream]) -> [Dream] {
        return array.sorted(by: { $0.formatDate.compare($1.formatDate) == .orderedDescending })
    }
}

protocol HomeFeedViewModelDelegate: class {
    func dataDidLoad()
}

enum NSComparisonResult : Int {
    case orderedAscending
    case orderedSame
    case orderedDescending
}
