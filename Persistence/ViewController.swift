//
//  ViewController.swift
//  Persistence
//
//  Created by lai001 on 2019/7/13.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import Security

class ViewController: UIViewController {
    
    var homeDirectory: String {
        return NSHomeDirectory()
    }
    
    var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
    }
    
    var tmpDirectory: String {
        return NSTemporaryDirectory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\([#line])", homeDirectory)
        
        print("\nuserDefaults ---------------------------------------------------------------------------\n")
        userDefaults()
        print("\nplist ----------------------------------------------------------------------------------\n")
        plist()
        print("\narchiver -------------------------------------------------------------------------------\n")
        archiverCustomData()
        
        
    }


}

extension ViewController {
    func userDefaults() {
        // 数据自动保存在沙盒的Libarary/Preferences目录下, ITunes 会同步备份
        // 定时把缓存中的数据写入磁盘，不是即时写入
        UserDefaults.standard.set(URL(string: "https://www.apple.com"), forKey: "URL")
        
        UserDefaults(suiteName: "Custom")?.set(true, forKey: "Bool") // 创建新的Custom.plist文件存储数据
        UserDefaults(suiteName: "Custom")?.set(1.11, forKey: "Double")
        UserDefaults(suiteName: "Custom")?.set(Date(), forKey: "Any")
        
        UserDefaults.standard.addSuite(named: "Custom") // 将Custom.plist添加到 UserDefaults.standard 的搜索列表里
        print(UserDefaults.standard.object(forKey: "Any"))
        
        UserDefaults(suiteName: "Custom")?.removeObject(forKey: "Any") // 移除 Key 为"Any"的数据
        
        UserDefaults(suiteName: "Custom")?.register(defaults: ["Any" : URL(string: "https://www.apple.com")]) // 为 "Any"键 注册一个默认值，表明如果在文件中搜索不到 "Any"键，则返回默认值
        print(UserDefaults(suiteName: "Custom")?.url(forKey: "Any"))
        
        
        UserDefaults(suiteName: "Custom")?.setPersistentDomain(["Persistent Domain Key1" : 11, "Persistent Domain Key2" : 22], forName: "Custom Persistent Domain") // 创建了 Custom Persistent Domain.plist 文件，等价于38，39行
        UserDefaults(suiteName: "Custom Persistent Domain")?.set(11, forKey: "Persistent Domain Key1")
        UserDefaults(suiteName: "Custom Persistent Domain")?.set(22, forKey: "Persistent Domain Key2")
        
        print(UserDefaults(suiteName: "")?.persistentDomain(forName: "Custom Persistent Domain")) // 打印出 Custom Persistent Domain.plist 文件里的数据，只用关注后面forName:里的字符串是否正确，不论前面的 suiteName:里填的是什么字符串，都能取到数据
        
        
        UserDefaults(suiteName: "")?.removePersistentDomain(forName: "Custom Persistent Domain") // 执行后会将 Custom Persistent Domain.plist 里的数据清空
        print(UserDefaults(suiteName: "")?.persistentDomain(forName: "Custom Persistent Domain"))
        
        
        UserDefaults(suiteName: "Custom")?.setVolatileDomain(["Volatile Domain Key1" : 11, "Volatile Domain Key2" : 22], forName: "Custom Volatile Domain") // 不同于 setPersistentDomain(_:forName:) 方法，这种方法是将数据储存在内存中，并不写入到磁盘
        print(UserDefaults(suiteName: "")?.volatileDomain(forName: "Custom Volatile Domain"))
        
        print(UserDefaults.globalDomain, UserDefaults.argumentDomain, UserDefaults.registrationDomain) // 默认的3个Domain
        
        
        UserDefaults(suiteName: "Custom")?.synchronize() // 立即写入到磁盘
        UserDefaults.standard.synchronize()
        UserDefaults(suiteName: "Custom Volatile Domain")?.synchronize()
    }
    
    // 和UserDefaults类似，都是利用plist序列化文件储存数据，不过能自定义文件路径
    func plist() {
        let tempPlistFile = URL(fileURLWithPath: "temp.plist", isDirectory: false, relativeTo: URL(fileURLWithPath: tmpDirectory))
        
        let data = [1, ["array"], ["key" : "value"], 4, true, 11.1234] as NSArray
        data.write(to: tempPlistFile, atomically: true)
        
        if #available(iOS 11.0, *) {
            try? data.write(to: tempPlistFile)
        }
        
        data.write(toFile: tempPlistFile.path, atomically: true)
        
    }
    
    func archiverCustomData() {
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
