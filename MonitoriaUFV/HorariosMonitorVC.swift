//
//  HorariosMonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 18/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SConnection

class HorariosMonitorVC: UIViewController {

    var recebimento: String?
    var meuID = AuthProvider.Instance.userID()
    var monitor: String?
    
    @IBOutlet weak var textViewHorario: UITextView!
    @IBOutlet weak var btnAtualizar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if(SConnection.isConnectedToNetwork()){
            self.lerUsuario()
            self.arredondamentoBorda()
        }
        else{
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)

    }
    
    func sumirTeclado(){
        view.endEditing(true)
    }
    
    
    func arredondamentoBorda(){
        let myColor : UIColor = ElementsProvider.hexStringToUIColor(hex: "#eee")
        self.textViewHorario.layer.borderColor = myColor.cgColor
        self.textViewHorario.layer.borderWidth = 0.3
        self.textViewHorario.layer.cornerRadius = 10;
        self.textViewHorario.clipsToBounds = true;
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
        SVProgressHUD.show(withStatus: "Carregando")
        let ref = Database.database().reference().child(Constantes.HORARIOS).child(monitor)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let mhorarios = Horarios(dictionary: dictionary)
                self.textViewHorario.text = mhorarios.texto!
            }
            SVProgressHUD.dismiss()
        }, withCancel: nil)
        
    }
    
    
    @IBAction func btnActionAtualizar(_ sender: Any) {
        self.atualiza(self.monitor!)
    }
    
    func atualiza(_ monitor: String){
        let values = ["texto":self.textViewHorario.text]
        SVProgressHUD.show(withStatus: "Carregando")
        let ref = Database.database().reference().child(Constantes.HORARIOS).child(monitor).updateChildValues(values){ (error, ref) in
            if(error != nil){
                SVProgressHUD.dismiss()
                print("Error",error)
                self.showAlert(title: "Error", message: "Erro ao atualizar os horários, tente novamente.")
            }else{
                SVProgressHUD.dismiss()
                self.showAlert(title: "Sucesso", message: "Horários atualizados com sucesso!")
            }
        }
    }
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

}
