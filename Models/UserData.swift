//
//  UserData.swift
//  finalproject
//
//  Created by Robert Thomas on 7/17/25.
//

import Foundation
import FirebaseAuth //gets us access to a Firebase User class/object

struct UserData{
    
    let uid: String
    let email: String? //optional email is returned by firebabse
    
    init(user: User) { //Type User if from Firebase User
        self.uid = user.uid
        self.email = user.email
    }
    
}
