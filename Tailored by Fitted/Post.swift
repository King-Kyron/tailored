//
//  Post.swift
//  Tailored by Fitted
//
//  Created by Kyron Loggins on 8/7/17.
//  Copyright © 2017 Kyron Loggins (HiddenGenius). All rights reserved.
//

import Foundation

class Post{
    var userID: String
    var postID: String
    var imageURL: String
    var caption: String
    
    
    init(userID: String, postID:String, imageURL: String, caption: String){
        self.userID = userID
        self.postID = postID
        self.imageURL = imageURL
        self.caption = caption
    }
    func getPostAsDictionary()->Dictionary<String,String>{
        let postDictionary = ["imageURL": imageURL,
                              "caption": caption]
        return postDictionary
    }
    
}
