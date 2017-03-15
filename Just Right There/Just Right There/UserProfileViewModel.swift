//
//  UserProfileViewModel.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 10/24/15.
//  Copyright © 2015 Komran Ghahremani. All rights reserved.
//

import UIKit
import SystemConfiguration
import FirebaseDatabase
import Firebase

var starredIds: [String] = []
var downvoteIds: [String] = []

class UserProfileViewModel: NSObject {
    
    var journals: [Dream] = []
    var starred: [Dream] = []
    var userDefaults: UserDefaults
    var username: String?
    var profilePicture: String?
    var reachable: Reachability
    weak var delegate: UserProfileViewModelDelegate?
    
    var shareTitle = ""
    var shareAuthor = ""
    var shareText = ""
    var shareId = ""
    var shareDate = ""
    
    override init() {
        userDefaults = UserDefaults.standard
        reachable = Reachability()
        
        super.init()
        
        getUsername()
        getProfilePicture()
        
        requestJournalData()
        requestStarredData()
    }
    
    func getUsername() -> String {
        if let username = userDefaults.string(forKey: "username") {
            self.username = username
            return username
        }
        
        return ""
    }
    
    func getProfilePicture() {
        if let picture = userDefaults.string(forKey: "username") {
            profilePicture = picture
        }
    }
    
    func requestJournalData() {
        if reachable.isConnectedToNetwork() {
            guard let username = username else {
                return
            }
            FIRDatabase.database().reference().child("/users/\(username)/journals").observe(.value, with: { snapshot in
                if let journalsData = snapshot.value as? [String:AnyObject] {
                    self.journals.removeAll()
                    for (id, data) in journalsData {
                        if let journalData = data as? [String:AnyObject] {
                            if let title = journalData["title"] as? String,
                                let author = journalData["author"] as? String,
                                let text = journalData["text"] as? String,
                                let date = journalData["date"] as? String {
                                
                                if let upvotes = data["upvotes"] as? Int,
                                    let downvotes = data["downvotes"] as? Int {
                                    let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: upvotes, downvotes: downvotes)
                                    self.journals.append(dream)
                                } else if let stars = data["stars"] as? Int {
                                    let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: stars, downvotes: 0)
                                    self.journals.append(dream)
                                } else {
                                    let dream = Dream(title: title, author: author, text: text, date: date, id: id, upvotes: 0, downvotes: 0)
                                    self.journals.append(dream)
                                }
                            }
                        }
                    }
                    
                    if self.journals[self.journals.count - 1].author != "" {
                        self.delegate?.dataDidLoad()
                    }
                } else {
                    print("Feed Data not received")
                }
            })
        } else { // no internet - get data from the phone
            if let journals = UserDefaults.standard.object(forKey: "journals") as? [[String:AnyObject]] {
                self.journals.removeAll()
                var journalsCopy = journals
                for journal in journalsCopy {
                    if let title = journal["title"] as? String,
                        let author = journal["author"] as? String,
                        let text = journal["text"] as? String,
                        let date = journal["date"] as? String {
                        
                        if let upvotes = journal["upvotes"] as? Int,
                            let downvotes = journal["downvotes"] as? Int {
                            let dream = Dream(title: title, author: author, text: text, date: date, id: "", upvotes: upvotes, downvotes: downvotes)
                            self.journals.append(dream)
                        } else if let stars = journal["stars"] as? Int {
                            let dream = Dream(title: title, author: author, text: text, date: date, id: "", upvotes: stars, downvotes: 0)
                            self.journals.append(dream)
                        } else {
                            let dream = Dream(title: title, author: author, text: text, date: date, id: "", upvotes: 0, downvotes: 0)
                            self.journals.append(dream)
                        }
                    }
                }
                delegate?.dataDidLoad()
            }
        }
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
                        
                        var authorFormatted: NSString = author as NSString
                        if author.contains("by ") {
                            authorFormatted = authorFormatted.substring(from: 3) as NSString
                        }
                        
                        if let upvotes = data["upvotes"] as? Int,
                            let downvotes = data["downvotes"] as? Int {
                            let dream = Dream(title: title, author: authorFormatted as String, text: text, date: date, id: id, upvotes: upvotes, downvotes: downvotes)
                            starredIds.append(id)
                            starredTemp.append(dream)
                        } else if let stars = data["stars"] as? Int {
                            let dream = Dream(title: title, author: authorFormatted as String, text: text, date: date, id: id, upvotes: stars, downvotes: 0)
                            starredIds.append(id)
                            starredTemp.append(dream)
                        } else {
                            let dream = Dream(title: title, author: authorFormatted as String, text: text, date: date, id: id, upvotes: 0, downvotes: 0)
                            starredIds.append(id)
                            starredTemp.append(dream)
                        }
                        
                        self.starred = starredTemp
                    }
                }
                self.starred = starredTemp
                self.delegate?.dataDidLoad()
            } else {
                print("Starred Data not received")
            }
        })
    }
}

protocol UserProfileViewModelDelegate: class {
    func dataDidLoad()
}

open class Reachability {
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
