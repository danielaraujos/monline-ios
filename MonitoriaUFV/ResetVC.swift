//
//  ResetVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ResetVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction func btnCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
