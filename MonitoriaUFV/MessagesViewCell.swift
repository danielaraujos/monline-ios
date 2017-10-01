//
//  MessagesViewCell.swift
//  MonitoriaUFV
//
//  Created by Daniel Araújo on 01/10/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class MessagesViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var sub_title: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var image_1: UIImageView!
    
    
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
        image_1.layer.cornerRadius = 10;
        image_1.clipsToBounds = true;
    }
    
    
}

