//
//  InspectViewController.swift
//  One_Click_V2
//
//  Created by Ben Forman on 2/28/16.
//  Copyright © 2016 Matthew Joyce. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class InspectViewController: UIViewController {
    var BLE: BLE_Manager!
    
    var receivedPeripheralName: String = ""
    var receivedData: NSData!
    var p: CBPeripheral!
    var c: CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showMessage()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        showMessage()
        //BLE.getFoundPeripherals()
        BLE = BLE_Manager.shareInstance()
        p = BLE.getPeripheral()
        //c = BLE.getCentral()
    }
    
    @IBAction func disconnectPressed(sender: AnyObject) {
        DataLabel.text = ""
        let name = p.name
        BLE.disconnect()
        //c.cancelPeripheralConnection(p)
        print("disconnected")
        //let name = p.name
        let message = "Disconnected from " + name!
        let controller = UIAlertController(title: "Disconnection Complete",
            message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)

        
    }
    
    @IBOutlet weak var DataLabel: UILabel!
    
    @IBAction func inspectPressed(sender: AnyObject) {
        //let receivedData = BLE.retrieveData()
        //print(datastring)
        let tx: CBCharacteristic = BLE.getTX()
        receivedData = tx.value
        let datastring = NSString(data: receivedData, encoding: NSASCIIStringEncoding) as! String
        //p.readValueForCharacteristic(tx)
        DataLabel.text = datastring
    }
    
    func showMessage() {
        //let name = p.name
        let message = "Connected to Peripheral"
        let controller = UIAlertController(title: "Connection Complete",
            message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        controller.addAction(action)
        presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}