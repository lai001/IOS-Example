//
//  ViewController.swift
//  Persistence
//
//  Created by lai001 on 2019/7/13.
//  Copyright © 2019 none. All rights reserved.
//

import UIKit
import Security
import CoreData

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
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // deploying to an earlier target
    lazy var managedObjectModel: NSManagedObjectModel? = {
        if let url = Bundle.main.url(forResource: "CoreDataModel", withExtension: "momd") {
            return NSManagedObjectModel(contentsOf: url)
        } else {
            return nil
        }
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        if let managedObjectModel = self.managedObjectModel {
            return NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        } else {
            return nil
        }
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = persistentStoreCoordinator
        return moc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\([#line])", homeDirectory)
        
//        print("\nuserDefaults ---------------------------------------------------------------------------\n")
//        UserDefault().example()
//        print("\nplist ----------------------------------------------------------------------------------\n")
//        Plist().example()
//        print("\narchiver -------------------------------------------------------------------------------\n")
//        Archiver().example()
//        print("\ncore data ------------------------------------------------------------------------------\n")
        coreData()
        
    
        
    }


}

extension ViewController {
    
    func coreData() {
        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let fileURL = URL(string: "CoreDataModel.sql", relativeTo: dirURL)

        do {
            try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType,
                                       configurationName: nil,
                                       at: fileURL, options: nil)
        } catch let error {
            print("Error configuring persistent store: \(error)")
        }
        
        let coreDataUser = NSEntityDescription.insertNewObject(forEntityName: "CoreDataUser", into: managedObjectContext) as! CoreDataUser
        
        coreDataUser.age = 18
        coreDataUser.name = "lai001"
        do {
            try managedObjectContext.save()
        } catch let error {
            print(error)
        }
        
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName:"CoreDataUser")
        fetchRequest.fetchLimit = 10 //限定查询结果的数量
        fetchRequest.fetchOffset = 0 //查询的偏移量
        
        //设置查询条件
        let predicate = NSPredicate(format: "name= 'lai001' ", "")
        fetchRequest.predicate = predicate
        
        //查询操作
        do {
            let fetchedObjects = try managedObjectContext.fetch(fetchRequest)
            
            for info in fetchedObjects {
                //修改密码
                info.name = "lai002"
                //重新保存
                try managedObjectContext.save()
                print("修改成功！")
            }
            
        }
        catch {
            print("查询失败：\(error)")
        }
    }
}

@available(iOS 10.0, *)
extension NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
