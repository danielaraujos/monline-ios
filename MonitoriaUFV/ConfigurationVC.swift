//
//  ConfigurationVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class ConfigurationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var configuracoes : [Configuracao] = []
    var usuario: Usuario?
    
    @IBOutlet weak var imageProfile: UIView!
    @IBOutlet weak var lblNome: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var meuID = AuthProvider.Instance.userID()
    
    var CELL_ID = "AjusteCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arredondandoImagem()
        self.buscarUsuario()
        self.image.image = UIImage(named: "profile-")
        self.lista()
    }
    
    func lista(){
        var config: Configuracao;
        config = Configuracao(id: 1, nome: "Perfil completo", image: #imageLiteral(resourceName: "user"))
        self.configuracoes.append(config)
        config = Configuracao(id: 2, nome: "Relatar um problema", image: #imageLiteral(resourceName: "relatar"))
        self.configuracoes.append(config)
        config = Configuracao(id: 3, nome: "Ajuda", image: #imageLiteral(resourceName: "informa"))
        self.configuracoes.append(config)
        config = Configuracao(id: 4, nome: "Contar a um amigo", image: #imageLiteral(resourceName: "contar"))
        self.configuracoes.append(config)
//        config = Configuracao(id: 5, name: "Compartilhar o Hinário", image: #imageLiteral(resourceName: "compartilhar"))
//        self.configuracoes.append(config)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func buscarUsuario() {
        let ref = Database.database().reference().child(Constantes.USUARIOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    var novosUsuarios = Usuario(dictionary: dictionary)
                    self.lblNome.text = novosUsuarios.nome!
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    
    
    
    @IBAction func btnLogout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            print("LOGOUT COM SUCESSO!")
            dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuracoes.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let more: Mais = mais[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMais", for: indexPath) as! MaisCelula
//        cell.imageMais.image = more.image
//        cell.titulo.text = more.name
//        return cell;
//
//
        let config: Configuracao = configuracoes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ConfiguracoesTableViewCell
        cell.lblTexto.text = config.nome
        cell.imageIcon.image = config.image
        //cell.image
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selecionado = self.configuracoes[indexPath.row]
        
        if selecionado.id == 1 {
            print("1")
        }else if selecionado.id == 2 {
            print("2")
        }else if selecionado.id == 3{
            print("3")
        }else  if selecionado.id == 4{
            print("4")
        }
    }
    
    @IBAction func btnUpload(_ sender: Any) {
        self.selecionarImagem()
    }
    
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        image.layer.cornerRadius = 40;
        image.clipsToBounds = true;
    }
    
}

extension ConfigurationVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
            self.image.image = selectedImage
            //profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}
