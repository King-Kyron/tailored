//
//  User.swift
//  Tailored by Fitted
//
//  Created by Kyron Loggins on 8/7/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//

import Foundation

class User{
    var bio: String
    var display: String
    var email: String
    var photo: String
    var username: String
    
    init(bio: String, display: String, email: String, photo: String, username:String){
        self.bio = bio
        self.display = display
        self.email = email
        self.photo = photo
        self.username = username
        
    }
    func getUserAsDictionary()->Dictionary<String, String>{
        let newUserDictionary = ["bio":self.bio,
                                 "display":self.display,
                                 "email": self.email,
                                 "photo":self.photo,
                                 "username": self.username]
        return newUserDictionary
        
    }
    
    
}

