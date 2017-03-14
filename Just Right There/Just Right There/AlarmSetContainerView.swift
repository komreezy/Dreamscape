//
//  AlarmSetContainerView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 2/27/17.
//  Copyright © 2017 Komran Ghahremani. All rights reserved.
//

import UIKit

class AlarmSetContainerView: UIView {
    var closeButton: UIButton
    var setView: AlarmSetView
    
    override init(frame: CGRect) {
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 6.0, left: 6.0, bottom: 6.0, right: 6.0)
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        
        setView = AlarmSetView()
        setView.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.75)
        closeButton.addTarget(self, action: #selector(AlarmSetContainerView.closeView), for: .touchUpInside)
        
        addSubview(setView)
        addSubview(closeButton)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        })
        setView.dateTextField.resignFirstResponder()
    }
    
    func setupLayout() {
        addConstraints([
            closeButton.al_left == al_left + 15,
            closeButton.al_top == al_top + 30,
            closeButton.al_height == 30,
            closeButton.al_width == 30
        ])
        
        addConstraints([
            setView.al_left == al_left + 45,
            setView.al_right == al_right - 45,
            setView.al_centerY == al_centerY,
            setView.al_height == 200
        ])
    }
}
