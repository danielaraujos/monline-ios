//
//  MonitoringDetailVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 12/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MonitoringDetailVC: UIViewController {

    var sigla: String!
    //private var usuario = Usuario?
    private let CHATSEGUE = "ChatSegue";
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblDisciplina: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblMonitor: UILabel!
    @IBOutlet weak var lblDescricao: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Carregando")
        self.title = sigla
        ElementsProvider.voltarSemTexto()
        self.buscarMonitoria()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    
    
    
    func buscarMonitoria() {
        let ref = Database.database().reference().child(Constantes.MONITORIAS)
        ref.observe(.childAdded, with: { (snapshot) in
            let nomeDisciplina = snapshot.key as! String
            if(self.sigla == nomeDisciplina){
                let cursoUsuarioRef = Database.database().reference().child(Constantes.MONITORIAS).child(nomeDisciplina)
                cursoUsuarioRef.observeSingleEvent(of: .value, with: { (conteudo) in
                    if let dictionary = conteudo.value as? [String: AnyObject] {
                        let novaMonitorias = Monitoria(dictionary: dictionary)
                        self.lblDisciplina.text = "Disciplina: \(novaMonitorias.nome!)"
                        self.lblProfessor.text = "Professor (a): \(novaMonitorias.professor!)"
                        self.lblDescricao.text = novaMonitorias.descricao!
                        self.buscarUsuario(novaMonitorias.monitor!)
                    }
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }
    
    fileprivate func buscarUsuario(_ id: String) {
        let ref = Database.database().reference().child(Constantes.USUARIOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let idUsuarios = snapshot.key as! String
            let ref = Database.database().reference().child(Constantes.USUARIOS).child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let novosUsuarios = Usuario(dictionary: dictionary)
                    if(idUsuarios == id){
                        //self.usuario = novosUsuarios
                        self.lblMonitor.text = "Monitor (a): \(novosUsuarios.nome!)"
                        SVProgressHUD.dismiss()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    @IBAction func btnChat(_ sender: Any) {
        //self.handleNewMessage(self.usuario)
    }
    
    @objc func handleNewMessage(_ usuario: Usuario) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.usuario = usuario
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
