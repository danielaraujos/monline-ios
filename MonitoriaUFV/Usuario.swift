//
//  Contact.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 09/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Usuario  : NSObject {
    
    //Variaveis
    var id: String?;
    var curso: String?;
    var matricula: String?;
    var nome: String?;
    var senha: String?;
    var ImagemURL: String?;
    var email: String?;
    var monitor: String?
    //var tipo: String?;
    
    //Construtores
    init(curso: String) {
        self.curso = curso;
    }
    
    init(id: String) {
        self.id = id;
    }
    
    init(id: String, nome: String) {
        self.id = id;
        self.nome = nome;
    }
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.nome = dictionary["nome"] as? String
        self.email = dictionary["email"] as? String
        self.curso = dictionary["curso"] as? String
        self.matricula = dictionary["matricula"] as? String
        self.senha = dictionary["senha"] as? String
        self.monitor = dictionary["monitor"] as? String
        self.ImagemURL = dictionary["ImagemURL"] as? String
    }
    
}
