//
//  Monitor.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 17/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import UIKit

class Monitor : NSObject{
    var id: Int!
    var nome: String!
    var image: UIImage!
    
    init(id:Int, nome:String, image:UIImage) {
        self.id = id
        self.nome = nome
        self.image = image
    }
    
    init(nome:String) {
        self.nome = nome
    }
    
    
}

