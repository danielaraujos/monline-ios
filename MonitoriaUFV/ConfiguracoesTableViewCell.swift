//
//  ConfiguracoesTableViewCell.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 16/10/2017.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class ConfiguracoesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var lblTexto: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.arredondandoImagem()
        
    }
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        imageIcon.layer.cornerRadius = 5;
        imageIcon.clipsToBounds = true;
    }

}
