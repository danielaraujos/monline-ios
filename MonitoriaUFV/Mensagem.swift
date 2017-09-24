//
//  Mensagem.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 24/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation
class Mensagem {
    
    var paraID: String?
    var texto: String?
    var timestamp: NSNumber?
    var meuID: String?
    var imageUrl: String?
    var videoUrl: String?
    var larguraImagem: NSNumber?
    var alturaImagem: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.paraID = dictionary["paraID"] as? String
        self.texto = dictionary["texto"] as? String
        self.meuID = dictionary["meuID"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
    
        self.larguraImagem = dictionary["larguraImagem"] as? NSNumber
        self.alturaImagem = dictionary["alturaImagem"] as? NSNumber
    }
//    
//    func idParceiro() -> String? {
//        return paraID == FIRAuth.auth()?.currentUser?.uid ? meuID : paraID
//    }
    
    
    
    
}
