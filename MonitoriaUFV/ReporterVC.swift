//
//  ReporterVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 15/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SConnection
import SVProgressHUD

class ReporterVC: UIViewController {

    @IBOutlet weak var text: UITextView!
    @IBOutlet weak var btn: UIButton!
    var recebimento: String?
    var meuID = AuthProvider.Instance.userID()
    var IdMonitorDenuncia : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        if(SConnection.isConnectedToNetwork()){
            self.buscarUsuario()
        }else{
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
        
        self.arredondamentoBorda()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func sumirTeclado(){
        view.endEditing(true)
    }
    
    func buscarUsuario() {
        let ref = Database.database().reference().child(Constantes.USUARIOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let idUsuarios = snapshot.key
            let ref = Database.database().reference().child(Constantes.USUARIOS).child(idUsuarios)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let novosUsuarios = Usuario(dictionary: dictionary)
                    if(novosUsuarios.monitor == self.recebimento){
                        self.IdMonitorDenuncia = idUsuarios as! String
                        //SVProgressHUD.dismiss()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func arredondamentoBorda(){
        let myColor : UIColor = ElementsProvider.hexStringToUIColor(hex: "#eee")
        self.text.layer.borderColor = myColor.cgColor
        self.text.layer.borderWidth = 0.3
        self.text.layer.cornerRadius = 10;
        self.text.clipsToBounds = true;
    }

    @IBAction func btnSender(_ sender: Any) {
        let texto = self.text.text!
        
        SVProgressHUD.show(withStatus: "Aguarde")
        if checkTrue(conteudo: texto){
            let ref = Database.database().reference().child(Constantes.DENUNCIAS)
            let childRef = ref.childByAutoId()
            let timestamp = Int(Date().timeIntervalSince1970)
            
            let values: [String: AnyObject] = ["meuID": self.meuID as AnyObject,"monitorID": self.IdMonitorDenuncia as AnyObject,"siglaMonitoria": self.recebimento as AnyObject,"texto": texto as AnyObject,"timestamp": timestamp as AnyObject]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(title: "Error", message: "Erro ao inserir sua denúncia, tente novamente.")
                }else{
                    SVProgressHUD.dismiss()
                    self.showAlert(title: "Sucesso", message: "Denúncia enviada com sucesso! Estaremos analisando. ")
                    self.text.text! = " "
                }
            }
        
        }
    }
    
    /* Função responsável por checar se os campos estão preenchidos ou dentre os conformes */
    func checkTrue(conteudo: String) -> Bool{
        if conteudo == ""{
            self.showAlert(title: "Atenção", message: "O campo deve ser preenchido!")
            return false
        }
        return true
    }
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
