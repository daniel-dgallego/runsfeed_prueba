//
//  User.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 28/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import Foundation
import CoreData


class User: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    // MARK: - Class methods
    
    class func entityName () -> String {
        return "User"
    }
    
    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }
    
    
    class func returnUsuarioWithId(iden: String, context: NSManagedObjectContext)->User?{
        let req = NSFetchRequest(entityName: User.entityName())
        req.predicate = NSPredicate(format: "id == %@", iden)
        
        let result = try! context.executeFetchRequest(req) as! Array<User>
        
        if result.count > 0{
            return result[0]
        }
        else{
            return nil
        }
        
    }

    
    
    // MARK: - init methods
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = User.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
    
    
    convenience init(iden: String, nom: String, context: NSManagedObjectContext){
        self.init(managedObjectContext: context)
        self.id = iden
        self.nombre = nom
    }
    
    
    
    //MARK: - add relations
    
    func CoreAddComments(objects : NSSet){
        
        
        let mutable = self.commentRel?.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.commentRel = mutable.copy() as? NSSet
    }
    
    func CoreDeleteComments(objects: NSSet){
        let mutable = self.commentRel?.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.commentRel = mutable.copy() as? NSSet
    }
    
    
    func CoreAddOneComment(value: Comentario){
        let mutable = self.commentRel?.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.commentRel = mutable.copy() as? NSSet
    }
    
    
    func CoreDeleteOneComment(value: Comentario){
        
        let mutable = self.commentRel?.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.commentRel = mutable.copy() as? NSSet
    }

    
    

}
