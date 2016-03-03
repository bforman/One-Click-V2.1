//
//  BLE_Manager.swift
//  One_Click_V2
//
//  Created by Matthew Joyce on 2/27/16.
//  Copyright © 2016 Matthew Joyce. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLE_Manager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate  {
    
    private let TX_UUID =      "713D0002-503E-4C75-BA94-3148F18D941E"
    private let RX_UUID =      "713D0003-503E-4C75-BA94-3148F18D941E"
    private let SERVICE_UUID = "713D0000-503E-4C75-BA94-3148F18D941E"
    
    private var centralManager:       CBCentralManager!
    private var connectingPeripheral: CBPeripheral!
    private var RX_Characteristic :   CBCharacteristic!
    private var TX_Characteristic :   CBCharacteristic!
    
    private static var instanceCount = 0
    private static var BLEInstance :   BLE_Manager!
    
    private var blueToothReady =           false
    private var numberOfPeripheralsFound = 0
    private var foundPeripherals =         [CBPeripheral]()
    var data: NSData!
    
    static func shareInstance() -> BLE_Manager
    {
        if (instanceCount == 0)
        {
            BLEInstance = BLE_Manager();
            BLEInstance.centralManager = CBCentralManager(delegate: BLEInstance, queue: nil);
            instanceCount = 1
        }
        return BLEInstance;
    }
    
    func getBluetoothStatus() -> Bool {
        return blueToothReady
    }
    
    func getNumberOfPeripheralsFound() -> Int
    {
        return numberOfPeripheralsFound
    }
    
    func getFoundPeripherals() -> [CBPeripheral]
    {
        return foundPeripherals
    }
    /**
     initilizes the centralManger
     */
    func startUpCentralManager() {
        print("startUpCentralManager(): Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        print("Method Call: discoveringDevices")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
        print("discoveringDevices(): Started scan for peripherals")
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String: AnyObject], RSSI: NSNumber)
    {
        print("Method Call: didDiscoverPeripheral")
        //connectingPeripheral = peripheral
        if (peripheral.name != nil)
        {
            print("Peripheral found: " + peripheral.name!)
        }
        if (!foundPeripherals.contains(peripheral))
        {
            if (peripheral.name != nil) {
                foundPeripherals.append(peripheral)
                numberOfPeripheralsFound++
            }
        }
    }
    
    func getPeripheral() -> CBPeripheral {
        return connectingPeripheral
    }
    
    func getTX() -> CBCharacteristic {
        return TX_Characteristic
    }
    
    func getCentral() -> CBCentralManager {
        return centralManager
    }
    
    func connectToSpecificPeripheral(index: Int)
    {
            centralManager.stopScan()
            connectingPeripheral = foundPeripherals[index]
            print("Scanning stopped")
            centralManager.connectPeripheral(connectingPeripheral, options: nil)
    }
    
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        print("Method Call: didConnectToPeripheral()")
        //print("Peripheral: " + connectingPeripheral.description)
       
        
        connectingPeripheral.delegate = self //Not sure why this is here.
        
        let services:[CBUUID] = [CBUUID(string: SERVICE_UUID)]
        //print(services)
        print("Method Call: discoverServices()")
        connectingPeripheral.discoverServices(services)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("Discovered Services")
        print(connectingPeripheral.services)
        for service in connectingPeripheral.services! {
            print(service.UUID)
            if service.UUID.UUIDString == "713D0000-503E-4C75-BA94-3148F18D941E" {
                print("Method Call: discoverCharacteristic()")
                connectingPeripheral.discoverCharacteristics(nil, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("Method Call: didDiscoverCharacteristicForSerivce()")
        
        RX_Characteristic = service.characteristics?.first
        TX_Characteristic = service.characteristics?.last
        
        let WRITE_VALUE = "Hello Arduino"
        let DATA = WRITE_VALUE.dataUsingEncoding(NSUTF8StringEncoding)
        connectingPeripheral.writeValue(DATA!, forCharacteristic: RX_Characteristic, type: CBCharacteristicWriteType.WithoutResponse)
        print(WRITE_VALUE + " Written to Peripheral")
        
        print("TX Notify Value set to true");
        connectingPeripheral.setNotifyValue(true, forCharacteristic: TX_Characteristic)
        
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("Method Call: centralManagerDidUpdateState")
        blueToothReady = false;
        var status : String
        switch (central.state) {
        case .PoweredOff:
            status = "CoreBluetooth BLE hardware is powered off"
            
        case .PoweredOn:
            status = "CoreBluetooth powered on and ready"
            blueToothReady = true;
            
        case .Resetting:
            status = "CoreBluetooth BLE hardware is resetting"
            
        case .Unauthorized:
            status = "CoreBluetooth BLE state is unauthorized"
            
        case .Unknown:
            status = "CoreBluetooth BLE state is unknown"
            
        case .Unsupported:
            status = "CoreBluetooth BLE hardware is unsupported"
        }
        print(status)
        
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        print("Value for Characteristic Updated")
        print(characteristic.value!)
        data = characteristic.value!
        //Stop from false
        //connectingPeripheral.setNotifyValue(false, forCharacteristic: TX_Characteristic)

        
    }
    
    func disconnect() {
        centralManager.cancelPeripheralConnection(connectingPeripheral)
    }
    
    func retrieveData() -> NSData {
        return data
    }


    
    
    
}
