
//
//  SeguidoresVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 05/11/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SConnection

class SeguidoresMonitorVC: UIViewController {

    @IBOutlet weak var texto: UITextView!
    var monitor: String?
    var meuID = AuthProvider.Instance.userID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondamentoBorda()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
    }
        
    func sumirTeclado(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func lerUsuario(){
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let novosUsuarios = Usuario(dictionary: dictionary)
                self.seguidores(novosUsuarios.monitor!)
            }
        }, withCancel: nil)
    }
    
    func seguidores(_ monitor: String){
        let ref = Database.database().reference().child(Constantes.INSCRICAO).child(monitor)
        //ref.observe(.childAdded, with: { (snapshot) in
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                for(key , value ) in dictionary {
                    self.sendMessageWithProperties(key)
                }
            }
        }, withCancel: nil)
    }
    
    fileprivate func sendMessageWithProperties(_ para: String) {
        let ref = Database.database().reference().child(Constantes.MENSAGENS)
        let childRef = ref.childByAutoId()
        let toId = para
        let fromId = Auth.auth().currentUser!.uid
        let valorTexto = self.texto.text!
        let timestamp = Int(Date().timeIntervalSince1970)
        
        var values: [String: AnyObject] = ["paraID": toId as AnyObject, "meuID": fromId as AnyObject, "texto": valorTexto as AnyObject, "timestamp": timestamp as AnyObject]
        
        childRef.updateChildValues(values) { (error, ref) in
            if(error != nil){
                SVProgressHUD.dismiss()
                //print("Error",error)
                self.showAlert(title: "Error", message: "Erro ao enviar a mensagem, tente novamente.")
            }else{
                SVProgressHUD.dismiss()
                self.showAlert(title: "Sucesso", message: "Mensagem enviada com sucesso!")
            }
            
            let userMessagesRef = Database.database().reference().child(Constantes.MENSUSUARIO).child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child(Constantes.MENSUSUARIO).child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    @IBAction func btnEnviar(_ sender: Any) {
        if(SConnection.isConnectedToNetwork()){
            self.lerUsuario()
        }else{
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
    }
    
    func arredondamentoBorda(){
        let myColor : UIColor = ElementsProvider.hexStringToUIColor(hex: "#eee")
        self.texto.layer.borderColor = myColor.cgColor
        self.texto.layer.borderWidth = 0.3
        self.texto.layer.cornerRadius = 10;
        self.texto.clipsToBounds = true;
    }
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
