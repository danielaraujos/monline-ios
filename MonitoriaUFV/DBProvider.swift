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
    func dataReceived(contacts: [Usuario]);
    func dataCourse(monitorias: [Curso]);
    func dataMonitorias (detail : [Monitoria]);
    func userA (user: String)
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
        return dbRef.child(Constantes.USUARIOS);
    }
    
    var coursesRef: DatabaseReference{
        return dbRef.child(Constantes.CURSOS)
    }
    
    var monitoriasRef: DatabaseReference {
        return dbRef.child(Constantes.MONITORIAS)
    }
    
    var messagesRef: DatabaseReference {
        return dbRef.child(Constantes.MENSAGENS);
    }
    
    var mediaMessagesRef: DatabaseReference {
        return dbRef.child(Constantes.MEDIA_MESSAGES);
    }
    
    
    var storageRef: StorageReference {
        return Storage.storage().reference(forURL: "gs://monitoriaufv-65054.appspot.com");
    }
    
    var imageStorageRef: StorageReference {
        return storageRef.child(Constantes.IMAGE_STORAGE);
    }
    
    var videoStorageRef: StorageReference {
        return storageRef.child(Constantes.VIDEO_STORAGE);
    }

    
    func saveUser(withID: String, email: String, password: String, name: String, course: String, matricula: String, monitor: String) {
        let data: Dictionary<String, Any> = [
            Constantes.EMAIL: email,
            Constantes.SENHA: password,
            Constantes.NOME: name,
            Constantes.CURSO: course,
            Constantes.MATRICULA: matricula,
            Constantes.MONITOR: monitor
        ];
        contactsRef.child(withID).setValue(data);
    }
    
    
  
 }
