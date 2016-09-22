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

class UserProfileViewModel: NSObject {
    
    var journals: [Dream] = []
    var starred: [Dream] = []
    //var journalRef = rootRef.childByAppendingPath("/users/journals")
    //var starredRef = rootRef.childByAppendingPath("/users/starred")
    weak var delegate: UserProfileViewModelDelegate?
    var userDefaults: NSUserDefaults
    var username: String?
    var profilePicture: String?
    var reachable: Reachability
    
    var shareTitle = ""
    var shareAuthor = ""
    var shareText = ""
    var shareId = ""
    var shareDate = ""
    
    override init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
        
        reachable = Reachability()
        
        super.init()
        
        getUsername()
        getProfilePicture()
        
        requestJournalData()
        requestStarredData()
    }
    
    func getUsername() -> String {
        if let username = userDefaults.stringForKey("username") {
            self.username = username
            //self.journalRef = rootRef.childByAppendingPath("/users/\(username)/journals")
            //self.starredRef = rootRef.childByAppendingPath("/users/\(username)/starred")
            return username
        }
        
        return ""
    }
    
    func getProfilePicture() {
        if let picture = userDefaults.stringForKey("username") {
            profilePicture = picture
        }
    }
    
    func requestJournalData() {
        if reachable.isConnectedToNetwork() {
            guard let username = username else {
                return
            }
            FIRDatabase.database().reference().child("/users/\(username)/journals").observeEventType(.Value, withBlock: { snapshot in
                if let journalsData = snapshot.value as? [String:AnyObject] {
                    self.journals.removeAll()
                    for (id, data) in journalsData {
                        if let journalData = data as? [String:AnyObject] {
                            if let title = journalData["title"]! as? String,
                                let author = journalData["author"]! as? String,
                                let text = journalData["text"]! as? String,
                                let date = journalData["date"]! as? String,
                                let stars = journalData["stars"]! as? Int {
                                let dream = Dream(title: title, author: author, text: text, date: date, stars: stars, id: id)
                                self.journals.append(dream)
                                
                            }
                        }
                    }
                    
                    if self.journals[self.journals.count - 1].author != "" {
                        //NSUserDefaults.standardUserDefaults().setObject(self.journals, forKey: "journals")
                        self.delegate?.dataDidLoad()
                    }
                    
                } else {
                    print("Feed Data not received")
                }
            })
        } else { // no internet - get data from the phone
            if let journals = NSUserDefaults.standardUserDefaults().objectForKey("journals") as? [[String:AnyObject]] {
                self.journals.removeAll()
                var journalsCopy = NSMutableArray(array: journals)
                for journal in journalsCopy {
                    if let title = journal["title"]! as? String,
                        let author = journal["author"]! as? String,
                        let text = journal["text"]! as? String,
                        let date = journal["date"]! as? String,
                        let stars = journal["stars"]! as? Int {
                            let dream = Dream(title: title, author: author, text: text, date: date, stars: stars, id: "")
                            self.journals.append(dream)
                            
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
        FIRDatabase.database().reference().child("/users/\(username)/starred").observeEventType(.Value, withBlock: { snapshot in
            if let starredData = snapshot.value as? [String:[String:AnyObject]] {
                starredIds.removeAll()
                self.starred.removeAll()
                for (id, data) in starredData {
                    if let title = data["title"]! as? String,
                        let author = data["author"]! as? String,
                        let text = data["text"]! as? String,
                        let date = data["date"]! as? String,
                        let stars = data["stars"]! as? Int {
                            starredIds.append(id)
                            let dream = Dream(title: title, author: author, text: text, date: date, stars: stars, id: id)
                            starredTemp.append(dream)
                            self.starred = starredTemp
                    }
                }
                // check for duplicates
                for var i = 0; i < starredTemp.count; i++ {
                    for var j = 0; j < starredTemp.count; j++ {
                        if starredTemp[i].id == starredTemp[j].id && i != j {
                            starredTemp.removeAtIndex(j)
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
}

protocol UserProfileViewModelDelegate: class {
    func dataDidLoad()
}

public class Reachability {
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
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
