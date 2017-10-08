//
//  MonitoringVC.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 19/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MonitoringVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    private var monitorias = [Curso]();
    private var disciplina = ""
    
    private let CELL_ID = "MonitoringCell";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back()
        SVProgressHUD.show(withStatus: "Carregando")
        self.buscarCursos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func back(){
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
    }

    func buscarCursos() {
        let id = AuthProvider.Instance.userID()
        let ref = Database.database().reference().child(Constantes.CURSOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let sigla = snapshot.key
            let cursoUsuarioRef = Database.database().reference().child(Constantes.USUARIOS)
            cursoUsuarioRef.observe(.childAdded, with: { (conteudo) in
                let idUsuarios = conteudo.key
                if id == idUsuarios{
                    self.buscarCursoUsuario(id, sigla)
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    fileprivate func buscarCursoUsuario(_ id: String, _ sigla:String) {
        let conteudoReferencia = Database.database().reference().child(Constantes.USUARIOS).child(id).child(Constantes.CURSO)
        conteudoReferencia.observeSingleEvent(of: .value, with: { (snapshot) in
            let curso = snapshot.value as! String
            if(curso == sigla){
                self.buscarAsMonitoriasDoCurso(sigla)
            }
        }, withCancel: nil)
    }
    
    fileprivate func buscarAsMonitoriasDoCurso(_ sigla:String) {
        let cursoRef = Database.database().reference().child(Constantes.CURSOS).child(sigla).child(Constantes.TIPO)
        cursoRef.observeSingleEvent(of: .value, with: { (filho) in
            if let dictionary = filho.value as? [String: AnyObject] {
                for(key , value ) in dictionary {
                    let novaMonitorias = Curso(nome: value as! String, sigla: key as! String)
                    self.monitorias.append(novaMonitorias)
                }
            }
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            })
        }, withCancel: nil)
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
        cell.lbl_subtitle.text = monitorias[indexPath.row].nome;
        SVProgressHUD.dismiss()
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
