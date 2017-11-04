//
//  ProfileVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 17/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

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
        self.arredondandoImagem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func lblAtualizarA(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Carregando")
        self.update()
    }
    
    func update(){
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(Constantes.PROFILE_STORAGE).child("\(imageName).png")
        if let profileImage = self.imageProfile.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["nome":self.lblNome.text! , "matricula":self.lblMatricula.text! ,"ImagemURL":profileImageUrl]
                    Database.database().reference().child(Constantes.USUARIOS).child(self.meuID).updateChildValues(values){ (error, ref) in
                        if(error != nil){
                            SVProgressHUD.dismiss()
                            self.showAlert(title: "Error", message: "Erro ao atualizar o perfil, tente novamente.")
                        }else{
                            SVProgressHUD.dismiss()
                            self.showAlert(title: "Sucesso", message: "Perfil atualizado com sucesso!")
                        }
                    }
                }
            })
        }
    }
    
    
    @IBAction func btnSelected(_ sender: Any) {
        print("Selecionou")
        self.selecionarImagem()
    }
    
    
    func lerProfile(){
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let novosUsuarios = Usuario(dictionary: dictionary)
                print(novosUsuarios.ImagemURL)
                self.lblNome.text = novosUsuarios.nome
                self.lblCurso.text = novosUsuarios.curso
                self.lblMatricula.text = novosUsuarios.matricula
                self.lblEmail.text = novosUsuarios.email
                self.lblSenha.text = novosUsuarios.senha
                if(novosUsuarios.ImagemURL != nil) {
                    self.imageProfile.carregarImagemNoCache(novosUsuarios.ImagemURL!)
                }else{
                    self.imageProfile.image = UIImage(named: "profile-")
                }
            }
        }, withCancel: nil)
    }
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        imageProfile.layer.cornerRadius = 40;
        imageProfile.clipsToBounds = true;
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func selecionarImagem() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            //self.usuario?.ImagemURL = selectedImage
            print(selectedImage)
            self.imageProfile.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}

