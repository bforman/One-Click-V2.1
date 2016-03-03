//
//  ViewController.swift
//  One_Click_V2
//  Verison 2 of One_Click. This verison builds off of One_Click_V1.
//  Additions include: minor changes to BLE functionality in ViewController.swift
//                     addition of tableview
//
//  Created by Matthew Joyce on 2/26/16.
//  Copyright © 2016 Matthew Joyce. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    var BLE: BLE_Manager!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Method Call: ViewDidLoad()");
        
        //Will start up central Manager
        BLE = BLE_Manager.shareInstance();
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func beginScanForPeripheral(sender: AnyObject) {
        if (BLE.getBluetoothStatus())
        {
            BLE.discoverDevices()
        }
        
    }

}

