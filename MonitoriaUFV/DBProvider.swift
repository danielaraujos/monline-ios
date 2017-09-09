//
//  DBProvider.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 27/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider {

    private static let _instance = DBProvider()
    
    private init(){}
    
    static var Instance: DBProvider{
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference();
    }
    
    var contactsRef: DatabaseReference {
        return dbRef.child(Constants.CONTACTS);
    }
    
    var messagesRef: DatabaseReference {
        return dbRef.child(Constants.MESSAGES);
    }
    
    var mediaMessagesRef: DatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    
    func saveUser(withID: String, email: String, password: String, name: String, course: String, matricula: String) {
        let data: Dictionary<String, Any> = [
            Constants.EMAIL: email,
            Constants.PASSWORD: password,
            Constants.NAME: name,
            Constants.COURSE: course,
            Constants.MATRICULA: matricula
            
        ];
        
        contactsRef.child(withID).setValue(data);
    }


 }
