//
//  ReporterVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 15/09/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ReporterVC: UIViewController {

    @IBOutlet weak var text: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
   }

    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func btnEnviar(_ sender: Any) {
        self.showAlert(title: "Sucesso!", message: "A denúncia foi enviada para o responsável.")
    }
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
}
