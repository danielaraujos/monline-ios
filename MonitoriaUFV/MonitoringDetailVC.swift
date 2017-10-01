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

class MonitoringDetailVC: UIViewController,FetchData {

    var sigla: String!
    private var details = [Monitoria]();
    private var contacts = [Usuario]();
    private let CHATSEGUE = "ChatSegue";
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblDisciplina: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblMonitor: UILabel!
    @IBOutlet weak var lblDescricao: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "Carregando")
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts()
        DBProvider.Instance.getMonitoria(valor: sigla)
        self.title = sigla
        self.back()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func back(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }
    
    func dataReceived(contacts: [Usuario]) {
        self.contacts = contacts;
    }

    func dataCourse(monitorias: [Curso]) {
    }
    
    func dataMonitorias(detail: [Monitoria]) {
        self.details = detail
        lblDisciplina.text = "Disciplina: \(self.details[3].descricao!)"
        lblProfessor.text = "Professor (a): \(self.details[2].descricao!)"
        lblDescricao.text = self.details[0].descricao!
        for contact in self.contacts {
            if contact.id == self.details[1].descricao! {
                lblMonitor.text = "Monitor (a): \(contact.nome!)"
            }
        }
        SVProgressHUD.dismiss()
    }

    func userA(user: String) {}
    
    
    //var messagesController: MessagesController?
    
   
    
    @IBAction func btnChat(_ sender: Any) {
        var id = self.details[0].descricao!
        perform(#selector(handleNewMessage))
    }
    
    @objc func handleNewMessage() {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(chatLogController, animated: true)
    }
}
