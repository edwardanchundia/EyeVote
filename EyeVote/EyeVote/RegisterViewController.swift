//
//  RegisterViewController.swift
//  EyeVote
//
//  Created by Ilmira Estil on 2/8/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = EyeVoteColor.darkPrimaryColor
        setupViewHierarchy()
        configureConstraints()
        view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(!animated)
        emailTextField.setUpUnderlineLayer()
        passwordTextField.setUpUnderlineLayer()
        name.setUpUnderlineLayer()
    }
    
    // MARK: - Setup
    func setupViewHierarchy() {
        self.view.addSubview(name)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(registerButton)
        self.view.addSubview(profileImage)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        // Logo
        profileImage.snp.makeConstraints({ (view) in
            view.centerX.equalTo(self.view)
            view.width.height.equalTo(150)
            view.top.equalToSuperview().offset(10)
        })
        
        // UserName TextField
        name.snp.makeConstraints({ (view) in
            view.top.equalTo(profileImage.snp.bottom).offset(40)
            view.centerX.equalTo(self.view)
            view.width.equalToSuperview().multipliedBy(0.8)
            view.height.equalTo(44)
        })
        
        //Password TextField
        emailTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(name.snp.bottom).offset(20)
            view.centerX.equalTo(self.view)
            view.width.equalTo(name.snp.width)
            view.height.equalTo(44)
        })
        
        // Login Button
        passwordTextField.snp.makeConstraints({ (view) in
            view.top.equalTo(emailTextField.snp.bottom).offset(20)
            view.centerX.equalTo(self.view)
            view.width.equalTo(emailTextField.snp.width)
            view.height.equalTo(44)
        })
        
        // Register Button
        registerButton.snp.makeConstraints({ (view) in
            view.bottom.equalTo(self.view.snp.bottom).inset(20)
            view.width.equalTo(270)
            view.height.equalTo(44)
            view.centerX.equalTo(self.view.snp.centerX)
        })
    }
    
    //    func gesturesAndControl() {
    //        registerButton.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
    //    }
    
    //MARK: - Setup user data
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    internal func tappedRegisterButton(sender: UIButton) {
        print("Register pressed")
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = name.text else {
            print("cannot validate username/password")
            return
        }
        
      
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("error adding user \(error)")
                
                //
                // Error Messages
                if !(self.emailTextField.text?.contains("@"))!{
                    let alertController = UIAlertController(title: "Shitty Email Input cause: \(error)", message: "That is totes cute you can't type in a correct email address. Totes", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "Close Me Bitch", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                if self.name.text?.characters.count == 0 {
                    let nameAlertController = UIAlertController(title: "You have a name, Don't you?", message: "I'll just call you Blank cause I'm forgetting you already", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Close Me Blank", style: .default, handler: nil)
                    nameAlertController.addAction(defaultAction)
                    self.present(nameAlertController, animated: true, completion: nil)
                    
                }
                
                if !(self.emailTextField.text?.contains("@"))!{
                    let alertController = UIAlertController(title: "Shitty Email Input", message: "That is totes cute you can't type in a correct email address. Totes", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "Close Me Bitch", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    
                    let alertController = UIAlertController(title: "Just Shitty Input", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    let defautAction = UIAlertAction(title: "Close Me Bitch", style: .default, handler: nil)
                    alertController.addAction(defautAction)
                    self.present(alertController, animated: true, completion: nil)
                //
                }
                
                
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
            changeRequest.displayName = self.name.text!
            changeRequest.commitChanges(completion: nil)
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
            
            if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://eyevotetest.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
 

    //MARK: - Lazy vars
    internal lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("REGISTER", for: .normal)
        button.setTitleColor(EyeVoteColor.textIconColor, for: .normal)
        button.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        button.layer.borderWidth = 0.8
        button.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    internal lazy var profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "logo")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    internal lazy var name: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        
        textField.textColor = EyeVoteColor.textIconColor
        textField.attributedPlaceholder = NSAttributedString(string: "NAME", attributes: [NSForegroundColorAttributeName : EyeVoteColor.accentColor ])

        return textField
    }()
    
    internal lazy var emailTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        
        textField.textColor = EyeVoteColor.textIconColor
        textField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSForegroundColorAttributeName : EyeVoteColor.accentColor ])

        return textField
    }()
    
    internal lazy var passwordTextField: UnderlinedTextField = {
        let textField = UnderlinedTextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSForegroundColorAttributeName : EyeVoteColor.accentColor ])
        //textField.layer.borderColor = UIColor.black.cgColor
        //textField.layer.borderWidth = 5
        textField.textColor = EyeVoteColor.textIconColor
        return textField
    }()
    
}
