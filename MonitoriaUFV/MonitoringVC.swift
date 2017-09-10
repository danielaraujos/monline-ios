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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back()
        
        DBProvider.Instance.delegate = self;
        DBProvider.Instance.getContacts();
        //DBProvider.Instance.getUserCourse()
        DBProvider.Instance.getCourses()
        
        
        
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
    
    
    func dataMonitorias(monitorias: [Course]) {
        self.monitorias = monitorias
        tableView.reloadData();
    
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count;
    }
    
  
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonitoringCell", for: indexPath) as! MonitoringViewCell
        cell.lbl_title.text = monitorias[indexPath.row].course;
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    

}
