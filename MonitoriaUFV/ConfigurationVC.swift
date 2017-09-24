//
//  ConfigurationVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ConfigurationVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageProfile: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var CELL_ID = "AjusteCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rounding()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            print("LOGOUT COM SUCESSO!")
            dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func rounding(){
        imageProfile.layer.cornerRadius = 40;
        imageProfile.clipsToBounds = true;
    }
    
}
