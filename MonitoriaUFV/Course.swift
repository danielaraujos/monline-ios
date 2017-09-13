//
//  Course.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 09/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Course {
    
    
    private var _type = "";
    private var _name = "";
    private var _sigla = "";
    
    init(name: String, sigla:String) {
        
        _name = name;
        _sigla = sigla
    }
    
    init(sigla: String) {
        _sigla = sigla;
    }
    
    var sigla: String {
        get {
            return _sigla;
        }
    }
    
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var type: String {
        get {
            return _type;
        }
    }
    
  
    
}


