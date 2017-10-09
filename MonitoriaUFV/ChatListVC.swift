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
    var meuID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ElementsProvider.voltarSemTexto()
        
        self.mensagens.removeAll()
        self.messagesDictionary.removeAll()
        tableView.reloadData()
        self.observeUserMessages()
        self.verificarMonitor()
    }
    
    var mensagens = [Mensagem]()
    var messagesDictionary = [String: Mensagem]()
    

    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child(Constantes.MENSUSUARIO).child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child(Constantes.MENSUSUARIO).child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
            
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
   
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        
        let messagesReference = Database.database().reference().child(Constantes.MENSAGENS).child(messageId)
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Mensagem(dictionary: dictionary)
                
                if let idParceiro = message.idParceiro() {
                    self.messagesDictionary[idParceiro] = message
                }
                
                self.attemptReloadOfTable()
                
           }
            
        }, withCancel: nil)
    }
    
    fileprivate func attemptReloadOfTable() {
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    func handleReloadTable() {
        self.mensagens = Array(self.messagesDictionary.values)
        self.mensagens.sort(by: { (message1, message2) -> Bool in
            
            return message1.timestamp!.int32Value > message2.timestamp!.int32Value
        })
        
        //this will crash because of background thread, so lets call this on dispatch_async main thread
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
    
    func showChatControllerForUser(id: String) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.idMonitor = id
        navigationController?.pushViewController(chatLogController, animated: true)
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
            
            let user = Usuario(dictionary: dictionary)
            user.id = chatPartnerId
            //print(user.id!)
            //user.setValuesForKeys(dictionary)
            //self.showChatControllerForUser(user)
            self.showChatControllerForUser(id: user.id as! String)
            
        }, withCancel: nil)
    }
    
    
    func verificarMonitor() {
        
        let ref = Database.database().reference().child(Constantes.MONITORIAS)
        ref.observe(.childAdded, with: { (snapshot) in
            let siglaMonitoria = snapshot.key
            let conteudoReferencia = Database.database().reference().child(Constantes.MONITORIAS).child(siglaMonitoria)
            conteudoReferencia.observeSingleEvent(of: .value, with: { (conteudoRef) in
                if let dictionary = conteudoRef.value as? [String: AnyObject] {
                    let conteudo = Monitoria(dictionary: dictionary)
                    
                    if conteudo.monitor == self.meuID {
                        print("Sou monitor")
                        
                        let ref1 = Database.database().reference().child(Constantes.USUARIOS)
                        ref1.observe(.childAdded, with: { (usuarios) in
                            let id = usuarios.key
                            if self.meuID == id{
                                let ref2 = Database.database().reference().child(Constantes.USUARIOS).child(id)
                                ref2.observeSingleEvent(of: .value, with: { (snapshot) in
                                    
                                    
                                    
                                    if let dictionary = snapshot.value as? [String: AnyObject] {
                                        let usuarios = Usuario(dictionary: dictionary)
                                        //self.title = usuarios.nome
                                        print(usuarios.nome)
                                        
                                    }
                                    
                                }, withCancel: nil)
                            }
                            
                            
                        }, withCancel: nil)
                        
                    }
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    
    
}
