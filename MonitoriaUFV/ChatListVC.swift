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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back()
        //self.observeMessages()
        
        self.mensagens.removeAll()
        self.messagesDictionary.removeAll()
        tableView.reloadData()
        self.observeUserMessages()
    }
    
    var mensagens = [Mensagem]()
    var messagesDictionary = [String: Mensagem]()
    
    func back(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child(Constantes.MENSUSUARIO).child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesReference = Database.database().reference().child(Constantes.MENSAGENS).child(messageId)
            
            messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Mensagem(dictionary: dictionary)
                    
                    if let toId = message.paraID {
                        self.messagesDictionary[toId] = message
                        
                        self.mensagens = Array(self.messagesDictionary.values)
                        self.mensagens.sort(by: { (message1, message2) -> Bool in
                            
                            return message1.timestamp!.int32Value > message2.timestamp!.int32Value
                        })
                    }
                    
                    //this will crash because of background thread, so lets call this on dispatch_async main thread
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                
            }, withCancel: nil)
            
        }, withCancel: nil)
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
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.showChatControllerForUser(id: self.mensagens[indexPath.row].paraID!)
    }
}
