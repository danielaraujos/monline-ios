//
//  RegisterVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class RegisterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var courseTextField: UITextField!
    @IBOutlet weak var matriculaTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var coursesOption = ["SIN", "NTR"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerView = UIPickerView()
        pickerView.delegate = self
        courseTextField.inputView = pickerView
    }
    
    
    /*
     Funções responsavel por mostrar a barra de navegação
     */
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    
    
    /*
     Funções responsaveis por fazer o selected nos textview
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coursesOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coursesOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        courseTextField.text = coursesOption[row]
    }
    
    
    
    
    @IBAction func btnRegister(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let course = courseTextField.text!
        let matricula = matriculaTextField.text!
        
        if checkTrue(name: name, course: course,matricula:matricula,email: email, password: password){
            SVProgressHUD.show(withStatus: "Carregando")
            
            AuthProvider.Instance.signUp(withEmail: email, password: password,name: name, course: course,matricula:matricula, loginHandler: { (message) in
                
                if message != nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(title: "Problema na criação do Usuário", message: message!)
                }else {
                    
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.nameTextField.text = ""
                    self.courseTextField.text = ""
                    self.matriculaTextField.text = ""
                    
                    self.showAlert(title: "Parabéns...", message: "Conta criada com sucesso!")
                    SVProgressHUD.dismiss()
                    
                }
            })
            SVProgressHUD.dismiss()
        }
        
    }
    
    
    
    
    
    
    /* Função responsável por checar se os campos estão preenchidos ou dentre os conformes */
    func checkTrue(name: String,course: String,matricula: String, email: String, password: String) -> Bool{
        if name == "" || course == "" || matricula == "" || email == "" || password == ""   {
            self.showAlert(title: "Atenção", message: "Todos campos devem ser preenchidos!")
            return false
        }
        if password.characters.count < 6  {
            self.showAlert(title: "Atenção", message: "A senha deve ter no mínimo 6 caracteres!")
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
