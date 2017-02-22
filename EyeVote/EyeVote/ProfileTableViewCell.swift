//
//  ProfileTableViewCell.swift
//  EyeVote
//
//  Created by Edward Anchundia on 2/7/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    var pictureUploaded = UIImageView()
    var voteDescriptionLabel = UILabel()
    var timeStamp = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        pictureUploaded.setRounded()
        
        self.contentView.addSubview(pictureUploaded)
        self.contentView.addSubview(voteDescriptionLabel)
        self.contentView.addSubview(timeStamp)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pictureUploaded.snp.makeConstraints({ (view) in
            view.leading.equalTo(contentView.snp.leading).inset(5)
            view.width.equalTo(50)
            view.height.equalTo(contentView.snp.height)
        })
        
        voteDescriptionLabel.snp.makeConstraints({ (view) in
            view.leading.equalTo(pictureUploaded.snp.leading).inset(60)
            view.width.equalTo(contentView.snp.width).multipliedBy(0.6)
            view.height.equalTo(contentView.snp.height)
        })

        timeStamp.snp.makeConstraints({ (view) in
            view.trailing.equalTo(contentView.snp.trailing)
            view.width.equalTo(70)
            view.height.equalTo(contentView.snp.height)
        })
    }

}

extension UIImageView {
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.masksToBounds = true
    }
}
