//
//  MonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 17/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase

class MonitorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var monitores : [Monitor] = []
    let CELL_ID = "MonitorCell"
    let HORARIOS_CELL = "HorariosCell"
    var meuID = AuthProvider.Instance.userID()
    var sigla: String?
    var value: Int?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verificacaoUsuario()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func verificacaoUsuario() {
        let ref = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var novosUsuarios = Usuario(dictionary: dictionary)
                if(novosUsuarios.monitor != "0"){
                    self.lista()
                    self.sigla = novosUsuarios.monitor!
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }else{
                    var monitor: Monitor;
                    monitor = Monitor(id: 5, nome: "Você não é monitor!", image: #imageLiteral(resourceName: "informa"))
                    self.monitores.append(monitor)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }, withCancel: nil)
    }
    
    func lista(){
        var monitor: Monitor;
        monitor = Monitor(id: 1, nome: "Lista de seguidores", image: #imageLiteral(resourceName: "user"))
        self.monitores.append(monitor)
        monitor = Monitor(id: 2, nome: "Mensagens para serguidores", image: #imageLiteral(resourceName: "relatar"))
        self.monitores.append(monitor)
        monitor = Monitor(id: 3, nome: "Atualizar horários", image: #imageLiteral(resourceName: "informa"))
        self.monitores.append(monitor)
        monitor = Monitor(id: 4, nome: "Atualizar monitoria", image: #imageLiteral(resourceName: "contar"))
        self.monitores.append(monitor)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monitores.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let monitor: Monitor = monitores[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MonitorTableViewCell
        cell.titulo.text = monitor.nome
        cell.imageIcon.image = monitor.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selecionado = self.monitores[indexPath.row]
        
        if selecionado.id == 1 {
            self.value = 1
        }else if selecionado.id == 2{
            self.value = 2
        }else  if selecionado.id == 3{
            self.atualizaHorario(self.sigla!)
        }else if selecionado.id == 4 {
            self.value = 4
        }
        
    }
    
    
    
    @objc func atualizaHorario(_ sigla: String) {
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "HorariosMonitorVC")
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }

}
