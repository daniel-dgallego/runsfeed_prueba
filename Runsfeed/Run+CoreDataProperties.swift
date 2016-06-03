//
//  Run+CoreDataProperties.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 2/6/16.
//  Copyright © 2016 runator.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Run {

    @NSManaged var distancia: NSNumber?
    @NSManaged var duracion: String?
    @NSManaged var fecha: NSDate?
    @NSManaged var id: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var pais: String?
    @NSManaged var numberLikes: NSNumber?
    @NSManaged var ritmo: String?
    @NSManaged var totalComment: NSDecimalNumber?
    @NSManaged var state: String?
    @NSManaged var city: String?
    @NSManaged var zona: String?
    @NSManaged var commentRelation: NSSet?
    @NSManaged var imgRelation: ImgRun?
    @NSManaged var relationPer: User?

}
