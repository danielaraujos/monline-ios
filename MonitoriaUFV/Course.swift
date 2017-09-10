//
//  Course.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 09/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class Course {
    
    
    //SIN
    //monitorias
    //SIN100
    //description:
    //name:
    //teacher:
    //tutor:
    //name:
    
    private var _course = "";
    private var _monitorias = "";
    private var _name = "";
    private var _disciplinas = "";
    private var _teacher = "";
    private var _tutor = "";
    
    init(course: String) {
        
        _course = course;
    }
    
    
    var course: String {
        return _course;
    }
    
    var monitorias: String {
        return _monitorias;
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var disciplinas: String{
        return _disciplinas
    }
    
    var couse: String {
        get {
            return _course;
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




//SIN
//monitorias
//SIN100
//description:
//name:
//teacher:
//tutor:
//name:
