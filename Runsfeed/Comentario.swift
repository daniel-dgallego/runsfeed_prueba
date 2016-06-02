//
//  Comentario.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 28/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import Foundation
import CoreData


class Comentario: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // MARK: - Class methods
    
    class func entityName () -> String {
        return "Comentario"
    }
    
    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }
    
    
    // MARK: - init methods
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = Comentario.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
    
    
    convenience init(texto: String, context: NSManagedObjectContext){
        self.init(managedObjectContext: context)
        self.texto = texto
    }
    
    
    
  
    
    


}
