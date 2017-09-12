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
    
    @IBOutlet weak var lblDisciplina: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblMonitor: UILabel!
    @IBOutlet weak var lblDescricao: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getMonitoria(valor: sigla)

    }

    
    func dataReceived(contacts: [Contact]) {
    }
    
    
    func dataCourse(monitorias: [Course]) {
    }
    
    func dataMonitorias(detail: [Monitoria]) {
        self.details = detail
        
        lblDisciplina.text = "Disciplina: \(self.details[2].description)"
        lblProfessor.text = "Professor: \(self.details[3].description)"
        lblMonitor.text = "Monitor: \(self.details[0].description)"
        lblDescricao.text = self.details[1].description
       
        
        
    }

}
