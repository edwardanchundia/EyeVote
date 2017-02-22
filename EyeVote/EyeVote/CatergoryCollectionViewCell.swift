//
//  CatergoryCollectionViewCell.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/8/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit

class CatergoryCollectionViewCell: UICollectionViewCell {
    var something = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(something)
        something.snp.makeConstraints({ (view) in
            view.width.height.equalTo(contentView)
            view.center.equalTo(contentView.snp.center)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
