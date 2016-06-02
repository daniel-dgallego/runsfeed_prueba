//
//  CellUser.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit

class CellUser: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var labCiudad: UILabel!
    @IBOutlet weak var labUser: UILabel!
    @IBOutlet weak var labFecha: UILabel!
    @IBOutlet weak var labHora: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK: - static method
    
    static func returnID()->String{
        return "CellUser"
    }
    
    
    //MARK: - Custom Views
    
    func setupCell(){
        imageUser.layer.masksToBounds = false
        imageUser.layer.cornerRadius = imageUser.frame.size.width / 2
        imageUser.clipsToBounds = true
    }
    
}
