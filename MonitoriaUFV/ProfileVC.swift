//
//  ProfileVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 17/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var lblNome: UITextField!
    @IBOutlet weak var lblCurso: UITextField!
    @IBOutlet weak var lblMatricula: UITextField!
    @IBOutlet weak var lblEmail: UITextField!
    @IBOutlet weak var lblSenha: UITextField!
    @IBOutlet weak var lblAtualizar: UIButton!
    var id: String!
    var meuID = AuthProvider.Instance.userID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lerProfile()
        self.imageProfile.image = UIImage(named: "profile-")
        self.arredondandoImagem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func lblAtualizarA(_ sender: Any) {
    }
    
    @IBAction func btnSelected(_ sender: Any) {
    }
    func lerProfile(){
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let novosUsuarios = Usuario(dictionary: dictionary)
                self.lblNome.text = novosUsuarios.nome
                self.lblCurso.text = novosUsuarios.curso
                self.lblMatricula.text = novosUsuarios.matricula
                self.lblEmail.text = novosUsuarios.email
                self.lblSenha.text = novosUsuarios.senha
            }
        }, withCancel: nil)
    }
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        imageProfile.layer.cornerRadius = 40;
        imageProfile.clipsToBounds = true;
    }
}
