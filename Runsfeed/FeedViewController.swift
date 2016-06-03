//
//  FeedViewController.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit
import CoreLocation

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ApiDelegate {

    var model : AGTSimpleCoreDataStack?
    var classApi : API?
    
    var connection = typeConnection.None
    
    var boolDataRead = false
    var boolNoData = true
    var vistaNew = UIView()
    
    var arrayRunning : Array<Run> = []
    var arrayNewRunning : Array<Run> = []
    
    
    @IBOutlet weak var tableFeed: UITableView!
    @IBOutlet weak var indicador: UIActivityIndicatorView!
    @IBOutlet weak var topConstantTable: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainer: UIView!
    convenience init(modelCore: AGTSimpleCoreDataStack){
        self.init()
        model = modelCore
    }
    
    
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setup()
        readData()
        
        self.performSelector(#selector(self.checkIfConnected), withObject: nil, afterDelay: 6)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    //MARK: - Config
    
    //monitorizar conectividad
    func setup(){
        
       
        classApi = API(mainContext: model!.context)
        classApi?.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        
    }
    
    
    
    //MARK: - Setup TableView
    
    func setupTableView(){
        
        let nibHead = UINib(nibName: CellUser.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibHead, forCellReuseIdentifier: CellUser.returnID())
        
        let nibData = UINib(nibName: CellDataRun.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibData, forCellReuseIdentifier: CellDataRun.returnID())
        
        let nibMap = UINib(nibName: CellMap.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibMap, forCellReuseIdentifier: CellMap.returnID())
        
        let nibLike = UINib(nibName: CellLike.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibLike, forCellReuseIdentifier: CellLike.returnID())
        
        let nibComment = UINib(nibName: CellComment.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibComment, forCellReuseIdentifier: CellComment.returnID())
        
        let nibCommentEmpty = UINib(nibName: CellCommentEmpty.returnID(), bundle: nil)
        self.tableFeed.registerNib(nibCommentEmpty, forCellReuseIdentifier: CellCommentEmpty.returnID())
        
    }
    
    
    
    //MARK: - TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.arrayRunning.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let run = self.arrayRunning[indexPath.section]
        let user = run.relationPer
        
        switch indexPath.row {
        case 0:
            let cell  = setupCellUser(run, user: user!, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
            
        case 1:
            let cell  = setupCellDataRun(run, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
            
        case 2:
            let cell = setupCellMap(run, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        
        case 3:
            let cell = setupCellLike(run, indexPath: indexPath)
            cell.selectionStyle = .None
            return cell
            
        default:
            let comentario = run.returnLastComment()
            
            if let comment = comentario{
                let cell = setupCellComment(run, comment: comment, indexPath: indexPath)
                cell.selectionStyle = .None
                return cell
            }
            else{
                let cell = tableFeed.dequeueReusableCellWithIdentifier(CellCommentEmpty.returnID(), forIndexPath: indexPath) as! CellCommentEmpty
                cell.selectionStyle = .None
                return cell
            }

            
            
            
        }
       
        
    }
    
    
    
    
    //MARK:  - Setup de celdas
    
    func setupCellUser(run: Run, user: User, indexPath: NSIndexPath) -> CellUser{
        
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellUser.returnID(), forIndexPath: indexPath) as! CellUser
        
        cell.imageUser.image = nil
        
        cell.labCiudad.text = ""
        cell.labUser.text = ""
        cell.labFecha.text = ""
        cell.labHora.text = ""
        
        var sitio = ""
        
        if let ciudad = run.city{
            sitio = "\(ciudad)"
        }
        
        
        if let pais = run.pais{
            sitio = "\(sitio), \(pais)"
        }
        
        cell.labCiudad.text = sitio
        cell.labUser.text = user.nombre
        cell.labFecha.text = run.fecha?.fechaCompleta()
        cell.labHora.text = run.fecha?.horaCompleta()
        
        //imagen usuario
        let entityImg = user.imagenPer
        
        if let entity = entityImg{
            
            //hay imagen
            if let data = entity.dataImage{
                cell.imageUser.image = UIImage(data: data)
            }
            else{
                //descargar
                let strUrl = entity.url!
                
                NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:strUrl)!, completionHandler: {
                    (data, response, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if let data = data {
                            cell.imageUser.image = UIImage(data: data)
                            entity.dataImage = data
                        }
                    }
                    
                }).resume()
                
                
            }
            
        }
        
        return cell
        
    }
    
    
    func setupCellDataRun(run: Run, indexPath: NSIndexPath)->CellDataRun{
        
        let cell  = tableFeed.dequeueReusableCellWithIdentifier(CellDataRun.returnID(), forIndexPath: indexPath) as! CellDataRun
        
        cell.labDistancia.text = ""
        cell.labDuration.text = ""
        cell.labRitmo.text = ""
        
        cell.labDistancia.text = "\(run.distancia!)"
        cell.labDuration.text = run.duracion
        cell.labRitmo.text = run.ritmo!
        
        return cell
    }
    
    
    func setupCellMap(run: Run, indexPath: NSIndexPath)->CellMap{
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellMap.returnID(), forIndexPath: indexPath) as! CellMap
        
        cell.imgCarrera.image = nil
        
        //imagen de la carrera
        let entityImg = run.imgRelation
        
        if let entity = entityImg{
            
            cell.imgCarrera.hidden = false
            
            //hay imagen
            if let data = entity.imgData{
                cell.imgCarrera.image = UIImage(data: data)
            }
            else{
                //descargar
                let strUrl = entity.url!
                
                NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:strUrl)!, completionHandler: {
                    (data, response, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if let data = data {
                            cell.imgCarrera.image = UIImage(data: data)
                            entity.imgData = data
                        }
                    }
                    
                }).resume()
            }
        }
        else{
            cell.imgCarrera.hidden = true
        }
        
        

        
        //localizacion
        
        var boolHasLocation = false
        
        let lat =  run.latitude?.doubleValue
        let long = run.longitude?.doubleValue
        
        if let lati = lat{
            if let longi = long{
                
                if lati != 0 && longi != 0{
                    boolHasLocation = true
                }
                
            }
        }
        
        if boolHasLocation{
            cell.showLocation(lat!, longitude: long!)
        }
        else{
            var address = ""
            
            if let zona = run.zona{
                address = "\(zona)"
            }
            
            if let ciudad = run.city{
                address = "\(address), \(ciudad)"
            }
            
            if let state = run.state{
                address = "\(address), \(state)"
            }
            
            
            if let pais = run.pais{
                address = "\(address), \(pais)"
            }
            
            let gc:CLGeocoder = CLGeocoder()
            
            gc.geocodeAddressString(address) { (placemarks, error) in
                
                if let place = placemarks{
                    
                    if (place.count > 0){
                        
                        let p = place[0]
                        
                        let latitude = p.location!.coordinate.latitude
                        let longitude = p.location!.coordinate.longitude
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.showLocation(latitude, longitude: longitude)
                            run.latitude = latitude
                            run.longitude = longitude
                        })
                    }
                }
            }
 
        }
        
        
        
        
        return cell
    }
    
    
    func setupCellLike(run: Run, indexPath: NSIndexPath)->CellLike{
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellLike.returnID(), forIndexPath: indexPath) as! CellLike
        
        let num = run.numberLikes?.intValue
        cell.labNumberLike.text = "Se el primero en darle 'Me gusta'"
        
        if let value = num{
            if num > 0{
                cell.labNumberLike.text = "A \(value) personas les gusta esto"
            }
        }
        
        return cell
    }
    
    
    func setupCellComment(run: Run, comment: Comentario, indexPath: NSIndexPath)->CellComment{
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellComment.returnID(), forIndexPath: indexPath) as! CellComment
        
        
        
        
        cell.imageUser.image = nil
        
        let user = comment.userRelation
        
        cell.labComentario.text = comment.texto
        cell.labNameUser.text = user?.nombre
        
        let numberT = Int(run.totalComment!)
        
        var textTotal = "\(run.totalComment!) Comentario"
        if numberT > 1{
            textTotal = "\(textTotal)s"
        }
        
        cell.labTotal.text = textTotal
        
        
        //imagen usuario
        let entityImg = user?.imagenPer
        
        if let entity = entityImg{
            
            //hay imagen
            if let data = entity.dataImage{
                cell.imageUser.image = UIImage(data: data)
            }
            else{
                //descargar
                let strUrl = entity.url!
                
                NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:strUrl)!, completionHandler: {
                    (data, response, error) -> Void in
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        if let data = data {
                            cell.imageUser.image = UIImage(data: data)
                            entity.dataImage = data
                        }
                    }
                    
                }).resume()
                
                
            }
            
        }

        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let fila = indexPath.row
        var dev : CGFloat = 0
        
        switch fila {
        case 0:
            dev = 65
        case 1:
            dev = 65
        case 2:
            dev = 150
        case 3:
            dev = 50
        default:
            dev = 96
        }
        
        return dev
        
    }
    
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.tableFeed.frame.size.width, height: 20))
        footer.backgroundColor = UIColor.clearColor()
        return footer
        
    }
    
    
    
    //MARK: - Core Data
    
    func readData(){
        
        self.arrayRunning = Run.returnRunOrder((model?.context)!)
        
        if self.arrayRunning.count == 0{
                self.boolNoData = true
                self.boolDataRead = true
        }
        else{
             self.tableFeed.reloadData()
            self.boolNoData = false
            self.boolDataRead = true
            self.indicador.stopAnimating()
        }
        
       changeNetwork()
        
        
    }
    
    
    
    //MARK: - Api Delegate
    
    
    func updateInterface(new: Array<Run>){
        print("update interface")
        
        dispatch_async(dispatch_get_main_queue()) {
            self.arrayRunning = new
            self.indicador.stopAnimating()
            self.tableFeed.reloadData()
            self.boolNoData = false
            self.classApi!.getRunning(self.boolNoData)
        }
        
    }
    
    
    
    
    func newResult(new: Array<Run>){
        self.arrayNewRunning = new
        print("\(new.count) nuevos resultados")
        showViewNewResult()
    }
    
    
    
    //MARK: - Utils
    
    func ShowNewDataReload(){
        self.vistaNew.removeFromSuperview()
        self.arrayRunning.insertContentsOf(self.arrayNewRunning, at: 0)
        
        UIView.animateWithDuration(0.6, delay: 0, options: .BeginFromCurrentState, animations: {
            self.topConstantTable.constant = 25
            self.view.setNeedsUpdateConstraints()
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        self.tableFeed.reloadData()
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableFeed.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
        
    }
    
    
    func showViewNewResult(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
           self.vistaNew = self.createViewNew()
            self.view.addSubview(self.vistaNew)
            
            UIView.animateWithDuration(0.6, delay: 0, options: .TransitionNone, animations: {
                self.topConstantTable.constant = 65
                self.vistaNew.frame.origin.y = 20
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    
    func createViewNew()->UIView{
        
        let vista = UIView(frame: CGRect(x: self.tableFeed.frame.origin.x, y: -50, width: self.tableFeed.frame.size.width, height: 50))
        vista.backgroundColor = UIColor(netHex: 0xbdc3c7)
        
        
        vista.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ShowNewDataReload))
        vista.addGestureRecognizer(tap)
        
        
        let icono = UIImageView(frame: CGRect(x: 20, y: 10, width: 30, height: 30))
        icono.image = UIImage(named: "up")
        vista.addSubview(icono)
        
        
        let posx = icono.frame.origin.x + icono.frame.size.width
        let width = vista.frame.size.width - posx
        
        let labelMsg = UILabel(frame: CGRect(x: posx, y: 0, width: width, height: vista.frame.size.height))
        //labelMsg.translatesAutoresizingMaskIntoConstraints = false
        
        
        var texto = ""
        
        if self.arrayNewRunning.count > 1{
            texto = "\(self.arrayNewRunning.count) carreras nuevas"
        }
        else{
            "\(self.arrayNewRunning.count) carrera nueva"
        }
        
        labelMsg.text = texto
        labelMsg.textAlignment = .Center
        labelMsg.textColor = UIColor.whiteColor()
        vista.addSubview(labelMsg)
        
        return vista
    }
    
    
    
    //MARK: - Conectividad
    func networkStatusChanged(notification: NSNotification) {
        
        
        let status = Reach().connectionStatus()
        
        switch status {
        case .Unknown:
            //print("Not connected")
            self.connection = typeConnection.None
        case .Offline:
            self.connection = typeConnection.Off
        case .Online(.WWAN):
            //print("Connected via WWAN")
            self.connection = typeConnection.Dat
        case .Online(.WiFi):
            //print("Connected via WiFi")
            self.connection = typeConnection.Wi
        }
        
        print("\(self.connection)")
        changeNetwork()
        
        
    }
    
    
    func changeNetwork(){
        
        if boolDataRead && (self.connection == typeConnection.Wi || self.connection == typeConnection.Dat){
            print("first request")
            classApi!.getRunning(boolNoData)
            boolDataRead = false
          
        }
    }
    
    
    func checkIfConnected(){
        
        if self.connection == typeConnection.None || self.connection == typeConnection.Off{
            
            
            let controller = UIAlertController(title: "Problemas de conexión", message: "Comprueba su conexión a internet y vuelva a intentarlo", preferredStyle: .Alert)
            
            let ok = UIAlertAction(title: "ok", style: .Cancel, handler: nil)
            
            controller.addAction(ok)
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    

    

}
