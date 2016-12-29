//
//  ProfileIconPickerView.swift
//  Dreamscape
//
//  Created by Komran Ghahremani on 2/24/16.
//  Copyright © 2016 Komran Ghahremani. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProfileIconPickerView: UIViewController, UIScrollViewDelegate {
    var pointerImageView: UIImageView
    var tintView: UIView
    var closeButton: UIButton
    var selectButton: UIButton
    var pageWidth: CGFloat
    var scrollView: UIScrollView
    var pageControl: UIPageControl
    var pageCount: Int
    var pageImages: [UIImage]
    var pageTexts: [String]
    var pageViews: [ProfileIconView]
    var userDefaults: UserDefaults
    var pointerAlignmentConstraint: NSLayoutConstraint?
    var currentPage: Int {
        return Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
    }
    
    var tabWidth: CGFloat {
        return UIScreen.main.bounds.width / CGFloat(pageCount)
    }
    
    var arrowXOffset: CGFloat {
        return (tabWidth * CGFloat(currentPage + 1)) - (tabWidth / 2)
    }
    
    init() {
        pageWidth = UIScreen.main.bounds.width - 20
        
        pageImages = [
            UIImage(named: "alien-head")!,
            UIImage(named: "atom")!,
            UIImage(named: "brain")!,
            UIImage(named: "circus-camel")!,
            UIImage(named: "cloud-and-moon")!,
            UIImage(named: "earth-globe")!,
            UIImage(named: "fire-gear")!,
            UIImage(named: "flask")!,
            UIImage(named: "giraffe")!,
            UIImage(named: "hot-air-balloon")!,
            UIImage(named: "islamic-art-1")!,
            UIImage(named: "islamic-art-2")!,
            UIImage(named: "oil-lamp")!,
            UIImage(named: "saturn")!
        ]
        
        pageTexts = [
            "Edit lyrics or messages by tapping Keys",
            "View all of your saved lyrics\n by tapping Favorites",
            "See lyrics you've previously\n sent by tapping Recents",
            "Discover top lyrics, songs &\n artists by tapping Search"
        ]
        
        pageViews = [ProfileIconView]()
        
        tintView = UIImageView()
        tintView.translatesAutoresizingMaskIntoConstraints = false
        tintView.backgroundColor = BlackColor.withAlphaComponent(0.8)
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = ClearColor
        scrollView.showsHorizontalScrollIndicator = false
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = DarkGrey
        pageControl.currentPageIndicatorTintColor = WhiteColor.withAlphaComponent(0.75)
        
        pageCount = 14
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "close"), for: UIControlState())
        closeButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)
        
        selectButton = UIButton()
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.setTitle("SELECT", for: UIControlState())
        selectButton.setTitleColor(WhiteColor, for: UIControlState())
        selectButton.titleLabel?.font = UIFont(name: "Montserrat", size: 21.0)
        
        pointerImageView = UIImageView()
        pointerImageView.translatesAutoresizingMaskIntoConstraints = false
        pointerImageView.contentMode = .scaleAspectFit
        pointerImageView.image = UIImage(named: "tooltippointer")
        
        userDefaults = UserDefaults.standard
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = ClearColor
        
        closeButton.addTarget(self, action: #selector(ProfileIconPickerView.nextButtonDidTap(_:)), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(ProfileIconPickerView.selectTapped), for: .touchUpInside)
        
        scrollView.delegate = self
        
        view.addSubview(tintView)
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(pointerImageView)
        view.addSubview(closeButton)
        view.addSubview(selectButton)
        
        setupLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
    }
    
    func setupPages() {
        pageControl.numberOfPages = pageCount
        scrollView.contentSize = CGSize(width: pageWidth * CGFloat(pageCount),
            height: scrollView.frame.size.height)
        
        // Update the page control
        pageControl.currentPage = currentPage
        
        /// Load pages in our range
        for index in 0...pageCount - 1 {
            loadPage(index)
        }
    }
    
    func loadPage(_ page: Int) {
        let icon = ProfileIconView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tabBarIconImageView.image = pageImages[page]
        icon.currentPage = page
        icon.setupLayout()
        
        scrollView.addSubview(icon)
        scrollView.addConstraints([
            icon.al_top == scrollView.al_top,
            icon.al_height == scrollView.al_height,
            icon.al_width == scrollView.al_width,
            icon.al_left == scrollView.al_left + pageWidth * CGFloat(page)
        ])
        
        pageViews.append(icon)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Load the pages that are now on screen
        pageControl.currentPage = currentPage
        
        pointerAlignmentConstraint?.constant = arrowXOffset
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func nextButtonDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func selectTapped() {
        if let username = UserDefaults.standard.string(forKey: "username") {
            var pictureString = ""
            
            if currentPage == 0 {
                pictureString = "alien-head"
            } else if currentPage == 1 {
                pictureString = "atom"
            } else if currentPage == 2 {
                pictureString = "brain"
            } else if currentPage == 3 {
                pictureString = "circus-camel"
            } else if currentPage == 4 {
                pictureString = "cloud-and-moon"
            } else if currentPage == 5 {
                pictureString = "earth-globe"
            } else if currentPage == 6 {
                pictureString = "fire-gear"
            } else if currentPage == 7 {
                pictureString = "flask"
            } else if currentPage == 8 {
                pictureString = "giraffe"
            } else if currentPage == 9 {
                pictureString = "hot-air-balloon"
            } else if currentPage == 10 {
                pictureString = "islamic-art-1"
            } else if currentPage == 11 {
                pictureString = "islamic-art-2"
            } else if currentPage == 12 {
                pictureString = "oil-lamp"
            } else if currentPage == 13 {
                pictureString = "saturn"
            } else {
                pictureString = "brain"
            }
            
            
            FIRDatabase.database().reference().child("/users/\(username)/picture").setValue(pictureString)
            //userRef.setValue(pictureString)
            userDefaults.setValue("\(pictureString)", forKey: "picture")
            userDefaults.synchronize()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func setupLayout() {
        pointerAlignmentConstraint = pointerImageView.al_centerX == view.al_left + arrowXOffset
        
        view.addConstraints([
            tintView.al_top == view.al_top,
            tintView.al_bottom == view.al_bottom,
            tintView.al_left == view.al_left,
            tintView.al_right == view.al_right
        ])
        
        view.addConstraints([
            pageControl.al_centerX == scrollView.al_centerX,
            pageControl.al_bottom == scrollView.al_bottom - 18,
            pageControl.al_height == 5
        ])
        
        view.addConstraints([
            scrollView.al_centerY == view.al_centerY,
            scrollView.al_width == view.al_width - 20,
            scrollView.al_height == view.al_height - 40,
            scrollView.al_left == view.al_left + 10
        ])
        
        view.addConstraints([
            closeButton.al_top == view.al_top + 25,
            closeButton.al_right == view.al_right - 15,
            closeButton.al_height == 35,
            closeButton.al_width == 35
        ])
        
        view.addConstraints([
            selectButton.al_width == 200,
            selectButton.al_height == 40,
            selectButton.al_centerX == view.al_centerX,
            selectButton.al_top == view.al_bottom - 100
        ])
        
        view.addConstraints([
            pointerImageView.al_top == view.al_top + 20,
            pointerAlignmentConstraint!,
            pointerImageView.al_height == 25,
            pointerImageView.al_width == 15
        ])
    }
}
