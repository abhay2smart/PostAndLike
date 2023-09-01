//
//  CommentPersistantManager.swift
//  PostAndLike
//
//  Created by Abhayjeet Singh on 31/08/23.
//

import Foundation
import CoreData

final class CommentPersistantManager {
    static let shared = CommentPersistantManager()
    static private let DBName = "PostAndLike"
    static private let entityName = "CommentsEntity"
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
    
    
    func saveSingleRecord(data: CommentModel, completion: @escaping ((Bool)->())) {
        
        guard let id = data.id, let postId = data.postId else {
            completion(false)
            return
        }
        
        let context = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: CommentPersistantManager.entityName, in: context) else {
            return
        }
        
        context.performAndWait {
            
            let commentEntityObject = CommentsEntity(entity: entity, insertInto: context)
            
            commentEntityObject.id = Int32(id)
            commentEntityObject.postId = Int32(postId)
            
            commentEntityObject.name = data.name
            
            commentEntityObject.email = data.email
            commentEntityObject.comment = data.body
            
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
    
    
    
    
    
    
    func fetchRecordFromCoreDataByPostId(postId: Int)->[CommentModel]? {
        
        let context = persistentContainer.viewContext
        
        // Create a fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CommentPersistantManager.entityName)
        fetchRequest.predicate = NSPredicate(format: "postId == %ld", postId)
        
        //Add a sort descriptor to sort the results
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Replace "id" with other the attribute you want to sort by attribute
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            var codableData : [CommentModel] = []
            let result = try context.fetch(fetchRequest)
            guard let entityObjects = result as? [CommentsEntity] else {
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
    
    private func convertEntityObjectsToCodable(entityObjects: [CommentsEntity])->[CommentModel] {
        var results = [CommentModel]()
        for item in entityObjects {
            var comment = CommentModel()
            comment.id = Int(item.id)
            comment.postId = Int(item.postId)
            comment.name = item.name
            comment.email = item.email
            comment.body = item.comment
            results.append(comment)
        }
        return results
    }
    
    
    
    func setLikeUnLike(id: Int, postId: Int, isFavourite: Bool, completion: @escaping ((Bool)->()) ) {
        
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CommentPersistantManager.entityName)
        //fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND postId == %ld", id, postId)
        
        do {
            let fetched = try context.fetch(fetchRequest)
            let objectUpdate = fetched[0]
            objectUpdate.setValue(isFavourite, forKey: "isFavourite")
            
            do {
                try context.save()
                completion(true)
            }
            catch {
                completion(false)
            }
        } catch {
            completion(false)
        }
    }
    
    func isRecordExists(id: Int, postId: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CommentPersistantManager.entityName)
        //fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND postId == %ld", id, postId)
        
        //fetchRequest.predicate = NSPredicate(format: "companyOffice == %@ AND employNo == %@", companyOffice, employNo)
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
    
    
    func isAlreadyLiked(id: Int, postId: Int)-> Bool {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CommentPersistantManager.entityName)
        
        fetchRequest.predicate = NSPredicate(format: "id == %ld AND postId == %ld AND isFavourite == %@", id, postId, NSNumber(value: true))
        
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
    
    
    func getFavouriteList()->[CommentModel]? {
        let context = persistentContainer.viewContext
        
        // Create a fetch request
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CommentPersistantManager.entityName)
        
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        
        do {
            var codableData : [CommentModel] = []
            let result = try context.fetch(fetchRequest)
            guard let entityObjects = result as? [CommentsEntity] else {
                return nil
            }
            //print("entityObjects \(entityObjects.first?.name)")
            codableData = convertEntityObjectsToCodable(entityObjects: entityObjects)
            return codableData
            //return result as? [Posts]
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
        
    }
    
}

