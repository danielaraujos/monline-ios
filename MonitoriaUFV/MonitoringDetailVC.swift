//
//  MonitoringDetailVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 12/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class MonitoringDetailVC: UIViewController,FetchData {

    var sigla: String!
    private var details = [Monitoria]();
    private var contacts = [Contact]();
    
    @IBOutlet weak var lblDisciplina: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblMonitor: UILabel!
    @IBOutlet weak var lblDescricao: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts()
        DBProvider.Instance.getMonitoria(valor: sigla)
        self.title = sigla

    }

    
    func dataReceived(contacts: [Contact]) {
        
        self.contacts = contacts;
        
    }
    
    
    func dataCourse(monitorias: [Course]) {
    }
    
    func dataMonitorias(detail: [Monitoria]) {
        self.details = detail
        
        lblDisciplina.text = "Disciplina: \(self.details[2].description)"
        lblProfessor.text = "Professor: \(self.details[3].description)"
        lblDescricao.text = self.details[1].description
        
        for contact in self.contacts {
            if contact.id == self.details[0].description {
                lblMonitor.text = "Monitor: \(contact.name)"
            }
        }

        
        //self.title = self.details[2].description
       
    }
    
    func userA(user: String) {
    
    }

}
