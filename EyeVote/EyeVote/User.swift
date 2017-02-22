//
//  User.swift
//  EyeVote
//
//  Created by Ilmira Estil on 2/7/17.
//  Copyright © 2017 Edward Anchundia. All rights reserved.
//

import Foundation


class User {
    internal var name: String?
    internal var email: String?
    internal var password: String?
    internal var profileImageUrl: String?
    
    init(name: String, email: String, password: String, profileImageUrl: String){
        self.name = name
        self.email = email
        self.password = password
        self.profileImageUrl = profileImageUrl
    }
}




