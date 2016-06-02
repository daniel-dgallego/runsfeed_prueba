//
//  api.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import Foundation


protocol ApiDelegate: class{
    func updateInterface(new: Array<Run>)
    func newResult(new: Array<Run>)
}



    
    

class API{
    
    weak var delegate:ApiDelegate?
    
    let authStr = "Bearer 63bea7d5e84b6c45a4af9f9d3db714a8"
    let strUrlFirst = "http://wispy-wave-1292.getsandbox.com/timeline"
    let strUrlNew = "http://wispy-wave-1292.getsandbox.com/timeline/anyNewRun"
    
    var mainContext : NSManagedObjectContext?
    var privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    
    
    init(mainContext: NSManagedObjectContext){
        self.mainContext = mainContext
        privateContext.persistentStoreCoordinator = mainContext.persistentStoreCoordinator
    }
    
    
    //MARK: - Peticiones
    func getRunning(firstTime: Bool){
        
        let headers = [
            "Auth": authStr
        ]
        
        
        var url : NSURL
        
        if(firstTime){
            url = NSURL(string: strUrlFirst)!
        }
        else{
            url = NSURL(string: strUrlNew)!
        }
        
        
        
        let request = NSMutableURLRequest(URL: url,
                                      cachePolicy: .UseProtocolCachePolicy,
                                      timeoutInterval: 5.0)
        
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        
        
        
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil{
                print("error \(error?.localizedDescription) \(error?.code)")
                
                if(error?.code == -1001){
                    self.getRunning(firstTime)
                }
                return
            }
            
            do{
                
                if let resData = data{
                    let respuesta = try NSJSONSerialization.JSONObjectWithData(resData, options: .AllowFragments) as? Dictionary<String, AnyObject>
                    
                    if let newData = respuesta{
                        print("\(respuesta)")
                        
                        self.readData(firstTime, data: newData)
                        
                    }
                    
                  
                }
                
                
            }
            catch let err as NSError{
                print("error serializando \(err.localizedDescription)")
            }
        }.resume()
   
        
    }
    
    
    
    
    
    //MARK: - Leer Datos
    func readData(firstTime: Bool, data : Dictionary<String, AnyObject>){
        
        let status = data["status"] as? String
        
        if status != "ok"{
            return
        }
        
        
        var new : Array<Run> = []
        let cards = data["data"]!["cards"] as! NSArray
        
        for run in cards{
            
            
            let info_user = run["runator_user"] as? Dictionary<String, AnyObject>
            
            
            if let inuser = info_user{
                
                let usuario = self.createOrGetUser(inuser)
                
                let runId = run["run_id"] as! String
                var carrera = Run.returnRunWithId(runId, context: privateContext)
                    
                    if carrera == nil{
                        
                        //localizacion
                        let ciudad = run["city"] as! String
                        
                        
                        //distancia y duracion
                        var distance : Double = 0
                        let getDistan = run["distanceDisplay"] as? Double
                        
                        if let distancia = getDistan{
                            distance = distancia.roundToPlaces(1)
                        }
                        
                        
                        
                        var duracion = run["durationDisplay"] as? String
                        
                        if duracion == nil{
                            duracion = "0"
                        }
                        
                        
                        //ritmo
                        let ritmo = getRitmo(run as! Dictionary<String, AnyObject>)
                        
                        
                        //likes
                        let infoLikes = run["likes"] as? Dictionary<String, AnyObject>
                        
                        var numberLikes = 0
                        if let inlike = infoLikes{
                            numberLikes = inlike["count"] as! Int
                        }
                        
                        
                        //fecha
                        let fecha = getDate(run as! Dictionary<String, AnyObject>)
                        
                        
                        //Run Object CoreData y photo run
                        carrera = Run(iden: runId, ciudad: ciudad, distance: distance, duration: duracion!, numberLike: numberLikes, ritmo: ritmo, fecha: fecha, context: privateContext)
                        carrera?.relationPer = usuario
                        
                        let photoRunUrl = inuser["photo"] as? String
                        
                        if let fotoRun = photoRunUrl{
                            let ImgR = ImgRun(url: fotoRun, context: privateContext)
                            ImgR.runRelation = carrera
                        }
                        
                        
                        //comentario
                        let commentGroup = run["comment_group"] as? NSDictionary
                        
                        if let group = commentGroup{
                           self.createCommentRun(group, carrera: carrera!)
                        }
                        
                        

                        if let newRun = carrera{
                            new.append(newRun)
                        }
                        
                    }
                    
                
            }
        }
        
        guardarPrivate(firstTime,nuevas: new)
    }
    
    
    
    //MARK: - Utils
    
    func createOrGetUser(info_user: Dictionary<String, AnyObject>)->User{
        
            
            let iduser = info_user["id"] as! String
            
            var usuario = User.returnUsuarioWithId(iduser, context: privateContext)
            
            if usuario == nil{
                let nameuser = info_user["name"] as! String
                
                usuario = User(iden: iduser, nom: nameuser, context: privateContext)
                
                let photoUrl = info_user["photo_thumb"] as? String
                
                if let foto = photoUrl{
                    let Img = ImgUser(url: foto, context: privateContext)
                    Img.imagen = usuario
                }
            }
        
            return usuario!
    }
    
    
    
    
    
    func createCommentRun(commentGroup: NSDictionary, carrera: Run){
        
        
       
        let total = commentGroup["total_hits"] as? NSNumber
        let texto = commentGroup["last_comment"]?["comment"] as? String
        
        if let tot = total{
            carrera.totalComment = NSDecimalNumber(decimal: tot.decimalValue)
        }
        
        let dicUserComment = commentGroup["last_comment"]?["user"] as? Dictionary<String, AnyObject>
        
        if let usDic = dicUserComment{
            let usuario = self.createOrGetUser(usDic)
            
            if let text = texto{
                 let comment = Comentario(texto: text, context: self.privateContext)
                 comment.userRelation = usuario
                 comment.runRelation = carrera
            }
        }
        
    }
    
    
    
    func getRitmo(dic: Dictionary<String, AnyObject>)->String{
        
        var dev = ""
        
        let displayRitmo = dic["paceDisplay"] as? Dictionary<String, Int>
        
        if let display = displayRitmo{
            
            let minutes = display["minutes"]!
            let seconds = display["seconds"]!
            
            dev = "\(minutes)' \(seconds)''"
            
        }
        else{
            let pace = dic["pace"] as? Dictionary<String, Int>
            
            if let pac = pace{
                
                let minutes = pac["minutes"]!
                let seconds = pac["seconds"]!
                
                dev = "\(minutes)' \(seconds)''"
            }
        }
        
        return dev
    }
    
    
    func getDate(dic: Dictionary<String, AnyObject>)->NSDate{
        
        var fecha : String?
        var devolver : NSDate? = NSDate()
        
        
        let dateFirst = dic["date"] as? Dictionary<String, AnyObject>
        
        if let date = dateFirst{
            fecha = date["date"] as? String
            
        }
        else{
            let dateSecond = dic["created_at"] as? Dictionary<String, AnyObject>
            
            if let date = dateSecond{
                fecha = date["date"] as? String
            }
            
        }
        
        
        if let fechaFinal = fecha{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            devolver = dateFormatter.dateFromString(fechaFinal)
        }
        
        
        if let final = devolver{
            return final
        }
        else{
            return NSDate()
        }
        

    }
    
    
    func guardarPrivate(firstTime: Bool, nuevas: Array<Run>){
        
        //self.privateContext.refreshAllObjects()
        self.privateContext.performBlock { () -> Void in
            if self.privateContext.hasChanges{
                
                do{
                    try self.privateContext.save()
                    print("guardado private context")
                    
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        //pasamos objetos a contexto principal
                        var new : Array<Run> = []
                        self.mainContext?.refreshAllObjects()
                        
                        for carrera in nuevas{
                            
                            let run = self.mainContext?.objectWithID(carrera.objectID) as? Run
                            
                            if let addRun = run{
                                new.append(addRun)
                            }
                        }
                        
                        if firstTime{
                            self.delegate?.updateInterface(new)
                        }
                        else{
                            self.delegate?.newResult(new)
                        }
                    })
                    
                    
                    
                }
                catch let err as NSError{
                    print("error guardando contexto privado \(err.localizedDescription) \(err.debugDescription)")
                }
                
                
            }
          
        }
        
    }
    
    
}
