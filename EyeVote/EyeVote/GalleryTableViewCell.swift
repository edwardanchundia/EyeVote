//
//  TableViewCell.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/6/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit
import Firebase

class GalleryTableViewCell: UITableViewCell {
    
    var categoryLabel = UILabel()
    var categoryImage = UIImageView()
    var mainCategoryImages = [Photo]()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        categoryImage.image = nil
        
        categoryImage.backgroundColor = EyeVoteColor.darkPrimaryColor
        categoryLabel.textColor = EyeVoteColor.textIconColor
        categoryLabel.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        categoryLabel.layer.borderWidth = 2
        categoryLabel.textAlignment = .center
        categoryImage.clipsToBounds = true
        categoryImage.contentMode = UIViewContentMode.scaleAspectFill
        
        
        self.contentView.addSubview(categoryImage)
        self.contentView.addSubview(categoryLabel)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryImage.snp.makeConstraints { (view) in
            view.width.equalTo(contentView.snp.width)
            view.height.equalTo(contentView.snp.height)
            view.center.equalTo(contentView.center)
        }
        
        categoryLabel.snp.makeConstraints { (view) in
            view.width.equalTo(150)
            view.height.equalTo(50)
            view.center.equalTo(categoryImage.snp.center)
        }
    }

}
