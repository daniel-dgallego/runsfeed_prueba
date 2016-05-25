//
//  FeedViewController.swift
//  Runsfeed
//
//  Created by Daniel Gallego Peralta on 25/5/16.
//  Copyright © 2016 runator.com. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableFeed: UITableView!
    //MARK: - Life cicle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Custom Views
    
    
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
        
    }
    
    
    
    //MARK: - TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0{
            cell  = tableFeed.dequeueReusableCellWithIdentifier(CellUser.returnID(), forIndexPath: indexPath) as! CellUser
        }
        else if indexPath.row == 1{
            cell  = tableFeed.dequeueReusableCellWithIdentifier(CellDataRun.returnID(), forIndexPath: indexPath) as! CellDataRun
        }
        else if indexPath.row == 2{
            cell = tableFeed.dequeueReusableCellWithIdentifier(CellMap.returnID(), forIndexPath: indexPath) as! CellMap
        }
        else if indexPath.row == 3{
            cell = tableFeed.dequeueReusableCellWithIdentifier(CellLike.returnID(), forIndexPath: indexPath) as! CellLike
        }
        else{
            cell = tableFeed.dequeueReusableCellWithIdentifier(CellComment.returnID(), forIndexPath: indexPath) as! CellComment
        }
        
        
        
    
        cell.selectionStyle = .None
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
    

    

}
