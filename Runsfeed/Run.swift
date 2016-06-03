//
//  Run.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 28/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import Foundation
import CoreData


class Run: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    
    // MARK: - Class methods
    
    class func entityName () -> String {
        return "Run"
    }
    
    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }
    
    
    class func returnRunOrder(context: NSManagedObjectContext)->Array<Run>{
        
        let req = NSFetchRequest(entityName: Run.entityName())
        let descriptor = NSSortDescriptor(key: "fecha", ascending: false)
        let sortDescriptors = [descriptor]
        req.sortDescriptors = sortDescriptors
        
        do{
            let result = try context.executeFetchRequest(req) as! Array<Run>
           
            return result
            
        }
        catch let err as NSError{
            print("error cargando run \(err.localizedDescription)")
            return []
        }
    }

    
    
    class func returnRunWithId(iden: String, context: NSManagedObjectContext)->Run?{
        let req = NSFetchRequest(entityName: Run.entityName())
        req.predicate = NSPredicate(format: "id == %@", iden)
        
        let result = try! context.executeFetchRequest(req) as! Array<Run>
        
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
        let entity = Run.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }
    
    
    convenience init(iden: String, distance: Double, duration : String, numberLike: Int, ritmo: String, fecha: NSDate, context: NSManagedObjectContext){
        self.init(managedObjectContext: context)
        self.id = iden
        self.distancia = distance
        self.duracion = duration
        self.numberLikes = numberLike
        self.ritmo = ritmo
        self.fecha = fecha
    }
    
    
    
    //MARK: - add relations
    
    func CoreAddComments(objects : NSSet){
        
        
        let mutable = self.commentRelation?.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as! Set<NSObject>)
        self.commentRelation = mutable.copy() as? NSSet
    }
    
    func CoreDeleteComments(objects: NSSet){
        let mutable = self.commentRelation?.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as! Set<NSObject>)
        self.commentRelation = mutable.copy() as? NSSet
    }
    
    
    func CoreAddOneComment(value: Comentario){
        let mutable = self.commentRelation?.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.commentRelation = mutable.copy() as? NSSet
    }
    
    
    func CoreDeleteOneComment(value: Comentario){
        
        let mutable = self.commentRelation?.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.commentRelation = mutable.copy() as? NSSet
    }
    
    
    
    //MARK: - methods 
    
    func returnLastComment()->Comentario?{
        let comentarios = self.commentRelation?.allObjects
        
        if comentarios?.count > 0{
            return comentarios?.first as? Comentario
        }
        else{
            return nil
        }
    }
    
    


}
