//
//  CategoriesUploadCollectionViewCell.swift
//  EyeVote
//
//  Created by John Gabriel Breshears on 2/9/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit

class CategoriesUploadCollectionViewCell: UICollectionViewCell {
    
    var categoriesLabel = UILabel()
    override var isSelected: Bool {
        didSet {
            categoriesLabel.backgroundColor = isSelected ? EyeVoteColor.accentColor : EyeVoteColor.primaryColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoriesLabel.textColor = EyeVoteColor.textIconColor
        categoriesLabel.layer.borderColor = EyeVoteColor.textIconColor.cgColor
        categoriesLabel.layer.borderWidth = 0.8
        categoriesLabel.textAlignment = .center
        categoriesLabel.sizeToFit()
        categoriesLabel.numberOfLines = 0
        categoriesLabel.backgroundColor = EyeVoteColor.primaryColor
        //categoriesLabel.setContentHuggingPriority(0.0, for: .horizontal)
        categoriesLabel.text = ""
        
        contentView.addSubview(categoriesLabel)
        categoriesLabel.snp.makeConstraints({ (view) in
            view.width.height.equalTo(contentView)
            
            //view.width.height.equalTo(contentView)
            view.center.equalTo(contentView.snp.center)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
