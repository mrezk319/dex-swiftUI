//
//  PokemonDetailsView.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 18/07/2025.
//

import SwiftUI

struct PokemonDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var pokemon: Pockemon
    @State private var showShiny: Bool = true
    var body: some View {
        ScrollView{
            if pokemon.shinyImage == nil || pokemon.spriteImage == nil{
                AsyncImage(url:showShiny ?  pokemon.shinyURL : pokemon.spriteURL){ image in
                image.resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: .infinity, height: 400)
            .background( Image(pokemon.background)
                .resizable()
                .frame(width: .infinity, height: 400)
                .scaledToFit()
            )
            .padding(.bottom)
            } else {
                (showShiny ?  pokemon.shinyImage! : pokemon.spriteImage!)
                    .resizable()
                    .scaledToFit()
                    .shadow(radius: 10)
                    .frame(width: .infinity, height: 400)
                    .background( Image(pokemon.background)
                        .resizable()
                        .frame(width: .infinity, height: 400)
                        .scaledToFit()
                    )
                    .padding(.bottom)
            }
            
            
            
            HStack {
                ForEach(pokemon.types ?? ["None"], id: \.self) { element in
                    Text(element)
                        .padding(.horizontal,10)
                        .padding(.vertical,4)
                        .background(Color(element.capitalized))
                        .clipShape(Capsule())
                }
                Spacer()
                Button(action: {
                    pokemon.favourite.toggle()
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                }) {
                    Image(systemName: !pokemon.favourite ? "star" : "star.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .tint(
                    pokemon.favourite ? .gray : .yellow
                )
            }
            .padding(.horizontal)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
            Text("Stats")
                .font(.largeTitle)
            
            StatsView(pokemon: pokemon)
        }
        .navigationTitle(pokemon.name!)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        self.showShiny.toggle()
                    }
                }label: {
                    Image(systemName: showShiny ? "wand.and.stars":"wand.and.stars.inverse")
                        .tint(pokemon.typeColor)
                        .symbolEffect(.pulse)
                    
                        
                }
            }
        }
    }
}

#Preview {
    NavigationStack{
        PokemonDetailsView()
            .environmentObject(PersistenceController.previewPokemon)
    }
}
