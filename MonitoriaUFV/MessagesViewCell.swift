//
//  MessagesViewCell.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 01/10/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
class MessagesViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sub_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var image_1: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rounding()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var message: Mensagem? {
        didSet {
            if let paraID = message?.paraID {
                let ref = Database.database().reference().child(Constantes.USUARIOS)
                ref.observe(.childAdded, with: { (snapshot) in
                    let idUsuarios = snapshot.key as! String
                    let ref = Database.database().reference().child(Constantes.USUARIOS).child(idUsuarios)
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            var novosUsuarios = Usuario(dictionary: dictionary)
                            if(idUsuarios == paraID){
                                if(novosUsuarios.monitor! == "0"){
                                    self.title.text = novosUsuarios.nome!
                                }else{
                                    self.title.text = novosUsuarios.monitor!
                                }
                            }
                        }
                    }, withCancel: nil)
                }, withCancel: nil)
                
            }
            
            self.sub_title.text = message?.texto
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = Date(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                self.lbl_date.text = dateFormatter.string(from: timestampDate)
            }
            
        }
    }
    
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func rounding(){
        image_1.layer.cornerRadius = 10;
        image_1.clipsToBounds = true;
    }
    
    
}

