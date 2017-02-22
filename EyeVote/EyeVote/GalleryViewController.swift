//
//  ViewController.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/6/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import Firebase

class GalleryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let categories = ["Latte Art", "Puppies", "Kitties", "Roof Top View", "Anime", "Sunset", "Selfies"]
    lazy var photos = [Photo]()
    var category = String()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        populateViewTopPics()
    }
    

    //MARK: - Download images from firebase
    func fetchPhotos(_ category: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("Categories").child(category).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let categories = snapshot.value as! [String: AnyObject]
            
            for (_,value) in categories {
                
                if let photoUrl = value["pathToImage"] as? String,
                    let category = value["category"] as? String {
                    let photo = Photo(photoURL: photoUrl, category: category)
                    self.photos.append(photo)
                }
            }
            self.categoryTableView.reloadData()
            
        })
        ref.removeAllObservers()
    }
    
    func populateViewTopPics() {
        let ref = FIRDatabase.database().reference()
        ref.child("uploads").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let uploads = snapshot.value as! [String: AnyObject]
            
            for (_,value) in uploads {
                
                if let photoUrl = value["pathToImage"] as? String,
                    let category = value["category"] as? String {
                    let photo = Photo(photoURL: photoUrl, category: category)
                    self.photos.append(photo)
                }
                
            }
            self.categoryTableView.reloadData()
            
        })
        ref.removeAllObservers()
    }
    
    
    
    // MARK: - Setup
    func setupViewHierarchy(){
        view.addSubview(categoryTableView)
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("PHOTO COUNT \(photos.count)")
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GalleryTableViewCell
        
        let category = self.categories[indexPath.row]
        cell.categoryLabel.text = category.uppercased()
        cell.backgroundColor = UIColor.black
        cell.categoryImage.alpha = 0.5
        
        
        //Cell Images
        for photo in photos {
            if photo.category == category {
                cell.categoryImage.downloadImageFB(from: photo.photoUrl)
            }
        }
        

        return cell
    }
    
    
    //navigationController?.pushViewController(galleryCollectionView, animated: true)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = indexPath.row
        self.category = categories[selectedRow]
        let galleryCollectionView = GalleryCollectionViewController()
        galleryCollectionView.categorySelected = categories[selectedRow]
        
        navigationController?.pushViewController(galleryCollectionView, animated: true)
    }

    
    // MARK: - Lazy TableView
    internal lazy var categoryTableView: UITableView = {
        var tableView = UITableView()
        tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.rowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GalleryTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
}

extension UIImageView {
    
    func downloadImageFB(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
            }
            
        }
        
        task.resume()
    }
}
