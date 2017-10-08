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

    
    func saveUser(withID: String, email: String, password: String, name: String, course: String, matricula: String) {
        let data: Dictionary<String, Any> = [
            Constantes.EMAIL: email,
            Constantes.SENHA: password,
            Constantes.NOME: name,
            Constantes.CURSO: course,
            Constantes.MATRICULA: matricula
        ];
        contactsRef.child(withID).setValue(data);
    }
    
    
    func getContacts() {
        
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var contacts = [Usuario]();
            
            if let myContacts = snapshot.value as? NSDictionary {
                //print(myContacts)
                for (key, value) in myContacts {
                    
                    if let contactData = value as? NSDictionary {
                       // print(contactData)
                        
                        if let email = contactData[Constantes.NOME] as? String {
                            //print(email)
                            let id = key as! String;
                            let newContact = Usuario(id: id, nome: email);
                            contacts.append(newContact);
                        }
                    }
                }
            }
            self.delegate?.dataReceived(contacts: contacts);
        }
        
    }
    
    
    func getPegarCursoUsuario()-> String{
        var retorno = " "
        contactsRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            
            if let myContacts = snapshot.value as? NSDictionary {
                //print(myContacts)
                for (key, value) in myContacts {
                    let id = AuthProvider.Instance.userID()
                    if(id  == key as! String){
                        if let contactData = value as? NSDictionary {
                            if let curso = contactData[Constantes.CURSO] as? String {
                                retorno = curso
                                //print("CURSO USUARIO: \(curso)")
                            }
                        }
                    }
                }
            }
            self.delegate?.userA(user: retorno)
        }
        return retorno
    }
    
    
    func getCourses(valor: String) {
        
        coursesRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var monitorias = [Curso]()
            if let cursos = snapshot.value as? NSDictionary {
                for (key, value) in cursos {
                    if(valor == key as! String){
                        if let dataCursos = value as? NSDictionary {
                            for (key, value) in dataCursos {
                                if let teste = value as? NSDictionary{
                                    for(key , value ) in teste {
                                        print(value)
                                        let newMonitorias = Curso(nome: value as! String, sigla: key as! String)
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
        monitoriasRef.observeSingleEvent(of: DataEventType.value) {
            (snapshot: DataSnapshot) in
            var details = [Monitoria]()
            
            if let monitoriasList = snapshot.value as? NSDictionary {
                for (key, value) in monitoriasList {
                    print("CHAVE \(key)")
                    if(valor ==  key as! String){
                        if let monitoriaDescription = value as? NSDictionary {
                            for (key, value) in monitoriaDescription {
                                let new = Monitoria(nome: key as! String, descricao: value as! String)
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
