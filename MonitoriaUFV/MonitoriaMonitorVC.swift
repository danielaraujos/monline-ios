//
//  MonitoriaMonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 20/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SConnection
import SVProgressHUD

class MonitoriaMonitorVC: UIViewController {

    var meuID = AuthProvider.Instance.userID()
    var monitor: String?
    
    @IBOutlet weak var textFieldDisciplina: UITextField!
    @IBOutlet weak var textViewDescricao: UITextView!
    @IBOutlet weak var textFieldProfessor: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.arredondamentoBorda()
        if(SConnection.isConnectedToNetwork()){
            self.lerUsuario()
        }
        else{
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
        
    }
    
    func arredondamentoBorda(){
        let myColor : UIColor = ElementsProvider.hexStringToUIColor(hex: "#eee")
        self.textViewDescricao.layer.borderColor = myColor.cgColor
        self.textViewDescricao.layer.borderWidth = 0.3
        self.textViewDescricao.layer.cornerRadius = 10;
        self.textViewDescricao.clipsToBounds = true;
        
        self.textFieldDisciplina.layer.borderColor = myColor.cgColor
        self.textFieldDisciplina.layer.borderWidth = 0.3
        self.textFieldDisciplina.layer.cornerRadius = 10;
        self.textFieldDisciplina.clipsToBounds = true;
        
        self.textFieldProfessor.layer.borderColor = myColor.cgColor
        self.textFieldProfessor.layer.borderWidth = 0.3
        self.textFieldProfessor.layer.cornerRadius = 10;
        self.textFieldProfessor.clipsToBounds = true;
    }
    
    func sumirTeclado(){
        view.endEditing(true)
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
        SVProgressHUD.show(withStatus: "Carregando")
        let ref = Database.database().reference().child(Constantes.MONITORIAS).child(monitor)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let monitorias = Monitoria(dictionary: dictionary)
                self.textViewDescricao.text = monitorias.descricao!
                self.textFieldProfessor.text = monitorias.professor!
                self.textFieldDisciplina.text = monitorias.nome!
            }
            SVProgressHUD.dismiss()
        }, withCancel: nil)
    }
    
    
    func atualiza(_ monitor: String){
        let values = ["descricao":self.textViewDescricao.text,"nome":self.textFieldDisciplina.text,"professor":self.textFieldProfessor.text ]
        SVProgressHUD.show(withStatus: "Carregando")
        Database.database().reference().child(Constantes.MONITORIAS).child(monitor).updateChildValues(values){ (error, ref) in
            if(error != nil){
                SVProgressHUD.dismiss()
                //print("Error",error)
                self.showAlert(title: "Error", message: "Erro ao atualizar a monitoria, tente novamente.")
            }else{
                SVProgressHUD.dismiss()
                self.showAlert(title: "Sucesso", message: "Monitoria atualizada com sucesso!")
            }
        }
        
    }
    
    @IBAction func btnAtualizar(_ sender: Any) {
        self.atualiza(self.monitor!)
    }
    
    /* Função responsavel pelos alertas */
     func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
}
