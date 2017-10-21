//
//  MonitoriaMonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 20/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class MonitoriaMonitorVC: UIViewController {

    var meuID = AuthProvider.Instance.userID()
    var monitor: String?
    
    @IBOutlet weak var textFieldDisciplina: UITextField!
    @IBOutlet weak var textViewDescricao: UITextView!
    @IBOutlet weak var textFieldProfessor: UITextField!
    
    
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
                self.buscarMonitoria(novosUsuarios.monitor!)
                self.monitor = novosUsuarios.monitor!
            }
        }, withCancel: nil)
    }
    
    func buscarMonitoria(_ monitor: String) {
        print(monitor)
        let ref = Database.database().reference().child(Constantes.MONITORIAS).child(monitor)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let monitorias = Monitoria(dictionary: dictionary)
                self.textViewDescricao.text = monitorias.descricao!
                self.textFieldProfessor.text = monitorias.professor!
                self.textFieldDisciplina.text = monitorias.nome!
            }
        }, withCancel: nil)
    }
    
    
    func atualiza(_ monitor: String){
        let values = ["descricao":self.textViewDescricao.text,"nome":self.textFieldDisciplina.text,"professor":self.textFieldProfessor.text ]
        let ref = Database.database().reference().child(Constantes.MONITORIAS).child(monitor).updateChildValues(values){ (error, ref) in
            if(error != nil){
                print("Error",error)
                self.showAlert(title: "Error", message: "Erro ao atualizar a monitoria, tente novamente.")
            }else{
                self.showAlert(title: "Sucesso", message: "Monitoria atualizada com sucesso!")
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

    @IBAction func btnAtualizar(_ sender: Any) {
        self.atualiza(self.monitor!)
    }
    
}
