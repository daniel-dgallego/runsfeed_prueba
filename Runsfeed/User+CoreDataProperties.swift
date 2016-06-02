//
//  User+CoreDataProperties.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 29/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var nombre: String?
    @NSManaged var id: String?
    @NSManaged var commentRel: NSSet?
    @NSManaged var imagenPer: ImgUser?
    @NSManaged var relationsRun: Run?

}
