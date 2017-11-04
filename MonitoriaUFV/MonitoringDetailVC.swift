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
    var usuario : Usuario!
    private let CHATSEGUE = "ChatSegue";
    private let HORARIOSSEGUE = "HorariosSegue"
    var meuID = AuthProvider.Instance.userID()
    
    @IBOutlet weak var alerta: UIBarButtonItem!
    @IBOutlet weak var denuncia: UIButton!
    @IBOutlet weak var duvida: UIButton!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblDisciplina: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblMonitor: UILabel!
    @IBOutlet weak var lblDescricao: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Carregando")
        self.title = sigla
        self.buscarMonitoria()
        self.observar(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }

    /*
     Realiza a leitura  da estrutura monitorias, e com a chave consegue ler os atrbiutos filhos dele
     */
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
                        self.buscarUsuario()
                    }
                }, withCancel: nil)
            }
        }, withCancel: nil)
    }
    
    fileprivate func buscarUsuario() {
        let ref = Database.database().reference().child(Constantes.USUARIOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let idUsuarios = snapshot.key as! String
            let ref = Database.database().reference().child(Constantes.USUARIOS).child(idUsuarios)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    var novosUsuarios = Usuario(dictionary: dictionary)
                    if(novosUsuarios.monitor == self.sigla){
                        self.usuario = novosUsuarios
                        self.usuario.id = idUsuarios
                        self.lblMonitor.text = "Monitor (a): \(novosUsuarios.nome!)"
                        SVProgressHUD.dismiss()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    @IBAction func btnChat(_ sender: Any) {
        self.handleNewMessage(self.usuario)
    }
    @IBAction func btnHorarios(_ sender: Any) {
       
    }

    @IBAction func btnAlerta(_ sender: Any) {
        self.observar(true)
        self.inscricao()
        self.showAlert(title: "Parabéns!", message: "Você acabou de seguir a monitoria. Receberá notificações sobre a mesma.")
    }

    func inscricao()-> DatabaseReference{
        let ref = Database.database().reference().child(Constantes.INSCRICAO).child(self.sigla).child(self.meuID)
        let values: [String: AnyObject] = ["id": self.meuID as AnyObject]
        ref.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        }
        return ref
    }
    
    func remover(){
        return Database.database().reference().child(Constantes.INSCRICAO).child(self.sigla).child(self.meuID).removeValue(completionBlock: { (error, ref) in
            if error != nil {
                print("Erro ao remover mensagem!:", error!)
                return
            }
        })
        
    }
    
    func observar(_ click: Bool){
        let ref = Database.database().reference().child(Constantes.INSCRICAO).child(self.sigla)
        //ref.observeSingleEvent(of: .value, with: { (snapshot) in
        ref.observe(.childAdded, with: { (snapshot) in
//            print(snapshot.key)
//            if(click == true){
//                if(self.meuID == snapshot.key){
//                    self.remover()
//                    self.alerta.image = UIImage(named: "alerta")
//                    print("Igual")
//                }else{
//                    self.observar(false)
//                    self.inscricao()
//                    self.alerta.image = UIImage(named: "alertaA")
//                    print("Desigual")
//
//
//                }
//            }
            self.inscricao()
            if(self.meuID == snapshot.key){
                self.alerta.image = UIImage(named: "alertaA")
            }
        }, withCancel: nil)
    }
    
    @objc func handleNewMessage(_ usuario: Usuario) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.usuario = usuario
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == HORARIOSSEGUE{
            let viewControllerDestino = segue.destination as! HorariosVC
            viewControllerDestino.recebimento = self.sigla
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
