//
//  CommentsCollectionViewController.swift
//
//
//  Created by Komran Ghahremani on 5/8/17.
//
//

import UIKit

class CommentCollectionViewController: UITableViewController, UITextFieldDelegate, CommentViewModelDelegate {
    var viewModel: CommentViewModel
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
        viewModel.delegate = self
        view.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        // Register cell classes
        if let tableView = tableView {
            tableView.backgroundColor = UIColor(red: 18.0/255.0, green: 19.0/255.0, blue: 20.0/255.0, alpha: 1.0)
            tableView.alwaysBounceVertical = true
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "commentCell")   
        }
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .compose,
                                          target: self,
                                          action: #selector(CommentCollectionViewController.composeComment))
        
        let logoImageView = UILabel()
        logoImageView.text = "comments".uppercased()
        logoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        logoImageView.font = UIFont(name: "Montserrat-Regular", size: 12.0)
        logoImageView.textColor = UIColor.white
        logoImageView.textAlignment = .center
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.titleView = logoImageView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.requestComments()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.comments.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        return header
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
        cell.dateLabel.text = viewModel.comments[indexPath.section].date
        cell.textView.text = viewModel.comments[indexPath.section].text
        cell.authorLabel.setTitle(viewModel.comments[indexPath.section].author, for: .normal)
        
        return cell
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func composeComment() {
        let vc = AddCommentViewController(dream: viewModel.dream)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func commentsDidLoad() {
        tableView.reloadData()
    }
}
