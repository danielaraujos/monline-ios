//
//  LoginVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SConnection

class LoginVC: UIViewController {

    private let SUCESS_SEGUE = "SucessLogin"
    
    @IBOutlet weak var viewUser: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btn_login: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerTextField: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rounding()
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
    }
    
    func sumirTeclado(){
        view.endEditing(true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AuthProvider.Instance.isLoggedIn() {
            performSegue(withIdentifier: self.SUCESS_SEGUE, sender: nil);
        }
    }

    @IBAction func btnLogin(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if checkTrue(email: email, password: password){
            SVProgressHUD.show(withStatus: "Carregando")
            if(SConnection.isConnectedToNetwork()){
                AuthProvider.Instance.login(withEmail: email, password: password, loginHandler: { (message) in
                    if message != nil {
                        SVProgressHUD.dismiss()
                        self.showAlert(title: "Problema na autentificação", message: message!)
                    }else {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        print("LOGIN COM SUCESSO!")
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: self.SUCESS_SEGUE, sender: nil)
                    }
                })
            }else {
                SVProgressHUD.dismiss()
                self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
                
            }
            
            SVProgressHUD.dismiss()
        }
    }
    

    /* Função responsável por checar se os campos estão preenchidos ou dentre os conformes */
    func checkTrue(email: String, password: String) -> Bool{
        if email == "" || password == "" {
            self.showAlert(title: "Atenção", message: "Todos campos devem ser preenchidos!")
            return false
        }
        if password.characters.count < 6  {
            self.showAlert(title: "Atenção", message: "A senha deve ter no mínimo 6 caracteres!")
            return false
        }
        return true
    }
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func rounding(){
        viewUser.layer.cornerRadius = 20;
        viewPassword.layer.cornerRadius = 20;
        btn_login.layer.cornerRadius = 10;
        registerTextField.layer.cornerRadius = 10;
        viewUser.clipsToBounds = true;
        registerTextField.clipsToBounds = true;
        viewPassword.clipsToBounds = true;
        btn_login.clipsToBounds = true;
    }
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
