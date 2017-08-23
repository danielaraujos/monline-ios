//
//  MonitoringViewCell.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 22/08/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class MonitoringViewCell: UITableViewCell {

    
    @IBOutlet weak var image_table: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rounding()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func rounding(){
        image_table.layer.cornerRadius = 10;
        image_table.clipsToBounds = true;
    }
    

}
