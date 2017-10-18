//
//  ChatListVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class ChatListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet weak var tableView: UITableView!
    var id = AuthProvider.Instance.userID()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ElementsProvider.voltarSemTexto()
        self.mensagens.removeAll()
        self.messagesDictionary.removeAll()
        tableView.reloadData()
        self.buscarDestinatarioMensagens()
        //self.verificarMonitor()
    }
    
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = self.mensagens[indexPath.row]
        
        if let chatPartnerId = message.idParceiro() {
            Database.database().reference().child(Constantes.MENSUSUARIO).child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                
                if error != nil {
                    print("Failed to delete message:", error!)
                    return
                }
                
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                self.tentarRecarregarTabelas()
                
            })
        }
    }
    
    var mensagens = [Mensagem]()
    var messagesDictionary = [String: Mensagem]()
    

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func buscarDestinatarioMensagens() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child(Constantes.MENSUSUARIO).child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child(Constantes.MENSUSUARIO).child(uid).child(userId)
                .observe(.childAdded, with: { (snapshot) in
                let idMensagem = snapshot.key
                self.desimpactandoMensagens(idMensagem)
            
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    fileprivate func desimpactandoMensagens(_ idMensagem: String) {
        let ref = Database.database().reference().child(Constantes.MENSAGENS).child(idMensagem)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Mensagem(dictionary: dictionary)
                if let idParceiro = message.idParceiro() {
                    self.messagesDictionary[idParceiro] = message
                }
                self.tentarRecarregarTabelas()
            }
        }, withCancel: nil)
    }
    
    fileprivate func tentarRecarregarTabelas() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.manipulandoAsTabelas), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    func manipulandoAsTabelas() {
        self.mensagens = Array(self.messagesDictionary.values)
        self.mensagens.sort(by: { (message1, message2) -> Bool in
            return message1.timestamp!.int32Value > message2.timestamp!.int32Value
        })
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    func observeMessages() {
        let ref = Database.database().reference().child(Constantes.MENSAGENS)
        ref.observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Mensagem(dictionary: dictionary)
                if let paraID = message.paraID {
                    self.messagesDictionary[paraID] = message
                    self.mensagens = Array(self.messagesDictionary.values)
                    self.mensagens.sort(by: { (message1, message2) -> Bool in
                        return message1.timestamp!.int32Value > message2.timestamp!.int32Value
                    })
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! MessagesViewCell
        let message = self.mensagens[indexPath.row]
        cell.message = message
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = mensagens[indexPath.row]
        
        guard let chatPartnerId = message.idParceiro() else {
            return
        }
        
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let usuario = Usuario(dictionary: dictionary)
            usuario.id = chatPartnerId
            self.showChatControllerForUser(usuario)
            
        }, withCancel: nil)
    }
    
    func showChatControllerForUser(_ usuario: Usuario) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.usuario = usuario
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
}
