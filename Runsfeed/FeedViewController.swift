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
        
    }
    
    
    
    //MARK: - TableView Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0{
            cell  = tableFeed.dequeueReusableCellWithIdentifier(CellUser.returnID(), forIndexPath: indexPath) as! CellUser
        }
        else{
            cell  = tableFeed.dequeueReusableCellWithIdentifier(CellDataRun.returnID(), forIndexPath: indexPath) as! CellDataRun
        }
        
        
        
    
        
        return cell
        
    }
    

    

}
