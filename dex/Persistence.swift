//
//  Persistence.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 10/07/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
            let newPockemon = Pockemon(context: viewContext)
            newPockemon.id = 1;
            newPockemon.name = "TestPokemon"
            newPockemon.favourite = true
            newPockemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/2.png")
            newPockemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/shiny/4.png")
            newPockemon.attack = 40
            newPockemon.defence = 40
            newPockemon.speed = 40
            newPockemon.specialAttack = 50
            newPockemon.specialDefence = 50
            newPockemon.hp = 50
            newPockemon.types = ["fire","fire"]
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "dex")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
