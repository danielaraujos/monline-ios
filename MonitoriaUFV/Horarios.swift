//
//  Horarios.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 18/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import UIKit

class Horarios : NSObject{
    var texto: String!
    
    init(dictionary: [String: Any]) {
        self.texto = dictionary["texto"] as? String
    }
    
    
}
