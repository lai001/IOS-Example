//
//  User.swift
//  Persistence
//
//  Created by lai001 on 2019/7/13.
//  Copyright © 2019 none. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.age, forKey: "age")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let name = aDecoder.decodeObject(forKey: "name") as? String {
            let age = aDecoder.decodeInteger(forKey: "age")
            self.name = name
            self.age = age
        } else {
            return nil
        }
    }
    
    let name: String
    let age: Int
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
