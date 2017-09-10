//
//  Contact.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 09/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Contact {
    
    private var _id = "";
    private var _course = "";
    private var _matricula = "";
    private var _name = "";
    private var _password = "";
    
    
    init(id: String, name: String) {
        _id = id;
        _name = name;
    }
    
    init(id: String, name: String, course:String, matricula:String) {
        _id = id;
        _name = name;
        _course = course;
        _matricula = matricula
    }
    
    
    var id: String {
        return _id;
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var couse: String {
        get {
            return _course;
        }
    }
    
    
    var matricula: String {
        get {
            return _matricula;
        }
    }
    var passoword: String {
        get {
            return _password;
        }
    }
    
}
