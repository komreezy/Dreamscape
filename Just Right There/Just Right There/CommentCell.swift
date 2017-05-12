//
//  CommentCell.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 5/9/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var authorLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textView: UITextView!

    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            let newWidth = frame.width * 0.92
            let space = (frame.width - newWidth) / 2
            frame.size.width = newWidth
            frame.origin.x += space
            
            super.frame = frame
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.font = UIFont(name: "Courier", size: 13.5)
        textView.backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        textView.textColor = UIColor.white.withAlphaComponent(0.54)
        textView.text = "Yo i thought this dream was wack as fuck how many people want to read this dude. this completely wasted my time and I actually think I might kill myself now having read that. Thanks a lot man."
        textView.isScrollEnabled = false
        
        dateLabel.font = UIFont(name: "Courier", size: 12.0)
        dateLabel.textColor = UIColor.white.withAlphaComponent(0.54)
        dateLabel.text = "2 months ago"
        
        authorLabel.titleLabel?.font = UIFont(name: "Montserrat", size: 12.0)
        authorLabel.setTitleColor(.white, for: .normal)
        authorLabel.setTitle("komreezy", for: .normal)
        
        backgroundColor = UIColor(red: 34.0/255.0, green: 35.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        layer.cornerRadius = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
