//
//  DataLogView.swift
//  One_Click_V2
//
//  Created by Ben Forman on 3/3/16.
//  Copyright © 2016 Matthew Joyce. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth


class DataLogView: UIViewController {
    
    @IBOutlet weak var dataField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = self.dataFilePath()
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath)) {
            let array = NSArray(contentsOfFile: filePath) as! [String]
            for var i = 0; i < array.count; i++ {
                dataField.text = array[i]
                print("")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dataFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        let documentDirectory = paths[0] as NSString
        return documentDirectory.stringByAppendingPathComponent("sensordata.plist")
            as String
    }
    
}