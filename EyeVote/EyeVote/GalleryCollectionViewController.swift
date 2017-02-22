//
//  GalleryCollectionViewController.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/6/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class GalleryCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var categorySelected: String?
    
    var categoryPhotos = [Photo]()
    
    var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = categorySelected?.uppercased()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.frame.width * 0.5) - 5, height: view.frame.height * 0.25)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CatergoryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = EyeVoteColor.primaryColor
        self.view.addSubview(collectionView)
        
        if let categorySelected = categorySelected {
            fetchPhotos(categorySelected)
        }
   
    }
    
    //MARK: - fetch photos
    func fetchPhotos(_ category: String) {
        let ref = FIRDatabase.database().reference()
        ref.child("Categories").child(category).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let categories = snapshot.value as! [String: AnyObject]
            
            for (_,value) in categories {
                
                if let photoUrl = value["pathToImage"] as? String,
                    let category = value["category"] as? String {
                    let photo = Photo(photoURL: photoUrl, category: category)
                    self.categoryPhotos.append(photo)
                }
                
            }
            self.collectionView.reloadData()
            
        })
        ref.removeAllObservers()
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CatergoryCollectionViewCell
        cell.backgroundColor = .white
        
        if categoryPhotos.count != 0 {
                cell.something.downloadImageFB(from: categoryPhotos[indexPath.row].photoUrl)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gdvc = GalleryDetailViewController()
        gdvc.selectedPhoto = categoryPhotos[indexPath.row]
        
        navigationController?.pushViewController(gdvc, animated: true)
    }
    


}
