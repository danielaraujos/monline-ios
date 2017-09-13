//
//  Monitoria.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 11/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Monitoria {


//    
//    description: close
//    name:
//    teacher:
//    tutor:
    
    
    private var _description = "";
    private var _name = "";
    private var _teacher = "";
    private var _tutor = "";
    
    init(name: String, description:String, teacher :String, tutor:String) {
        
        _name = name;
        _description = description
        _teacher = teacher
        _tutor = tutor
    }
    
    init(name: String, description:String) {
        
        _name = name;
        _description = description
    }
    
  
    var description: String {
        get {
            return _description;
        }
    }
    
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var teacher: String {
        get {
            return _teacher;
        }
    }
    
    var tutor: String {
        get {
            return _tutor;
        }
    }


}
