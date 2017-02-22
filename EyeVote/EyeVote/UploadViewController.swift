
import UIKit
import Firebase


class UploadViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var user: User?
    var photos = [Photo]()
    let picker = UIImagePickerController()
    // Tesing so added extra categories
    let categories = ["Selfies", "Sunsets", "Puppies", "Kitties", "Nature", "Anime"]
    var categoryLabel = ""
    private let reuseId = "cellID"
    private let cellId = "cellId"
    var progressView: UIProgressView!
    var progressLabel: UILabel!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        view.setNeedsLayout()
        picker.delegate = self
        navigationItem.rightBarButtonItem = upArrow
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        photoTitletextField.setUpUnderlineLayer()
    }
    
    //MARK: - Actions - Photo upload
    func presentPic() {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.centerImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        //showBlackScreen()
        addPhotoToDB()
    }
    
    func showBlackScreen() {
        if let window = UIApplication.shared.keyWindow {
            blackScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissProgressBar)))
            
            window.addSubview(blackScreen)
            blackScreen.frame = window.frame
            blackScreen.alpha = 0
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackScreen.alpha = 1
                
            }, completion: nil)
            
        }
    }
    
    func dismissProgressBar() {
        self.blackScreen.alpha = 0
    }
    
    
    
    func uploadButtonPressed() {
        
        print("button pressed")
        presentPic()
//        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
//        guard let postName = currentUser.displayName else { return }
//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
//        guard let imageTitle = photoTitletextField.text else { return }
//        let ref = FIRDatabase.database().reference()
//        let storage = FIRStorage.storage().reference(forURL: "gs://eyevotetest.appspot.com")
//        
//        let key = ref.child("uploads").childByAutoId().key
//        let imageRef = storage.child("uploads").child(uid).child("\(key).jpg")
//        
//        let data = UIImageJPEGRepresentation(self.centerImageView.image!, 0.6)
//        
//        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
//            if error != nil {
//                print(error!.localizedDescription)
//                return
//            }
//            
//            imageRef.downloadURL(completion: { (url, error) in
//                if let url = url {
//                    let pic: [String: Any] = [
//                        "userID" : uid,
//                        "pathToImage" : url.absoluteString,
//                        "imageTitle" : imageTitle,
//                        "likes" : 0,
//                        "author" : postName,
//                        "postID" : key,
//                        "category" : self.categoryLabel]
//                    
//                    let postPic = ["\(key)" : pic]
//                    
//                    ref.child("uploads").updateChildValues(postPic)
//                    ref.child("Categories").child(self.categoryLabel).updateChildValues(postPic)
//                    
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//            
//        }
//        uploadTask.resume()
//        uploadTask.observe(.progress, handler: { snapshot in
//            //let progress = snapshot.progress?.completedUnitCount
//            let end = snapshot.progress?.fractionCompleted
//            let alertView = UIAlertController(title: "Uploading...", message: " ", preferredStyle: .alert)
//            self.present(alertView, animated: true, completion: {
//                let margin: CGFloat = 8.0
//                let rect = CGRect(x: margin, y: 72, width: alertView.view.frame.width - margin * 2.0, height: 2.0)
//                let progressView = UIProgressView(frame: rect)
//                progressView.setProgress(Float(end!), animated: true)
//                progressView.tintColor = UIColor.blue
//                alertView.view.addSubview(progressView)
//            })
//            print(end!)
//        })
    }
    
    func addPhotoToDB() {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        guard let postName = currentUser.displayName else { return }
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let imageTitle = photoTitletextField.text else { return }
        let ref = FIRDatabase.database().reference()
        let storage = FIRStorage.storage().reference(forURL: "gs://eyevotetest.appspot.com")
        
        let key = ref.child("uploads").childByAutoId().key
        let imageRef = storage.child("uploads").child(uid).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(self.centerImageView.image!, 0.6)
        
        let uploadTask = imageRef.put(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let pic: [String: Any] = [
                        "userID" : uid,
                        "pathToImage" : url.absoluteString,
                        "imageTitle" : imageTitle,
                        "likes" : 0,
                        "author" : postName,
                        "postID" : key,
                        "category" : self.categoryLabel]
                    
                    let postPic = ["\(key)" : pic]
                    
                    ref.child("uploads").updateChildValues(postPic)
                    ref.child("Categories").child(self.categoryLabel).updateChildValues(postPic)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        uploadTask.resume()

    }

    // MARK: - Setup
    func setupViewHierarchy() {
        view.addSubview(containerView)
        view.addSubview(centerImageView)
        view.addSubview(uploadsCollectionView)
        containerView.addSubview(buttonCategoriesCollectionView)
        containerView.addSubview(photoTitletextField)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        //ContainerView
        containerView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(75)
            view.top.equalToSuperview()
        })
        
        // Photo Title Text Field
        photoTitletextField.snp.makeConstraints({ (view) in
            view.width.equalTo(containerView.snp.width).multipliedBy(0.8)
            view.height.equalTo(30)
            view.top.equalTo(containerView.snp.top).offset(5)
            view.centerX.equalTo(containerView.snp.centerX)
        })
        // CollectionView
        // Maybe I should change set the height of the collection view and remove the top constraint
        buttonCategoriesCollectionView.snp.makeConstraints({ (view) in
            view.bottom.equalTo(containerView.snp.bottom)
            view.leading.equalTo(containerView.snp.leading)
            view.trailing.equalTo(containerView.snp.trailing)
            view.top.equalTo(photoTitletextField.snp.bottom)
            // view.height.equalTo(30)
            
            buttonCategoriesCollectionView.delegate = self
            buttonCategoriesCollectionView.dataSource = self
            buttonCategoriesCollectionView.register(CategoriesUploadCollectionViewCell.self, forCellWithReuseIdentifier: reuseId)
        })
        
        uploadsCollectionView.snp.makeConstraints ({ (view) in
            view.top.equalTo(centerImageView.snp.bottom)
            view.width.equalToSuperview()
            view.bottom.equalToSuperview()
            
            /*
            uploadsCollectionView.delegate = self
            uploadsCollectionView.dataSource = self
            uploadsCollectionView.register(UploadCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
             */
        })
        
        //Center ImageView
        centerImageView.snp.makeConstraints({ (view) in
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width)
            view.top.equalTo(containerView.snp.bottom)
        })
        
    }
    //  copy and pasted from LoginView. Get code working
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.buttonCategoriesCollectionView {
            return categories.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoriesUploadCollectionViewCell
        cell.backgroundColor = EyeVoteColor.primaryColor
        let category = categories[indexPath.row]
        cell.categoriesLabel.text = category
        return cell
         */
        
        if collectionView == buttonCategoriesCollectionView {
            let buttonCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoriesUploadCollectionViewCell
            //buttonCell.sizeThatFits(CGSize(width: view.frame.width/5, height: 30))
            buttonCell.backgroundColor = EyeVoteColor.primaryColor
            let category = categories[indexPath.row]
            buttonCell.categoriesLabel.text = category
            return buttonCell
        } else {
            let uploadCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UploadCollectionViewCell
            uploadCell.uploadImage.image = #imageLiteral(resourceName: "user_icon")
            return uploadCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! CategoriesUploadCollectionViewCell
        let category = categories[indexPath.row]
        cell.categoriesLabel.text = category
        
        
        let gallerycollectionView = GalleryCollectionViewController()
        gallerycollectionView.categorySelected = category
        //present(gallerycollectionView, animated: true, completion: nil)
        navigationController?.pushViewController(gallerycollectionView, animated: true)
 
        
        //for firebase
        self.categoryLabel = category
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width/5, height: 30)
    }
    
    
    // MARK: - Lazy Init
    internal lazy var photoTitletextField: UnderlinedTextField = {
        var textField = UnderlinedTextField()
        textField.placeholder = "TITLE"
        textField.attributedPlaceholder = NSAttributedString(string: "TITLE", attributes: [NSForegroundColorAttributeName : EyeVoteColor.accentColor ])
        return textField
    }()
    
    internal lazy var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = EyeVoteColor.primaryColor
        return view
    }()
    
    internal lazy var centerImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "Selfie10")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    internal lazy var upArrow: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = #imageLiteral(resourceName: "up_arrow")
        barButtonItem.style = .plain
        barButtonItem.target = self
        barButtonItem.action = #selector(uploadButtonPressed)
        //barButtonItem.action = #selector(presentPic)
        //barButtonItem.action = #selector(showBlackScreen)
        barButtonItem.tintColor = EyeVoteColor.accentColor
        return barButtonItem
    }()
    
    
    internal lazy var buttonCategoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = EyeVoteColor.primaryColor
        return collectionView
    }()
    
    internal lazy var uploadsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = EyeVoteColor.primaryColor
        return collectionView
    }()
    
    internal var blackScreen: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    internal var coloredView: UIView = {
        let view = UIView()
        view.backgroundColor = EyeVoteColor.primaryColor
        return view
    }()
    
    
}
