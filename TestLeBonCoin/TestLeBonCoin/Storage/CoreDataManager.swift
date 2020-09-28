//
//  CoreDataManager.swift
//  TestLeBonCoin
//
//  Created by Damien on 28/09/2020.
//

import Foundation
import CoreData

class CoreDataManager<I: ItemProtocol,C: CategoryProtocol> {
    private var persist: Bool
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: StorageConstants.dataModelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("Unresolved error: \(error), \(error.userInfo)")
        })
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    init(persist: Bool = true) {
        self.persist = persist
        setupPersistentStore()
    }
    func setupPersistentStore() {
        let description = NSPersistentStoreDescription()
        description.type = persist ?  NSSQLiteStoreType : NSInMemoryStoreType
        // set desired type
        if description.type == NSSQLiteStoreType || description.type == NSBinaryStoreType {
            // for persistence on local storage we need to set url
            description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent(StorageConstants.dataBaseName)
        }
        self.persistentContainer.persistentStoreDescriptions = [description]
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("could not load store \(error.localizedDescription)")
                return
            }
            print("store loaded")
        }
    }

    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    lazy var bgContext: NSManagedObjectContext  = {
        let ct = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        ct.parent = context
        return ct
    }()

    // MARK: - Core Data read and write
    func saveCategoriesInBase(items: [CategoryProtocol]) {
        bgContext.performAndWait {
            for item in items {
                var  categoryCoreData :NSManagedObject?
                let fetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: StorageConstants.CategoryCoreDataEntityName)
                fetchRequest.predicate = NSPredicate(format: "\(StorageConstants.id) == \(item.getId())")
                categoryCoreData = try? bgContext.fetch(fetchRequest).first
                if categoryCoreData == nil {
                    let entity =
                        NSEntityDescription.entity(forEntityName: StorageConstants.CategoryCoreDataEntityName,
                                                   in: bgContext)!
                    print("create entity \(StorageConstants.CategoryCoreDataEntityName)")
                    categoryCoreData = NSManagedObject(entity: entity,
                                                       insertInto: bgContext)
                }
                categoryCoreData?.setValue(item.getId(), forKeyPath: StorageConstants.id)
                categoryCoreData?.setValue(item.getName(), forKeyPath: StorageConstants.name)
            }
        }
        save()
    }

    func getCategoriesInBase() -> [CategoryProtocol] {
        var result = [CategoryProtocol]()
        let managedContext = context
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: StorageConstants.CategoryCoreDataEntityName)
        do {
            let  categoriesCoreData = try managedContext.fetch(fetchRequest)
            for categoryCoreData in categoriesCoreData {
                if let id =  categoryCoreData.value( forKeyPath: StorageConstants.id) as? Int,
                   let name = categoryCoreData.value( forKeyPath: StorageConstants.name) as? String {
                    let newItem: C = C(id: id,
                                       name: name)
                    result.append(newItem)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }

    func deleteEntity(name:String) {
        bgContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try bgContext.fetch(fetchRequest)
                for managedObject in results {
                    if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                        bgContext.delete(managedObjectData)
                    }
                }
            } catch let error as NSError {
                print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
            }
        }
        save()
    }

    func saveItemsInBase(items: [ItemProtocol]) {
        bgContext.performAndWait {
            for item in items {
                var  itemCoreData :NSManagedObject?
                let fetchRequest =
                    NSFetchRequest<NSManagedObject>(entityName: StorageConstants.ItemCoreDataEntityName)
                fetchRequest.predicate = NSPredicate(format: "\(StorageConstants.id) == \(item.getId())")
                itemCoreData = try? bgContext.fetch(fetchRequest).first
                if itemCoreData == nil {
                    let entity =
                        NSEntityDescription.entity(forEntityName: StorageConstants.ItemCoreDataEntityName,
                                                   in: bgContext)!
                    itemCoreData = NSManagedObject(entity: entity,
                                                   insertInto: bgContext)
                    print("create entity \(StorageConstants.ItemCoreDataEntityName) \(item.getId())")
                }
                itemCoreData?.setValue(item.getId(), forKeyPath: StorageConstants.id)
                itemCoreData?.setValue(item.getTitle(), forKeyPath: StorageConstants.title)
                itemCoreData?.setValue(item.getDescription(), forKeyPath: StorageConstants.descr)
                itemCoreData?.setValue(item.getPrice(), forKeyPath: StorageConstants.price)
                itemCoreData?.setValue(item.isUrgent(), forKeyPath: StorageConstants.is_urgent)
                itemCoreData?.setValue(item.getCategoryId(), forKeyPath: StorageConstants.category_id)
                itemCoreData?.setValue(item.getLargeImageUrl(), forKeyPath: StorageConstants.large_image_url)
                itemCoreData?.setValue(item.getSmallImageUrl(), forKeyPath: StorageConstants.small_image_url)
                itemCoreData?.setValue(item.getCreationDate(), forKeyPath: StorageConstants.creation_date)
            }
        }
        save()
    }

    func getItemsInBase() -> [ItemProtocol] {
        var result = [ItemProtocol]()
        let managedContext = context
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: StorageConstants.ItemCoreDataEntityName)
        do {
            let  itemsCoreData = try managedContext.fetch(fetchRequest)
            for itemCoreData in itemsCoreData {
                if let id =  itemCoreData.value( forKeyPath: StorageConstants.id) as? Int,
                   let title = itemCoreData.value( forKeyPath: StorageConstants.title) as? String,
                   let description = itemCoreData.value( forKeyPath: StorageConstants.descr) as? String,
                   let price =  itemCoreData.value( forKeyPath: StorageConstants.price) as? Float,
                   let isUrgent = itemCoreData.value( forKeyPath: StorageConstants.is_urgent) as? Bool,
                   let catId = itemCoreData.value( forKeyPath: StorageConstants.category_id) as? Int,
                   let largeImage = itemCoreData.value( forKeyPath: StorageConstants.large_image_url) as? String,
                   let smallImage = itemCoreData.value( forKeyPath: StorageConstants.small_image_url) as? String,
                   let date = itemCoreData.value( forKeyPath: StorageConstants.creation_date) as? Date
                {
                    let newItem: I = I(id: id,
                                       title: title,
                                       description: description,
                                       catId: catId,
                                       price: price,
                                       largeImage: largeImage,
                                       smallImage: smallImage,
                                       creationDate: date,
                                       isUrgent: isUrgent)
                    result.append(newItem)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }

    // MARK: - Core Data Saving support

    func save() {
        saveContext(context: context)
        saveContext(context: bgContext)
    }

    func saveContext (context :NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
