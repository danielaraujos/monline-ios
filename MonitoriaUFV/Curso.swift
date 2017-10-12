//
//  Course.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 09/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Curso{
    
    //Variaveis
    var id: String?;
    var nome: String?;
    var sigla: String?;
    var tipo: String?;
    
    //Construtores
    init(nome: String, sigla:String) {
        self.nome = nome;
        self.sigla = sigla
    }
    
    init(sigla: String) {
        self.sigla = sigla;
    }
    
    init(nome: String) {
        self.nome = nome;
    }
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.nome = dictionary["nome"] as? String
        self.sigla = dictionary["sigla"] as? String
        //self.tipo = dictionary["tipo"] as? String
    }
}


