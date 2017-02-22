//
//  Photo.swift
//  EyeVote
//
//  Created by Ilmira Estil on 2/9/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import Foundation

class Photo {
    internal let photoName: String? = ""
    internal let photoUrl: String?
    internal let upVotes: Int? = 0
    internal let downVotes: Int? = 0
    internal let owner: String? = ""
    internal var category: String? = ""
    
    init(photoURL: String, category: String) {
        self.photoUrl = photoURL
        self.category = category
    }
    
}
