//
//  CellDataRun.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit

class CellDataRun: UITableViewCell {

    @IBOutlet weak var labDistancia: UILabel!
    @IBOutlet weak var labDuration: UILabel!
    @IBOutlet weak var labRitmo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - static method
    
    static func returnID()->String{
        return "CellDataRun"
    }
    
}
