//
//  GalleryDetailViewController.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/6/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import Firebase

class GalleryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: User?
    var selectedPhoto: Photo?
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = selectedPhoto?.photoName
        
        self.view.backgroundColor = EyeVoteColor.darkPrimaryColor
        tableView.register(GalleryDetailCell.self, forCellReuseIdentifier: cellIdentifier)
        setupViewHierarchy()
        configureConstraints()
        
        retrievePics()
        
        
        fetchUser()
        
    }
    
    //MARK: - Firebase, call to Storage to retrieve DATA on specific PHOTO
    func retrievePics() {
        guard let url = selectedPhoto?.photoUrl else { return }
        let storageRef = FIRStorage.storage().reference(forURL: url)
        
        storageRef.downloadURL { (url, error) in
            if error != nil {
                print("error downloading pic \(error)")
            }
            if let url = url {
                self.mainImage.downloadedFrom(url: url)
            }
            
        }
    }
    
    func fetchUser() {
        if FIRAuth.auth()?.currentUser?.uid != nil {
            let ref = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            ref.child("users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                let uploads = snapshot.value as! [String: AnyObject]
                
                for (_,value) in uploads {
                    //dump(value)
                    if let name = value["name"] as? String {
                        let userName = User(name: name, email: "", password: "", profileImageUrl: "")
                        self.currentUser = userName
                    }
                    
                }
                
            })
            ref.removeAllObservers()
        }
    }
    
    
    //MARK: Setup Constraints and Hierarchy
    private func setupViewHierarchy() {
        self.view.addSubview(tableView)
        self.view.addSubview(mainImageContainer)
        
        mainImageContainer.addSubview(mainImage)
        mainImageContainer.addSubview(voteContainer)
        mainImage.addSubview(mainButtonContainer)
        self.view.addSubview(upVoteButton)
        self.view.addSubview(downVoteButton)
        voteContainer.addSubview(upVoteLabel)
        voteContainer.addSubview(downVoteLabel)
        
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //main image
        mainImageContainer.snp.makeConstraints { (view) in
            view.top.equalToSuperview().offset(16.0)
            view.centerX.equalToSuperview()
            view.width.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.5)
        }
        
        mainImage.snp.makeConstraints { (view) in
            view.top.leading.trailing.equalToSuperview()
            view.height.equalTo(mainImageContainer.snp.height)
            view.width.equalTo(mainImageContainer.snp.width)
        }
        
        //main button containers
        mainButtonContainer.snp.makeConstraints { (view) in
            view.bottom.equalTo(mainImageContainer.snp.bottom)
            view.width.equalTo(mainImageContainer.snp.width)
            view.height.equalTo(mainImageContainer).multipliedBy(0.25)
        }
        
        voteContainer.snp.makeConstraints { (view) in
            view.bottom.equalTo(mainImageContainer.snp.bottom)
            view.leading.trailing.equalToSuperview()
            view.height.equalTo(mainButtonContainer.snp.height).multipliedBy(0.25)
            
        }
        
        upVoteButton.snp.makeConstraints { (view) in
            view.leading.equalToSuperview()
            view.bottom.equalTo(mainButtonContainer.snp.centerY)
            view.trailing.equalTo(mainImage.snp.centerX)
        }
        
        upVoteLabel.snp.makeConstraints { (view) in
            view.leading.equalTo(voteContainer.snp.leading).offset(92.0)
            view.top.equalTo(voteContainer.snp.top)
            view.bottom.equalTo(voteContainer.snp.bottom)
        }
        
        
        downVoteButton.snp.makeConstraints { (view) in
            view.trailing.equalToSuperview()
            view.bottom.equalTo(mainButtonContainer.snp.centerY)
            view.leading.equalTo(mainImage.snp.centerX)
        }
        
        downVoteLabel.snp.makeConstraints { (view) in
            view.trailing.equalTo(voteContainer.snp.trailing).inset(92.0)
            view.top.equalTo(voteContainer.snp.top)
            view.bottom.equalTo(voteContainer.snp.bottom)
        }
        
        
        //main tableView
        tableView.snp.makeConstraints { (view) in
            view.top.equalTo(mainImageContainer.snp.bottom).offset(8.0)
            view.bottom.equalToSuperview()
            view.width.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    //MARK: - Setup Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GalleryDetailCell
        
        cell.voteLabel.text = currentUser?.name
        
        
        return cell
    }
    
    //MARK: - Button functions
    func downVote() {
        print("\(currentUser?.email) downvote this shit")
        self.downVoteLabel.text = "\(String(Int(downVoteLabel.text!)! - 1))"
        
    }
    
    func upVotePicture() {
        print("upvote this shit")
        self.upVoteLabel.text = "\(String(Int(upVoteLabel.text!)! + 1))"
        
    }
    
    
    //MARK: - Buttons & Views
    internal lazy var upVoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = EyeVoteColor.accentColor
        label.text = "1"
        return label
    }()
    
    internal lazy var downVoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = EyeVoteColor.accentColor
        label.text = "34"
        return label
    }()
    
    internal lazy var upVoteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "up_arrow"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(upVotePicture), for: .touchUpInside)
        return button
    }()
    
    internal lazy var downVoteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
        button.tintColor = EyeVoteColor.accentColor
        button.addTarget(self, action: #selector(downVote), for: .touchUpInside)
        return button
    }()
    
    internal lazy var mainImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.layer.masksToBounds = true
        return view
    }()
    
    internal lazy var mainImage: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        return imageView
    }()
    
    internal lazy var mainButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = EyeVoteColor.primaryColor
        view.layer.masksToBounds = true
        view.alpha = 0.5
        return view
    }()
    
    internal lazy var voteContainer: UIView = {
        let view = UIView()
        view.backgroundColor = EyeVoteColor.darkPrimaryColor
        view.layer.masksToBounds = true
        return view
    }()
    
    internal lazy var tableView: UITableView = {
        var categoryTableView = UITableView()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "Cell")
        return categoryTableView
    }()
    
}
//MARK: - Extension
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
