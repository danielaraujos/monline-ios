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

protocol FetchData: class {
    func dataReceived(contacts: [Contact]);
    func dataMonitorias(monitorias: [Course]);

}

class DBProvider {
    
    private static let _instance = DBProvider();
    
    weak var delegate: FetchData?;
    
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
    
    var coursesRef: DatabaseReference{
        return dbRef.child(Constants.COURSES)
    }
    
    var messagesRef: DatabaseReference {
        return dbRef.child(Constants.MESSAGES);
    }
    
    var mediaMessagesRef: DatabaseReference {
        return dbRef.child(Constants.MEDIA_MESSAGES);
    }
    
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://monitoriaufv-65054.appspot.com");
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child(Constants.IMAGE_STORAGE);
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child(Constants.VIDEO_STORAGE);
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
    
    
    func getContacts() {
        
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var contacts = [Contact]();
            
            if let myContacts = snapshot.value as? NSDictionary {
                //print(myContacts)
                for (key, value) in myContacts {
                    
                    if let contactData = value as? NSDictionary {
                        //print(contactData)
                        
                        if let email = contactData[Constants.NAME] as? String {
                            //print(email)
                            let id = key as! String;
                            let newContact = Contact(id: id, name: email);
                            contacts.append(newContact);
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }
        
    }
    
    
    func getCurseUser()-> String{
        var cursoUser = ""
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            
            if let myContacts = snapshot.value as? NSDictionary {
                //print(myContacts)
                for (key, value) in myContacts {
                    let id = AuthProvider.Instance.userID()
                    
                    if(id  == key as! String){
                        if let contactData = value as? NSDictionary {
                            if let curso = contactData[Constants.COURSE] as? String {
                                cursoUser = curso
                                
                            }
                            
                        }
                    }
                    
                    
                }
            }
        }
        print(cursoUser)
        return cursoUser
        
    }
   


    
    func getCourses() {
        
        //var cursoUser = self.getCurseUser()
        //print(" \(cursoUser)")
        
        coursesRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            
            var monitorias = [Course]()
            if let cursos = snapshot.value as? NSDictionary {
                for (key, value) in cursos {
                    //if("SIN" == key as! String){
                        if let coursesData = value as? NSDictionary{
                            for (key, value) in coursesData {
                                if let monitoriasData = value as? NSDictionary{
                                    for (key, value) in monitoriasData {
                                        //print(key)
                                        let newMonitorias = Course(course: key as! String)
                                        monitorias.append(newMonitorias)
                                        for (key, value) in monitoriasData {
                                            print(key)
                                            print(value)
                                            print("/n")
                                        }
                                    }
                                }
                            }
                        }

//                    }else{
//                        print("Entrou aqui!")
//                        var teste = ""
//                        print(teste)
//                        let newMonitorias = Course(course: teste )
//                        monitorias.append(newMonitorias)
//                    }
                    
                    
                }
            }
            self.delegate?.dataMonitorias(monitorias: monitorias);
        }
    }



 }
