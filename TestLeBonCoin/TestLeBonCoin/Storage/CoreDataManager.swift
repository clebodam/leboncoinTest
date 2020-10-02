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
                var  categoryCoreData :CategoryCoreData?
                let fetchRequest =
                    NSFetchRequest<CategoryCoreData>(entityName: StorageConstants.CategoryCoreDataEntityName)
                fetchRequest.predicate = NSPredicate(format: "\(StorageConstants.id) == \(item.getId())")
                categoryCoreData = try? bgContext.fetch(fetchRequest).first
                if categoryCoreData == nil {
                    let entity =
                        NSEntityDescription.entity(forEntityName: StorageConstants.CategoryCoreDataEntityName,
                                                   in: bgContext)!
                    print("create entity \(StorageConstants.CategoryCoreDataEntityName)")
                    categoryCoreData = CategoryCoreData(entity: entity,
                                                        insertInto: bgContext)
                }
                categoryCoreData?.id = item.getId()
                categoryCoreData?.name = item.getName()
            }
        }
        save()
    }

    func getCategoriesInBase() -> [CategoryProtocol] {
        var result = [CategoryProtocol]()
        let managedContext = context
        let fetchRequest =
            NSFetchRequest<CategoryCoreData>(entityName: StorageConstants.CategoryCoreDataEntityName)
        do {
            let  categoriesCoreData = try managedContext.fetch(fetchRequest)
            for categoryCoreData in categoriesCoreData {

                let newItem: C = C(id: categoryCoreData.id,
                                   name: categoryCoreData.name)
                result.append(newItem)

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
                var  itemCoreData :ItemCoreData?
                let fetchRequest =
                    NSFetchRequest<ItemCoreData>(entityName: StorageConstants.ItemCoreDataEntityName)
                fetchRequest.predicate = NSPredicate(format: "\(StorageConstants.id) == \(item.getId())")
                itemCoreData = try? bgContext.fetch(fetchRequest).first
                if itemCoreData == nil {
                    let entity =
                        NSEntityDescription.entity(forEntityName: StorageConstants.ItemCoreDataEntityName,
                                                   in: bgContext)!
                    itemCoreData = ItemCoreData(entity: entity,
                                                insertInto: bgContext)
                    print("create entity \(StorageConstants.ItemCoreDataEntityName) \(item.getId())")
                }

                itemCoreData?.id = item.getId()
                itemCoreData?.title = item.getTitle()
                itemCoreData?.is_urgent = item.isUrgent()

                itemCoreData?.descr = item.getDescription()

                itemCoreData?.price = item.getPrice()

                itemCoreData?.category_id = item.getCategoryId()

                itemCoreData?.small_image_url = item.getSmallImageUrl()

                itemCoreData?.large_image_url = item.getLargeImageUrl()

                itemCoreData?.creation_date = item.getCreationDate()

            }
        }
        save()
    }

    func getItemsInBase(byId:Int?) -> [ItemProtocol] {
        var result = [ItemProtocol]()
        let managedContext = context
        let fetchRequest = NSFetchRequest<ItemCoreData>(entityName: StorageConstants.ItemCoreDataEntityName);

        let isUrgentSort =
            NSSortDescriptor(key: StorageConstants.is_urgent, ascending: false)

        let dateSort = NSSortDescriptor(key:StorageConstants.creation_date, ascending:false)
        if let id = byId {
            fetchRequest.predicate = NSPredicate(format:
                                                    " \(StorageConstants.category_id) == \(id)")
        }
        fetchRequest.sortDescriptors = [isUrgentSort, dateSort]
        do {
            let  itemsCoreData = try managedContext.fetch(fetchRequest)
            for itemCoreData in itemsCoreData {
                if let largeImage = itemCoreData.large_image_url,
                   let smallImage = itemCoreData.small_image_url, let date =  itemCoreData.creation_date
                {
                    let newItem: I = I(id: itemCoreData.id,
                                       title: itemCoreData.title,
                                       description: itemCoreData.descr,
                                       catId: itemCoreData.category_id,
                                       price: itemCoreData.price,
                                       largeImage: largeImage,
                                       smallImage: smallImage,
                                       creationDate: date,
                                       isUrgent: itemCoreData.is_urgent)
                    result.append(newItem)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result

    }

    func getItemsInBase() -> [ItemProtocol] {
        return getItemsInBase(byId:nil)
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
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
}
