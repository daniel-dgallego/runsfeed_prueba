//
//  CellMap.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit
import GoogleMaps

class CellMap: UITableViewCell {

    @IBOutlet  var mapView: GMSMapView!
    @IBOutlet weak var imgCarrera: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupMap()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - static method
    
    static func returnID()->String{
        return "CellMap"
    }
    
    
    //MARK: - Map
    
    
    func setupMap(){
        self.mapView.userInteractionEnabled = false
    }
    
    
    func showLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 14)
        self.mapView.camera = camera
        
    }
    
}
