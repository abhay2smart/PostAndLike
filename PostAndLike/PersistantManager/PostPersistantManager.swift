//
//  PersistantManager.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation

import CoreData

final class PostPersistantManager {
    static let shared = PostPersistantManager()
    static private let DBName = "PostAndLike"
    static private let entityName = "PostsEntity"
    private init() {
        
    }
    // Set up Core Data model and context
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DBName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        })
        return container
    }()
    
    
    func saveSingleRecord(data: PostModel, completion: @escaping ((Bool)->())) {
        guard let id = data.id, let userId = data.userId else {
            return
        }

        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: PostPersistantManager.entityName, in: context) else {
            return
        }

        context.performAndWait {

            let postItem = PostsEntity(entity: entity, insertInto: context)
            
            postItem.id = Int32(id)
            postItem.userId = Int32(userId)
            postItem.title = data.title
            postItem.body = data.body
            // Save managed object context
            do {
                try context.save()
                completion(true)
            } catch {
                completion(false)
                print("Failed to save Core Data context: \(error)")
            }
        }
    }
    
    
    func isRecordExists(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PostPersistantManager.entityName)
        //fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = NSPredicate(format: "id == %ld", id)
        let context = persistentContainer.viewContext
        
        var results: [NSManagedObject] = []
        
        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return results.count > 0
    }
    
    
    
    func fetchRecordFromCoreData()->[PostModel]? {

        let context = persistentContainer.viewContext

        // Create a fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PostPersistantManager.entityName)

        //Add a sort descriptor to sort the results
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Replace "id" with other the attribute you want to sort by attribute
        fetchRequest.sortDescriptors = [sortDescriptor]

        // Set the fetch limit to retrieve only the top 10 records
        //fetchRequest.fetchLimit = 10


        do {
            var codableData : [PostModel] = []
            let result = try context.fetch(fetchRequest)
            guard let entityObjects = result as? [PostsEntity] else {
                return codableData
            }
            codableData = convertEntityObjectsToCodable(entityObjects: entityObjects)
            return codableData
            //return result as? [Posts]
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func convertEntityObjectsToCodable(entityObjects: [PostsEntity])->[PostModel] {
        var results = [PostModel]()
        for item in entityObjects {
            var post = PostModel()
            post.id = Int(item.id)
            post.userId = Int(item.userId)
            post.title = item.title
            post.body = item.body
            results.append(post)
        }
        return results
    }
    
}

