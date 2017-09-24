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
}


