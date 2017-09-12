//
//  MonitoringVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class MonitoringVC: UIViewController, UITableViewDataSource, UITableViewDelegate, FetchData {

    @IBOutlet weak var tableView: UITableView!
    
    private var contacts = [Contact]();
    private var monitorias = [Course]();
    
    private let CELL_ID = "MonitoringCell";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back()
        
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
        //DBProvider.Instance.getCurseUser()
        print(DBProvider.Instance.getCurseUser())
        DBProvider.Instance.getCourses(valor: "SIN")
        
        
        
    }
    
    func back(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }

  
    func dataReceived(contacts: [Contact]) {
        self.contacts = contacts;
        
        // get the name of current user
        for contact in contacts {
            if contact.id == AuthProvider.Instance.userID() {
                AuthProvider.Instance.userName = contact.name;
            }
        }
        
        tableView.reloadData();
    }
    
    
    func dataCourse(monitorias: [Course]) {
        self.monitorias = monitorias
        tableView.reloadData();
    }
    
    func dataMonitorias(detail: [Monitoria]) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monitorias.count;
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MonitoringViewCell
        cell.lbl_title.text = monitorias[indexPath.row].sigla;
        cell.lbl_subtitle.text = monitorias[indexPath.row].name;
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CELL_ID{
            if let indexPath = tableView.indexPathForSelectedRow{
                let siglaSelecionada = self.monitorias[indexPath.row].sigla
                let viewControllerDestino = segue.destination as! MonitoringDetailVC
                viewControllerDestino.sigla = siglaSelecionada
            }
        }
    }
    

}
