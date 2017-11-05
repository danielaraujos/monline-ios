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
import SConnection

class MonitoringVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    private var monitorias = [Curso]();
    private var disciplina = ""
    
    var meuID = AuthProvider.Instance.userID()
    var disciplinaMonitor: String?
    
    private let CELL_ID = "MonitoringCell";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        SVProgressHUD.show(withStatus: "Carregando")
        if(SConnection.isConnectedToNetwork()){
             self.buscarCursos()
        }else{
            SVProgressHUD.dismiss()
            self.showAlert(title: Constantes.TITULOALERTA, message: Constantes.MENSAGEMALERTA)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    /*
     Leio a estrutura Cursos, leio a estrutura dos usuario e verifico na lista de usuarios, qual é o meu usuario
     Assim passo por paramentro para proxima função a sigla
     */
    func buscarCursos() {
        let ref = Database.database().reference().child(Constantes.CURSOS)
        ref.observe(.childAdded, with: { (snapshot) in
            let siglaCurso = snapshot.key
            let cursoUsuarioRef = Database.database().reference().child(Constantes.USUARIOS)
            cursoUsuarioRef.observe(.childAdded, with: { (conteudo) in
                let idUsuarios = conteudo.key
                if self.meuID == idUsuarios{
                    self.buscarCursoUsuario(siglaCurso)
                }
            }, withCancel: nil)
            
        }, withCancel: nil)
    }

    /*
     Leio agora o nome da que esta no atributo sigla.
     Este nome é a sigla do curso que ele esta cursando
     */
    fileprivate func buscarCursoUsuario(_ sigla:String) {
        let conteudoReferencia = Database.database().reference().child(Constantes.USUARIOS).child(self.meuID)
        conteudoReferencia.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                var usuario = Usuario(dictionary: dictionary)
                var cursoQueFaco = usuario.curso!
                if(cursoQueFaco == sigla){
                    self.buscarAsMonitoriasDoCurso(sigla, usuario.monitor! )
                }
            }

        }, withCancel: nil)
    }
    
    
    /*
     Leio agora a estrutura cursos, na sigla que o usuario atual esta, e no atributo tipo.
     Pegando o nome da disciplina e a sigla da disciplina.
     */
    
    fileprivate func buscarAsMonitoriasDoCurso(_ sigla:String, _ disciplinaMonitor:String) {
        let cursoRef = Database.database().reference().child(Constantes.CURSOS).child(sigla).child(Constantes.TIPO)
        cursoRef.observeSingleEvent(of: .value, with: { (filho) in
            if let dictionary = filho.value as? [String: AnyObject] {
                for(key , value ) in dictionary {
                    if(key != disciplinaMonitor){
                        let novaMonitorias = Curso(nome: value as! String, sigla: key as! String)
                        self.monitorias.append(novaMonitorias)
                    }
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
    
    /* Função responsavel pelos alertas */
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }
}
