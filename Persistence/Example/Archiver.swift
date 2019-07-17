//
//  Archiver.swift
//  Persistence
//
//  Created by lai001 on 2019/7/13.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation

class Archiver {
    var tmpDirectory: String {
        return NSTemporaryDirectory()
    }
    
    func example() {
        let archiverCustomDataFile = URL(fileURLWithPath: "archiverCustomData", isDirectory: false, relativeTo: URL(fileURLWithPath: tmpDirectory))
        
        //归档
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        let array = ["1","2","3"]
        let user = User(name: "lai001", age: 18)
        archiver.encode(array, forKey:"array")
        archiver.encode(20, forKey: "number")
        archiver.encode(user, forKey: "user")
        archiver.finishEncoding()
        
        do {
            try data.write(to: archiverCustomDataFile, options: .atomic)
        } catch let error {
            print(error)
        }
        
        //反归档
        if let unarchiverData = NSData(contentsOfFile: archiverCustomDataFile.path) {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: unarchiverData as Data)
            let decodeData = unarchiver.decodePropertyList(forKey: "array") as? NSArray
            let decodeAge = unarchiver.decodeInteger(forKey: "number")
            let decodeUser = unarchiver.decodeObject(forKey: "user") as? User
            print(decodeData, decodeAge, decodeUser)
        }
        
        // -------------------------------------------------------------------------------------------
        
        do {
            let archiverCustomDataFile1 = URL(fileURLWithPath: "archiverCustomData1", isDirectory: false, relativeTo: URL(fileURLWithPath: tmpDirectory))
            let rootObject = User(name: "lai001", age: 18)
            
            NSKeyedArchiver.archiveRootObject(rootObject, toFile: archiverCustomDataFile1.path)
            
            let unarchiver = NSKeyedUnarchiver.unarchiveObject(withFile: archiverCustomDataFile1.path)
            let user = unarchiver as? User
            print(user?.name, user?.age)
            
            
            if let unarchiverData = NSData(contentsOfFile: archiverCustomDataFile1.path) {
                let unarchiver = NSKeyedUnarchiver.unarchiveObject(with: unarchiverData as Data)
                let user = unarchiver as? User
                print(user?.name, user?.age)
            }
            
        }
    }
}
