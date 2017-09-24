//
//  ResetVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class ResetVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    /* Função responsável por checar se os campos estão preenchidos ou dentre os conformes */
    func checkTrue(email: String) -> Bool{
        if email == "" {
            self.showAlert(title: "Atenção", message: "O campo e-mail deve ser preenchido!")
            return false
        }
        
        return true
    }
    
    @IBAction func btnRecovery(_ sender: Any) {
        let email = emailTextField.text!
        if checkTrue(email: email){
            SVProgressHUD.show(withStatus: "Carregando")
            
            AuthProvider.Instance.resetPassword(withEmail: email, loginHandler: { (error) in
                if error != nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(title: "Ops! Aconteceu um problema!", message: error!)
                }else {
                    self.showAlert(title: "E-mail enviado!", message: "Um e-mail para redefinição de senha foi encaminhado.")
                }
            })
            SVProgressHUD.dismiss()
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
