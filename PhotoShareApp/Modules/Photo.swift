//
//  Photo.swift
//  PhotoShareApp
//
//  Created by Leon Grinshpun on 16/07/2021.
//

import Foundation

class Photo : Equatable{
    
    
    var description: String!
    var photoRef: String!
    var username: String!
    var userRef: String!

    init(description: String , photoRef: String, username: String , userRef:String){
        self.description = description
        self.photoRef = photoRef
        self.userRef = userRef
        self.username = username
    }
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        return lhs.description == rhs.description && lhs.photoRef == rhs.photoRef && lhs.userRef == rhs.userRef && lhs.username == rhs.username
    }
    init(){}
}
