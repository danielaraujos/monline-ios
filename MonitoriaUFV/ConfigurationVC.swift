//
//  ConfigurationVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class ConfigurationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    var configuracoes : [Configuracao] = []
    var usuario: Usuario?
    //var CELL_ID = "PerfilSegue"
    
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
        
        self.lista()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.buscarUsuario()
    }
    
    func lista(){
        var config: Configuracao;
        config = Configuracao(id: 1, nome: "Perfil completo", image: #imageLiteral(resourceName: "user"))
        self.configuracoes.append(config)
        config = Configuracao(id: 3, nome: "Ajuda", image: #imageLiteral(resourceName: "informa"))
        self.configuracoes.append(config)
        config = Configuracao(id: 4, nome: "Contar a um amigo", image: #imageLiteral(resourceName: "contar"))
        self.configuracoes.append(config)
        config = Configuracao(id: 5, nome: "Avaliar aplicativo", image: #imageLiteral(resourceName: "relatar"))
        self.configuracoes.append(config)
        
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
                    if(novosUsuarios.ImagemURL != nil ){
                        self.image.carregarImagemNoCache(novosUsuarios.ImagemURL!)
                    }else{
                        self.image.image = UIImage(named: "profile-")
                    }
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
        let config: Configuracao = configuracoes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ConfiguracoesTableViewCell
        cell.lblTexto.text = config.nome
        cell.imageIcon.image = config.image
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selecionado = self.configuracoes[indexPath.row]
        
        if selecionado.id == 1 {
            //perfil completo
            self.mostrarProfile(meuID)
        }else if selecionado.id == 3{
            //ajuda
            self.padrao("daniel.araujos@icloud.com", "Preciso de ajuda")
        }else  if selecionado.id == 4{
            //contar a um amigo
            self.compartilhar()
        }else if selecionado.id == 5 {
            self.avaliarApp(appId: "id1200173802", completion: { (success) in
                print("RateApp \(success)")
            })
        }
    }
    
    
    func mostrarProfile(_ id: String) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC")
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    
    @IBAction func btnUpload(_ sender: Any) {
        
    }
    
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        image.layer.cornerRadius = 40;
        image.clipsToBounds = true;
    }
    
    
    func padrao(_ email: String, _ descricao: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p>Dispositivo: \(UIDevice.current.name)</p>", isHTML: true)
            mail.setSubject(descricao)
            
            present(mail, animated: true)
        } else {
            self.showAlert(title: "Ops.", message: "Ocorreu algum problema no envio. Tente novamente mais tarde!")
        }
    }
    
    func compartilhar(){
        let site = "#"
        let activitiVC = UIActivityViewController(activityItems: [site], applicationActivities: nil)
        activitiVC.popoverPresentationController?.sourceView = self.view
        self.present(activitiVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    //Avaliacao na apple store
    func avaliarApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
}


