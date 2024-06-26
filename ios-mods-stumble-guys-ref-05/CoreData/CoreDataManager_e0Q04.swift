//
//  CoreDataManager.swift
//  ios-mods-stumble-guys
//
//  Created by Alisher on 28.11.2023.
//

import CoreData
import UIKit

class CoreDataManager_e0Q04 {
    static let shared = CoreDataManager_e0Q04()
    
    let context: NSManagedObjectContext
    
    private init() {
        
        func adiwQSJDwsa_e0Q04() -> Int {
            let result = Int.random(in: 1...100) + Int.random(in: 1...100)
            return result
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to retrieve shared app delegate.")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveOrUpdateCharacter(uuid: UUID? = nil, type: CharacterType, items: [String: String], photoURL: URL? = nil) -> UUID {
        let character: Character

        if let uuid = uuid, let existingCharacter = fetchCharacter_e0Q04(with: uuid) {
            character = existingCharacter
        } else {
            let characterEntity = NSEntityDescription.entity(forEntityName: "Character", in: context)!
            character = Character(entity: characterEntity, insertInto: context)
            character.uuid = UUID()
        }

        character.lastUpdatedDate = Date()
        
        character.gender = type == .boy ? "boy" : "girl"
        
        if let photoURL = photoURL {
            character.photo = photoURL.lastPathComponent
            print("Saving image filename to Core Data: \(photoURL.lastPathComponent)")
        }
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: items, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            character.items = jsonString
        }
        
        do {
            try context.save()
            print("Character saved or updated successfully.")
        } catch {
            print("Failed to save or update character: \(error)")
        }
        
        return character.uuid! // Return the UUID of the character
    }
    
    func fetchCharacter_e0Q04(with uuid: UUID) -> Character? {
        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("Failed to fetch character with UUID \(uuid): \(error)")
            return nil
        }
    }
    
    func fetchAllCharacters() -> [Character] {
        let fetchRequest: NSFetchRequest<Character> = Character.fetchRequest()
        
        do {
            let characters = try context.fetch(fetchRequest)
            characters.forEach { character in
                if let charPhoto = character.photo {
                    print("Fetched character with photo path: \(charPhoto)")
                }
            }
            return characters
        } catch {
            print("Failed to fetch characters: \(error)")
            return []
        }
    }
    
    func deserializeItems(from character: Character) -> [String: String]? {
        guard let itemsString = character.items,
              let jsonData = itemsString.data(using: .utf8) else {
            print("No items string to deserialize or unable to convert string to data.")
            return nil
        }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: String]
            print("Deserialized items dictionary: \(dictionary ?? [:])")
            return dictionary
        } catch {
            print("Failed to deserialize items: \(error)")
            return nil
        }
    }

    func updateCharacterPhoto(uuid: UUID, photoURL: URL) {
        if let character = fetchCharacter_e0Q04(with: uuid) {
            character.photo = photoURL.path
            
            do {
                try context.save()
                print("Character saved or updated successfully with items: \(character.items ?? "nil")")
                print("Character saved or updated successfully with UUID: \(String(describing: character.uuid))")
            } catch {
                print("Failed to save or update character: \(error)")
            }
        }
    }
    
    func clearAllCoreData() {
        let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        guard (persistentContainer?.viewContext) != nil else { return }
        
        let entities = persistentContainer?.managedObjectModel.entities
        guard let entities = entities else { return }
        
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    private func clearDeepObjectEntity(entity: String) {
        let persistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        let managedContext = persistentContainer?.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext?.execute(deleteRequest)
            try managedContext?.save()
        } catch let error {
            print("Failed to delete entity \(entity) with error: \(error)")
        }
    }
    
    func deleteCharacter(with uuid: UUID) {
        if let character = fetchCharacter_e0Q04(with: uuid) {
            context.delete(character)
            do {
                try context.save()
                print("Character with UUID \(uuid) deleted successfully.")
            } catch {
                print("Failed to delete character with UUID \(uuid): \(error)")
            }
        } else {
            print("Character with UUID \(uuid) not found, cannot delete.")
        }
    }
}
