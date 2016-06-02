//
//  FeedViewController.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit

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
            return cell
            
        case 1:
            let cell  = setupCellDataRun(run, indexPath: indexPath)
            return cell
            
        case 2:
            let cell = setupCellMap(indexPath)
            return cell
        
        case 3:
            let cell = setupCellLike(run, indexPath: indexPath)
            return cell
            
        default:
            let comentario = run.returnLastComment()
            if let comment = comentario{
                let cell = setupCellComment(run, comment: comment, indexPath: indexPath)
                return cell
            }
            else{
                let cell = tableFeed.dequeueReusableCellWithIdentifier(CellCommentEmpty.returnID(), forIndexPath: indexPath) as! CellCommentEmpty
                return cell
            }

            
            
            
        }
       
        
    }
    
    
    
    
    //MARK:  - Setup de celdas
    
    func setupCellUser(run: Run, user: User, indexPath: NSIndexPath) -> CellUser{
        
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellUser.returnID(), forIndexPath: indexPath) as! CellUser
        
        cell.labCiudad.text = ""
        cell.labUser.text = ""
        cell.labFecha.text = ""
        cell.labHora.text = ""
        
        cell.labCiudad.text = run.lugar
        cell.labUser.text = user.nombre
        cell.labFecha.text = run.fecha?.fechaCompleta()
        cell.labHora.text = run.fecha?.horaCompleta()
        
        
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
    
    
    func setupCellMap(indexPath: NSIndexPath)->CellMap{
        let cell = tableFeed.dequeueReusableCellWithIdentifier(CellMap.returnID(), forIndexPath: indexPath) as! CellMap
        
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
        
        
        let user = comment.userRelation
        
        cell.labComentario.text = comment.texto
        cell.labNameUser.text = user?.nombre
        
        let numberT = Int(run.totalComment!)
        
        var textTotal = "\(run.totalComment!) Comentario"
        if numberT > 1{
            textTotal = "\(textTotal)s"
        }
        
        cell.labTotal.text = textTotal
        
        
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
        
    }
    
    
    func showViewNewResult(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
           self.vistaNew = self.createViewNew()
            self.view.addSubview(self.vistaNew)
            
         
            
            let height = NSLayoutConstraint(item: self.vistaNew, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 70)
            
            let width = NSLayoutConstraint(item: self.vistaNew, attribute: .Width, relatedBy: .Equal, toItem: self.tableFeed, attribute: .Width, multiplier: 1, constant: 0)
            
            let alignx = NSLayoutConstraint(item: self.vistaNew, attribute: .CenterX, relatedBy: .Equal, toItem: self.viewContainer, attribute: .CenterX, multiplier: 1, constant: 0)
            
          
            
            
            
            let top = NSLayoutConstraint(item: self.vistaNew, attribute: .Top, relatedBy: .Equal, toItem: self.viewContainer, attribute: .Top, multiplier: 1, constant: 15)
            
            self.view.addConstraints([height, width, alignx, top])
            
            UIView.animateWithDuration(0.6, delay: 0, options: .TransitionCurlUp, animations: {
                self.topConstantTable.constant = 65
                self.view.setNeedsUpdateConstraints()
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        
            
            
            
        }
        
        
    }
    
    
    func createViewNew()->UIView{
        
        let vista = UIView()
        vista.translatesAutoresizingMaskIntoConstraints = false
        vista.backgroundColor = UIColor.grayColor()
        
        
        vista.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.ShowNewDataReload))
        vista.addGestureRecognizer(tap)
        
        
        
        let labelMsg = UILabel()
        labelMsg.translatesAutoresizingMaskIntoConstraints = false
        labelMsg.text = "\(self.arrayNewRunning.count) carreras nuevas"
        vista.addSubview(labelMsg)
        
        
        let heightL = NSLayoutConstraint(item: labelMsg, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        
        let widthL = NSLayoutConstraint(item: labelMsg, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 145)
       
        
         let alignXL = NSLayoutConstraint(item: labelMsg, attribute: .CenterX, relatedBy: .Equal, toItem: vista, attribute: .CenterX, multiplier: 1, constant: 0)
        
        let alignyL = NSLayoutConstraint(item: labelMsg, attribute: .CenterY, relatedBy: .Equal, toItem: vista, attribute: .CenterY, multiplier: 1, constant: 0)
        
        
        vista.addConstraints([heightL, widthL, alignXL, alignyL])
        
        
        
        let icono = UIImageView(image: UIImage(named: "up"))
        icono.translatesAutoresizingMaskIntoConstraints = false
        vista.addSubview(icono)
        
        let height = NSLayoutConstraint(item: icono, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)
        
        let width = NSLayoutConstraint(item: icono, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 30)
        
        let left = NSLayoutConstraint(item: icono, attribute: .Left, relatedBy: .Equal, toItem: labelMsg, attribute: .Left, multiplier: 1, constant: -50)
        
        let aligny = NSLayoutConstraint(item: icono, attribute: .CenterY, relatedBy: .Equal, toItem: vista, attribute: .CenterY, multiplier: 1, constant: 0)
        
        
        vista.addConstraints([height, width, aligny, left])
        
        
        
        return vista
    }
    
    //Conectividad - actualiza estado
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
    
    
    
    
    

    

}
