//
//  HomeFeedViewModel.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class HomeFeedViewModel: NSObject {
    var username: String?
    var id: String?
    var dreamDictionary: [Dream] = []
    var feedRef = rootRef.childByAppendingPath("/feed")
    weak var delegate: HomeFeedViewModelDelegate?
    
    override init() {
        super.init()
        
        requestData()
    }
    
    func requestData() {
        feedRef.queryOrderedByChild("stars").observeEventType(.Value, withBlock: { snapshot in
            if let feedsData = snapshot.value as? [String:[String:AnyObject]] {
                self.dreamDictionary.removeAll()
                for (id, data) in feedsData {
                    if let title = data["title"]! as? String,
                        let author = data["author"]! as? String where author != "by Test test ",
                        let text = data["text"]! as? String,
                        let date = data["date"]! as? String,
                        let stars = data["stars"]! as? Int {
                        
                        let dream = Dream(title: title, author: author, text: text, date: date, stars: stars, id: id)
                        self.dreamDictionary.append(dream)
                    }
                }
                
                self.sortDreams()
            } else {
                print("Feed Data not received")
            }
        })
    }
    
    func sortDreams() {
        dreamDictionary = quicksort(dreamDictionary)
        delegate?.dataDidLoad()
    }
    
    func quicksort(array: [Dream]) -> [Dream] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count / 2]
        let less = array.filter({$0.stars < pivot.stars})
        let equal = array.filter({$0.stars == pivot.stars})
        let more = array.filter({$0.stars > pivot.stars})
        
        return quicksort(more) + equal + quicksort(less)
    }
}

protocol HomeFeedViewModelDelegate: class {
    func dataDidLoad()
}
