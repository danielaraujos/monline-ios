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
    func dataCourse(monitorias: [Course]);
    func dataMonitorias (detail : [Monitoria]);
    

}

class DBProvider {
    
    private static let _instance = DBProvider();
    
    weak var delegate: FetchData?;
    var curso_user = "";
    
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
    
    var monitoriasRef: DatabaseReference {
        return dbRef.child(Constants.MONITORIAS)
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
                       // print(contactData)
                        
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
        
        var retorno = " "
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            
            if let myContacts = snapshot.value as? NSDictionary {
                //print(myContacts)
                for (key, value) in myContacts {
                    var id = AuthProvider.Instance.userID()
                    
                    if(id  == key as! String){
                        if let contactData = value as? NSDictionary {
                           // print(contactData)
                            if let curso = contactData[Constants.COURSE] as? String {
                                retorno = curso
                            }
                        }
                    }
                }
            }
        }
        
        return retorno
    }
    
    
    func getCourses(valor: String) {
        
        coursesRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var monitorias = [Course]()
            if let cursos = snapshot.value as? NSDictionary {
                for (key, value) in cursos {
                    //print(key)
                    if(valor == key as! String){
                        if let dataCursos = value as? NSDictionary {
                            for (key, value) in dataCursos {
                                if let teste = value as? NSDictionary{
                                    for(key , value ) in teste {
                                        let newMonitorias = Course(name: value as! String, sigla: key as! String)
                                        monitorias.append(newMonitorias)
                                    }
                                }
                            }
                        }else {
                            continue
                        }
                    }
                }
            }
            self.delegate?.dataCourse(monitorias: monitorias);
        }
    }

    
    
    func getMonitoria(valor: String){
        print("GETMONITORIAS")
        monitoriasRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var details = [Monitoria]()
            
            if let monitoriasList = snapshot.value as? NSDictionary {
                for (key, value) in monitoriasList {
                    //print("CHAVE \(key)")
                    if(valor ==  key as! String){
                        if let monitoriaDescription = value as? NSDictionary {
                            for (key, value) in monitoriaDescription {
                                let new = Monitoria(name: key as! String, description: value as! String)
                                details.append(new)
                            }
                        }
                    }
                    
                }
            }
            self.delegate?.dataMonitorias(detail: details);
        }
    }
   
    

 }
