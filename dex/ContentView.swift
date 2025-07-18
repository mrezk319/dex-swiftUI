//
//  ContentView.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 10/07/2025.
//

import SwiftUI
import CoreData
 
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let fetcher = FetchPockemon()
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Pockemon.id)],
        animation: .default
    ) private var allPockemons: FetchedResults<Pockemon>
    @FetchRequest(
        sortDescriptors: [SortDescriptor(\Pockemon.id)],
        animation: .default
    ) private var pockemons: FetchedResults<Pockemon>
    
    @State private var searchText: String = ""
    @State private var showFavourite: Bool = false
    
    private var dynamicPredicate : NSPredicate {
        var predicates: [NSPredicate] = []
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "name contains[c] %@", searchText))
        }
        
        if showFavourite {
            predicates.append(NSPredicate(format: "favourite == true"))
        }
        
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    var body: some View {
            NavigationStack {
                List {Section{
                    ForEach(pockemons) { pockemon in
                        NavigationLink (value: pockemon) {
                            HStack{
                                AsyncImage(url: pockemon.sprite) { image in
                                    
                                    image.resizable()
                                        .scaledToFit()
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                
                                VStack (alignment: .leading){
                                    Text(pockemon.name!.capitalized)
                                        .bold()
                                    HStack {
                                        ForEach(pockemon.types ?? ["None"], id: \.self) { element in
                                            Text(element)
                                                .padding(.horizontal,10)
                                                .padding(.vertical,4)
                                                .background(Color(element.capitalized))
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                                if pockemon.favourite {
                                    Spacer()
                                    Image(systemName: "star.fill")
                                }
                                
                            }
                        }
                        .swipeActions (edge: .leading, allowsFullSwipe: true){
                             Button(action: {
                                pockemon.favourite.toggle()
                                 do {
                                     try viewContext.save()
                                 } catch {
                                     print(error)
                                 }
                            }) {
                                Image(systemName: pockemon.favourite ? "star" : "star.fill")
                            }
                            .tint(
                                pockemon.favourite ? .gray : .yellow
                            )
                        }
                    }
                } footer:{
                    if allPockemons.count < 100 {
                        ContentUnavailableView {
                            Label("Content unavailable", image: .nopokemon)
                        }description: {
                            Text("There are not any pokemons\nPlease try again later")
                        }
                        actions: {
                            Button("Reload") {
                                fetchPockemon()
                            }
                        }
                    }
                }
                }
                .searchable(text: $searchText, prompt:"Find a pokemon")
                .autocorrectionDisabled()
                .onChange(of: searchText,{
                    pockemons.nsPredicate = dynamicPredicate
                })
                .onChange(of: showFavourite, {
                    pockemons.nsPredicate = dynamicPredicate
                })
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pockemon.self, destination: { pockemon in
                    Text("Pockemons at \(pockemon.id)")
                })
                .toolbar {
                    ToolbarItem {
                        Button{
                            showFavourite.toggle()
                        }label: {
                            Label("Filter stared item", systemImage: showFavourite ? "star.fill":"star")
                        }
                    }
                }
            }
             
    }
    
    func fetchPockemon() {
        Task {
            for i in 1...152 {
                do {
                    let newPok = try await fetcher.fetch(id: i)
                    let pokemon = Pockemon(context: viewContext)
                    pokemon.id = Int16(newPok.id)
                    pokemon.types = newPok.types.map({$0.type.name})
                    pokemon.name = newPok.name
                    pokemon.attack = Int16(newPok.stats[1].baseStat)
                    pokemon.hp = Int16(newPok.stats[0].baseStat)
                    pokemon.defence = Int16(newPok.stats[2].baseStat)
                    pokemon.specialAttack = Int16(newPok.stats[3].baseStat)
                    pokemon.specialDefence = Int16(newPok.stats[4].baseStat)
                    pokemon.speed = Int16(newPok.stats[5].baseStat)
                    pokemon.shiny = URL(string: newPok.sprites.frontShiny.isEmpty ? "" : newPok.sprites.frontShiny)
                    pokemon.sprite = URL(string: newPok.sprites.backShiny.isEmpty ? "" : newPok.sprites.backShiny)
                    if newPok.id % 2 == 0 {
                        pokemon.favourite = true
                    }
                    try? viewContext.save()
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
