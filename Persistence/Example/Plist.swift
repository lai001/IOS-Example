//
//  Plist.swift
//  Persistence
//
//  Created by lai001 on 2019/7/13.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation

class Plist {
    
    var tmpDirectory: String {
        return NSTemporaryDirectory()
    }
    
    func example() {
        let tempPlistFile = URL(fileURLWithPath: "temp.plist", isDirectory: false, relativeTo: URL(fileURLWithPath: tmpDirectory))
        
        let data = [1, ["array"], ["key" : "value"], 4, true, 11.1234] as NSArray
        data.write(to: tempPlistFile, atomically: true)
        
        if #available(iOS 11.0, *) {
            try? data.write(to: tempPlistFile)
        }
        
        data.write(toFile: tempPlistFile.path, atomically: true)
    }
}
