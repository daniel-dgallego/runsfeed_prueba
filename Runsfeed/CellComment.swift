//
//  CellComment.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit

class CellComment: UITableViewCell {

    
    var noComment = false
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var viewGeneral: UIView!
    @IBOutlet weak var labNameUser: UILabel!
    @IBOutlet weak var labComentario: UILabel!
    @IBOutlet weak var labTotal: UILabel!
    
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
        return "CellComment"
    }
    
    
    //MARK: - Custom Views
    
    
    func setNoComment(){
        noComment = true
    }
    
    
    func setupCell(){
        
        if noComment{
            for vista in self.contentView.subviews{
                vista.removeFromSuperview()
            }
        }
        else{
            self.imageUser.layer.masksToBounds = false
            self.imageUser.clipsToBounds = true
            self.imageUser.layer.cornerRadius = self.imageUser.frame.size.width / 2
        }
        
       
        
    }
    
}
