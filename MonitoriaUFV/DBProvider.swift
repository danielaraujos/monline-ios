//
//  DBProvider.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 27/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class DBProvider {

    private static let _instance = DBProvider()
    
    private init(){}
    
    static var Instance: DBProvider{
        return _instance
    }


 }
