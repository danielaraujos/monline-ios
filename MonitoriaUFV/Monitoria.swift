//
//  Monitoria.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 11/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Monitoria : NSObject {

    //Variaveis
    var nome: String?;
    var professor: String?;
    var descricao: String?;
    var monitor: String?;

    init(nome: String, descricao:String, professor :String, monitor:String) {
        self.nome = nome;
        self.descricao = descricao
        self.professor = professor
        self.monitor = monitor
    }
    
    init(nome: String) {
        self.nome = nome;
    }
    
    init(dictionary: [String: Any]) {
        self.nome = dictionary["nome"] as? String
        self.descricao = dictionary["descricao"] as? String
        self.professor = dictionary["professor"] as? String
        self.monitor = dictionary["monitor"] as? String
    }
    
    init(nome: String, descricao:String) {
        self.nome = nome;
        self.descricao = descricao
    }
}
