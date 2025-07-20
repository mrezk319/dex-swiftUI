//
//  StatsView.swift
//  dex
//
//  Created by Muhammed Rezk Rajab on 19/07/2025.
//

import SwiftUI
import Charts
 
struct StatsView: View {
    var pokemon: Pockemon
    var body: some View {
        Chart(pokemon.stats, id: \.name) { stat in
            BarMark(
                x: .value("Value", stat.value),
                y: .value("Name", stat.name.capitalized),
            )
            .annotation (position: .trailing ){
                Text("\(stat.value)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, -5 )
            }
        }
        .frame(height: 250)
        .padding(.horizontal)
        .chartXScale(domain: 0...pokemon.heighstStat.value + 10)
        .foregroundStyle(pokemon.typeColor)
    }
}

#Preview {
    StatsView(pokemon: PersistenceController.previewPokemon)
}
