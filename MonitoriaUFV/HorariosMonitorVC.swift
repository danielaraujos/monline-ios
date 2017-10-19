//
//  HorariosMonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 18/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class HorariosMonitorVC: UIViewController {

    var recebimento: String?
    var meuID = AuthProvider.Instance.userID()
    var monitor: String?
    
    @IBOutlet weak var textViewHorario: UITextView!
    @IBOutlet weak var btnAtualizar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lerUsuario()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func lerUsuario(){
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let novosUsuarios = Usuario(dictionary: dictionary)
                self.buscarHorarios(novosUsuarios.monitor!)
                self.monitor = novosUsuarios.monitor!
            }
        }, withCancel: nil)
    }
    
    func buscarHorarios(_ monitor: String) {
        print(monitor)
        let ref = Database.database().reference().child(Constantes.HORARIOS).child(monitor)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let mhorarios = Horarios(dictionary: dictionary)
                self.textViewHorario.text = mhorarios.texto!
                //print(mhorarios.texto!)
            }
        }, withCancel: nil)
    }
    
    
    @IBAction func btnActionAtualizar(_ sender: Any) {
        self.atualiza(self.monitor!)
    }
    
    func atualiza(_ monitor: String){
        let values = ["texto":self.textViewHorario.text]
        let ref = Database.database().reference().child(Constantes.HORARIOS).child(monitor).updateChildValues(values)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    

}
