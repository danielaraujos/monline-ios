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
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        self.arredondamentoBorda()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "sumirTeclado")
        view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func sumirTeclado(){
        view.endEditing(true)
    }
    
    
    func arredondamentoBorda(){
        let myColor : UIColor = ElementsProvider.hexStringToUIColor(hex: "#eee")
        self.text.layer.borderColor = myColor.cgColor
        self.text.layer.borderWidth = 0.3
        self.text.layer.cornerRadius = 10;
        self.text.clipsToBounds = true;
    }

   
    @IBAction func btnSender(_ sender: Any) {
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
