//
//  SpeechTranscriptionViewController.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 3/6/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class SpeechTranscriptionViewController: UIViewController {
    
    var firstBubble: CircleView
    var secondBubble: CircleView
    
    init() {
        firstBubble = CircleView()
        firstBubble.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        firstBubble.backgroundColor = UIColor(fromHexString: "#DCDCDC")
        firstBubble.layer.borderColor = UIColor.black.withAlphaComponent(0.75).cgColor
        firstBubble.layer.borderWidth = 5.0
        
        secondBubble = CircleView()
        secondBubble.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        secondBubble.backgroundColor = UIColor(fromHexString: "#DCDCDC")
        secondBubble.layer.borderColor = UIColor.black.withAlphaComponent(0.75).cgColor
        secondBubble.layer.borderWidth = 5.0
        
        super.init(nibName: nil, bundle: nil)
        
        firstBubble.center = view.center
        secondBubble.center = view.center
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        view.addSubview(firstBubble)
        view.addSubview(secondBubble)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 10.0, *) {
            _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { _ in
                self.firstBubble.circlePulseAinmation(100.0, duration: 2.0, completionBlock: {})
                self.secondBubble.circlePulseAinmation(50.0, duration: 2.0, completionBlock: {})
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
