//
//  TableViewController.swift
//  One_Click_V2
//
//  Created by Matthew Joyce on 2/27/16.
//  Copyright © 2016 Matthew Joyce. All rights reserved.
//

import UIKit
import CoreBluetooth

class TableViewController: UITableViewController
{
    var BLE: BLE_Manager!
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BLE = BLE_Manager.shareInstance()
        let refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: Selector("reloadView"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
    }
    
    func reloadView()
    {
        tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLE.getNumberOfPeripheralsFound()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var peripherals = BLE.getFoundPeripherals()
        //cell.textLabel!.text = "HELLO"
        cell.textLabel!.text = peripherals[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var peripherals = BLE.getFoundPeripherals()
        let rowValue = peripherals[indexPath.row]
        if (rowValue.name != nil) {
            name = rowValue.name!
            BLE.connectToSpecificPeripheral(indexPath.row)
            performSegueWithIdentifier("toInspect", sender: self)
            print("performed segue")
        }
        //BLE.connectToSpecificPeripheral(indexPath.row)
        //performSegueWithIdentifier("toMain", sender: action)

    }
    
    
    
    
    
    
    
}
