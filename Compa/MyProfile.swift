//
//  MyProfile.swift
//  Compa
//
//  Created by MacBook Pro on 5/9/2560 BE.
//  Copyright © 2560 CyberWorks. All rights reserved.
//

import UIKit

// Globally can use anywhere
struct MyProfile {

    //MARK: Properties
    var id: String?
    var name: String?
    var photoUrl: String?
    var nsBirthday: NSDate?
    var birthday: String?
    var gender: String?
    
    static var sharedInstance = MyProfile()
    
    private init() {}
    
    /*
    init?(id: String, name: String, photoUrl: String?, nsBirthday: NSDate?, birthday: String?) {
        if name.isEmpty {
            return nil
        }
        self.id = id
        self.name = name
        //self.photo = photo
        self.photoUrl = photoUrl
        self.nsBirthday = nsBirthday
        self.birthday = birthday
    }
 */
    
}
