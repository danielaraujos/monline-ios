//
//  MonitorVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 17/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class MonitorVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var monitores : [Monitor] = []
    let CELL_ID = "MonitorCell"
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lista()
    }
    
    func lista(){
        var monitor: Monitor;
        monitor = Monitor(id: 1, nome: "Ver lista de seguidores", image: #imageLiteral(resourceName: "user"))
        self.monitores.append(monitor)
        monitor = Monitor(id: 2, nome: "Mensagens para serguidores", image: #imageLiteral(resourceName: "relatar"))
        self.monitores.append(monitor)
        monitor = Monitor(id: 3, nome: "Atualizar horário", image: #imageLiteral(resourceName: "informa"))
        self.monitores.append(monitor)
        //monitor = Monitor(id: 4, nome: "Contar a um amigo", image: #imageLiteral(resourceName: "contar"))
        //self.monitores.append(monitor)
        
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

}
