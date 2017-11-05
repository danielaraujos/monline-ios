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
import SConnection

class RegisterVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var matriculaTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var couseTextField: UITextField!
    
    private var siglaCurso : String!
    
    private var coursesOption = [Curso]();
    var selecione : Curso?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pickerView = UIPickerView()
        pickerView.delegate = self
        self.selecione = Curso.init(nome: "Selecione o curso")
        if(SConnection.isConnectedToNetwork()){
            self.coursesOption.append(self.selecione!)
            self.buscarSiglaCursos()
            
        }else{
            SVProgressHUD.dismiss()
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
        couseTextField.inputView = pickerView
        
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
    }
    
    func sumirTeclado(){
        view.endEditing(true)
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
        return coursesOption[row].nome!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(coursesOption[row].nome! == "Selecione o curso"){
            self.couseTextField.text = " "
        }else{
            self.couseTextField.text = coursesOption[row].nome!
            self.siglaCurso = coursesOption[row].id!
        }
    }
    
    @IBAction func btnRegister(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let name = nameTextField.text!
        let matricula = matriculaTextField.text!
        var course = self.siglaCurso!
        var monitor = "0"
        
        if checkTrue(name: name, course: course,matricula:matricula,email: email, password: password){
            SVProgressHUD.show(withStatus: "Carregando")
            AuthProvider.Instance.signUp(withEmail: email, password: password,name: name, course: course,matricula:matricula,monitor: monitor, loginHandler: { (message) in
                if message != nil {
                    SVProgressHUD.dismiss()
                    self.showAlert(title: "Problema na criação do Usuário", message: message!)
                }else {

                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.nameTextField.text = ""

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
    
    func buscarSiglaCursos(){
        SVProgressHUD.show(withStatus: "Carregando")
        let ref = Database.database().reference().child(Constantes.CURSOS)
        ref.observe(.childAdded, with: { (snapshot) in
            var sigla = snapshot.key
            self.buscarNomeCursos(sigla)
        }, withCancel: nil)
    }
    
    fileprivate func buscarNomeCursos(_ sigla:String){
        let ref1 = Database.database().reference().child(Constantes.CURSOS).child(sigla)
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let cursos = Curso(dictionary: dictionary)
                cursos.id = sigla
                self.coursesOption.append(cursos)
                SVProgressHUD.dismiss()
            }
        }, withCancel: nil)
    }
    
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
