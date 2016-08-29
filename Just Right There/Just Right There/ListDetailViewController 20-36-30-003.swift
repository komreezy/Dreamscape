//
//  ListDetailViewController.swift
//  Just Right There
//
//  Created by Komran Ghahremani on 9/10/15.
//  Copyright (c) 2015 Komran Ghahremani. All rights reserved.
//

import UIKit

class ListDetailViewController: UIViewController {
    // variables passed in from the last view controller
    var currentText: String
    var currentTitle: String
    var currentIndex: Int
    
    var titleLabel: UILabel // will be set by the current title variable
    var textView: UITextView // will be set by the current text variable
    var slider: UISlider

    init() {
        currentIndex = manager.currentIndex
        
        currentText = manager.lists[currentIndex].items
        
        currentTitle = manager.lists[currentIndex].title
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = currentTitle
        titleLabel.backgroundColor = UIColor.clearColor()
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = currentText
        
        slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(slider)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    //if the user clicks the done button then save their list that they wrote
    func doneButtonClicked(sender: UIButton){
        manager.lists[self.currentIndex].items = self.textView.text
    }
    
    //if the user forgets to put the done button and they click back then it's ok it still saves
    override func viewDidDisappear(animated: Bool) {
        manager.lists[self.currentIndex].items = self.textView.text
    }

    func setupLayout() {
        view.addConstraints([
            titleLabel.al_centerX == view.al_centerX,
            titleLabel.al_top == view.al_top + 70,
            
            slider.al_top == titleLabel.al_bottom + 5,
            slider.al_left == view.al_left + 10,
            slider.al_right == view.al_right - 10,
            
            textView.al_left == view.al_left,
            textView.al_right == view.al_right,
            textView.al_bottom == view.al_bottom,
            textView.al_top == slider.al_bottom + 10
        ])
    }
}
