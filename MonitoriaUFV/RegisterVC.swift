//
//  RegisterVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
  

}
