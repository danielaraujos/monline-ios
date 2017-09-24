//
//  ConfigurationVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ConfigurationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}
