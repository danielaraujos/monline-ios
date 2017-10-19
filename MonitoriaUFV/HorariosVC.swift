//
//  HorariosVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 18/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class HorariosVC: UIViewController {

    var recebimento: String?
    var meuID = AuthProvider.Instance.userID()
    @IBOutlet weak var textViewConteudo: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buscarHorarios()
    }
    
    func buscarHorarios() {
        let ref = Database.database().reference().child(Constantes.HORARIOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let idHorarios = snapshot.key as! String
            let ref = Database.database().reference().child(Constantes.HORARIOS).child(idHorarios)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let mhorarios = Horarios(dictionary: dictionary)
                    if(self.recebimento == idHorarios){
                        if( mhorarios.texto != "0"){
                            self.textViewConteudo.text = mhorarios.texto!
                        }
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }

}
