
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var currentUser: User?
    let reuseableCellIdentifier = "Cell"
    var profilePhoto: URL?
    var currentUserUid: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Hi \(FIRAuth.auth()?.currentUser?.displayName)!"
        //self.navigationItem.backBarButtonItem? = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(navigateBack))
        
        //navigationController?.isNavigationBarHidden = false
        setupViewHierarchy()
        configureConstraints()
        gesturesAndControls()
        votesTableView.delegate = self
        
        //        if self.currentUser != nil {
        //            dump("PROFILE STUFF >>>>>\(self.currentUser)")
        //        }
        
        //fetchUser(currentUserUid!)
        //dump("PROFILE STUFF >>>>>\(currentUserUid)")
        //dump("MORE PROFILE STUFF >>>>>\(self.currentUser?.name)")
        
        //profile image
        
        if let url = FIRAuth.auth()?.currentUser?.photoURL {
            self.profilePhoto = url
            dump("PROFILE URL >>>>> \(url)")
            self.profileImage.downloadImageFB(from: String(describing: url))
        }
        
    }

    func fetchUser(_ uid: String) {
        let ref = FIRDatabase.database().reference()
        //let uid = FIRAuth.auth()?.currentUser?.uid
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let uploads = snapshot.value as! [String: AnyObject]
            
            for (_,value) in uploads {
                //dump(value)
                
                //let userName = User(name: name, email: "", password: "", profileImageUrl: "")
                if let name = value["name"] as? String {
                    self.currentUser?.name = name
                    dump("NAME>>>>>> \(name)")
                    dump("current user's name: \(FIRAuth.auth()?.currentUser?.displayName)")
                }
            }
            
        })
        ref.removeAllObservers()
    }
    
    func navigateBack() {
        //let navController = UINavigationController(rootViewController: GalleryViewController())
        //let backNavigateController = GalleryViewController()
        //navigationController?.pushViewController(navController, animated: true)
        
    }
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCellIdentifier, for: indexPath) as! ProfileTableViewCell
        
        //let image = #imageLiteral(resourceName: "user_icon")
        
        //if let url = FIRAuth.auth()?.currentUser?.photoURL {
        cell.pictureUploaded.downloadImageFB(from: String(describing: profilePhoto))
            cell.pictureUploaded.layer.cornerRadius = 35
        //}
        
        
        if let name = FIRAuth.auth()?.currentUser?.displayName {
            cell.voteDescriptionLabel.text = "\(name) voted picture up. "
        }
        
        
        cell.timeStamp.text = "03:14PM"
        cell.timeStamp.font = UIFont.systemFont(ofSize: 10)
        cell.timeStamp.textColor =  UIColor.gray
        
        return cell
    }
    
    //MARK: - Collection View
    
    private let reuseId = "cellID"
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! UploadCollectionViewCell
        
        cell.uploadImage.image = #imageLiteral(resourceName: "user_icon")
        
        return cell
    }
    
    // MARK: - Setup
    func setupViewHierarchy() {
        self.view.addSubview(profileImage)
        self.view.addSubview(votesTableView)
        self.view.addSubview(uploadCollectionView)
        self.view.addSubview(yourUploadLabel)
    }
    
    internal func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //Profile Picture
        profileImage.snp.makeConstraints({ (view) in
            view.top.width.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.3)
        })
        
        //Votes Table View
        votesTableView.snp.makeConstraints({ (view) in
            view.top.equalTo(profileImage.snp.bottom)
            view.width.equalToSuperview()
            view.height.equalToSuperview().multipliedBy(0.5)
        })
        votesTableView.delegate = self
        votesTableView.dataSource = self
        votesTableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: reuseableCellIdentifier)
        
        //Upload Picture Collection View
        uploadCollectionView.snp.makeConstraints({ (view) in
            view.top.equalTo(votesTableView.snp.bottom)
            view.width.equalToSuperview()
            view.bottom.equalTo(yourUploadLabel.snp.top)
        })
        uploadCollectionView.delegate = self
        uploadCollectionView.dataSource = self
        uploadCollectionView.register(UploadCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        
        //Your Upload Label
        yourUploadLabel.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(20)
            view.top.equalTo(uploadCollectionView.snp.bottom)
            view.bottom.equalToSuperview()
        })
    }
    
    // MARK: - Actions
    func gesturesAndControls() {
        navigationItem.rightBarButtonItem = navBarLogOut
    }
    
    // MARK: - LOG OUT BUTTON
    func logOutButton() {
        do {
            try FIRAuth.auth()?.signOut()
        }   catch let error {
            print("logout error \(error)")
        }
        
        //let loginController = LogInViewController()
        //self.present(loginController, animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Lazy Init
    internal lazy var navBarLogOut: UIBarButtonItem = {
        var navButton = UIBarButtonItem()
        navButton.tintColor = EyeVoteColor.accentColor
        navButton.title = "LOGOUT"
        navButton.style = .plain
        navButton.target = self
        navButton.action = #selector(logOutButton)
        return navButton
    }()
    
    
    internal lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Selfie10")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal lazy var votesTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.black
        return tableview
    }()
    
    internal lazy var uploadCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        //cv.backgroundColor = UIColor.darkGray
        return cv
    }()
    
    internal lazy var yourUploadLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = EyeVoteColor.darkPrimaryColor
        label.text = "YOUR UPLOADS"
        label.textColor = EyeVoteColor.accentColor
        return label
    }()
    
}
